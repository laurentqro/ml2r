module ProspectsHelper

  def prospect_path(prospect)
    if prospect.is_a?(Person)
      person_path(prospect)
    else
      company_path(prospect)
    end
  end
end