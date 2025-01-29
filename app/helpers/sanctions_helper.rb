module SanctionsHelper
  def legal_basis_links(legal_basis)
    return '' if legal_basis.blank?
    
    legal_basis.split(/[,;]\s*/).map do |directive|
      # Match directive with date: (UE) XXX/YYY du DD/MM/YYYY
      if directive =~ /\((?:UE|EU)\)\s*(\d{1,4})[\/\\](\d{1,4}).*?du\s*\d{2}\/\d{2}\/(\d{4})/i
        num1, num2, date_year = $1.to_i, $2.to_i, $3.to_i
        
        # Use the year that matches the date
        if num1 == date_year
          year, number = num1, num2
        elsif num2 == date_year
          year, number = num2, num1
        else
          next directive.strip # If no match found, return text without link
        end
        
        link_to(
          directive.strip,
          "https://eur-lex.europa.eu/eli/reg/#{year}/#{number}/oj/eng",
          target: '_blank',
          rel: 'noopener noreferrer'
        )
      else
        directive.strip
      end
    end.join(', ').html_safe
  end
end 
