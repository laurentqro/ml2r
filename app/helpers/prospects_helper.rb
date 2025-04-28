module ProspectsHelper
  def prospect_path(prospect, options = {})
    if prospect.is_a?(Person)
      person_path(prospect, options)
    else
      company_path(prospect, options)
    end
  end
end
