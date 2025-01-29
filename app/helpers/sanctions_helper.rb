module SanctionsHelper
  def legal_basis_links(legal_basis)
    return if legal_basis.blank?
    
    legal_basis.split(/[,;]\s*/).map do |directive|
      if directive =~ /\((?:UE|EU)\)\s*(\d{4})[\/\\](\d+)/i
        year = $1
        number = $2
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
