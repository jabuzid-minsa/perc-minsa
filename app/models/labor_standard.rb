class LaborStandard < ActiveRecord::Base
  belongs_to :geography

  # Scope Model
  scope :active, -> { where(state: true) }
  scope :for_country, ->(country_id) { where(geography_id: country_id) }
end
