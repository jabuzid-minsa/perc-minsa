class ContractType < ActiveRecord::Base
  belongs_to :geography

  # Scope Model
  scope :active, -> { where(state: true) }
  scope :for_country, ->(country_id) { where(geography_id: [1, country_id]) }
end
