namespace :import do
  desc "Import ISCO occupations from CSV"
  task occupations: :environment do
    require "csv"

    CSV.foreach("lib/isco.csv", headers: true, encoding: "ISO-8859-1:UTF-8") do |row|
      Occupation.create!(
        major: row["major"],
        major_label: row["major_label"],
        sub_major: row["sub_major"],
        sub_major_label: row["sub_major_label"],
        minor: row["minor"],
        minor_label: row["minor_label"],
        unit: row["unit"],
        description: row["description"]
      )
    end
  end

  desc "Import sanctioned people and entities"
  task sanctioned: :environment do
    BusinessRelationship.delete_all
    Person.delete_all
    Company.delete_all

    Sanction.where(nature: "Personne physique").all.each do |sanction|
      p = Person.create!(
        last_name: sanction.last_name,
        first_name: sanction.first_name,
        country_of_birth: sanction.place_of_birth,
        nationality: sanction.nationality
      )

      BusinessRelationship.create!(clientable: p)
    end

    Sanction.where(nature: "Personne morale").all.each do |sanction|
      c = Company.create!(name: sanction.last_name)

      BusinessRelationship.create!(clientable: c)
    end
  end

  desc "Import Sanctions list"
  task sanctions: :environment do
    require "json"

    fetch_sanctions
    sanctions = JSON.parse(File.read("lib/sanctions.json"))

    Sanction.delete_all

    sanctions.each do |sanction|
      Sanction.create!(
        nature: sanction["nature"],
        title: sanction["mesureDetails"]["titre"],
        last_name: sanction["nom"],
        first_name: sanction["mesureDetails"]["prenom"],
        sex: sanction["mesureDetails"]["sexe"],
        date_of_birth: sanction["mesureDetails"]["dateNaissance"],
        place_of_birth: sanction["mesureDetails"]["lieuNaissance"],
        nationality: sanction["mesureDetails"]["nationalite"],
        address: sanction["mesureDetails"]["adresse"],
        alias: sanction["mesureDetails"]["alias"],
        authority: sanction["mesureDetails"]["autoriteMesure"],
        motive: sanction["mesureDetails"]["motifs"],
        legal_basis: sanction["mesureDetails"]["fondementJuridique"],
        additional_info: sanction["mesureDetails"]["autresInfos"],
        expiration_date: sanction["mesureDetails"]["dateExpiration"]
      )
    end
  end
end

def fetch_sanctions
  require "net/http"
  require "uri"
  require "fileutils"

  url = URI("https://geldefonds.gouv.mc/directdownload/sanctions.json")
  file_path = File.join("lib", "sanctions.json")

  begin
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      # Force encoding to UTF-8 and handle invalid characters
      content = response.body.force_encoding("UTF-8")

      content = content.encode(
        "UTF-8",
        "UTF-8",
        invalid: :replace,
        undef: :replace,
        replace: ""
      )

      File.write(file_path, content)
      puts "Successfully saved sanctions.json to #{file_path}"
    else
      puts "Failed to download: #{response.code} #{response.message}"
    end
  rescue StandardError => e
    puts "Error: #{e.message}"
  end
end
