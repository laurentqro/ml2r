FactoryBot.define do
  # Company Risk Factors Definitions
  factory :person_client_risk_factor_definition, class: "RiskFactorDefinition" do
    category { "client_risk" }
    description { "Subject of legal proceedings" }
    score { 25 }
    entity_type { "Person" }
    identifier { "subject_of_legal_proceedings" }
  end

  factory :person_products_and_services_risk_factor_definition, class: "RiskFactorDefinition" do
    category { "products_and_services_risk" }
    description { "New build sale" }
    score { 25 }
    entity_type { "Person" }
    identifier { "new_build_sale" }
  end

  factory :person_distribution_channel_risk_factor_definition, class: "RiskFactorDefinition" do
    category { "distribution_channel_risk" }
    description { "Remote relationship" }
    score { 25 }
    entity_type { "Person" }
    identifier { "remote_relationship" }
  end

  factory :person_transaction_risk_factor_definition, class: "RiskFactorDefinition" do
    category { "transaction_risk" }
    description { "Means of payment" }
    score { 25 }
    entity_type { "Person" }
    identifier { "means_of_payment" }
  end

  factory :company_client_risk_factor_definition, class: "RiskFactorDefinition" do
    category { "client_risk" }
    description { "Subject of legal proceedings" }
    score { 25 }
    entity_type { "Company" }
    identifier { "subject_of_legal_proceedings" }
  end

  factory :company_products_and_services_risk_factor_definition, class: "RiskFactorDefinition" do
    category { "products_and_services_risk" }
    description { "New build sale" }
    score { 25 }
    entity_type { "Company" }
    identifier { "new_build_sale" }
  end

  factory :company_distribution_channel_risk_factor_definition, class: "RiskFactorDefinition" do
    category { "distribution_channel_risk" }
    description { "Remote relationship" }
    score { 25 }
    entity_type { "Company" }
    identifier { "remote_relationship" }
  end

  factory :company_transaction_risk_factor_definition, class: "RiskFactorDefinition" do
    category { "transaction_risk" }
    description { "Means of payment" }
    score { 25 }
    entity_type { "Company" }
    identifier { "means_of_payment" }
  end
end
