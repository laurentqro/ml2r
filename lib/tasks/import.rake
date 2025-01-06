namespace :import do
  desc "TODO"
  task occupations: :environment do
  end
end

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
end
