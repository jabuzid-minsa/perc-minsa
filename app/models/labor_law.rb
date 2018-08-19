class LaborLaw < ActiveRecord::Base
  belongs_to :staff
  belongs_to :labor_standard
  belongs_to :contract_type
  belongs_to :entity
  has_and_belongs_to_many :salary_components

  # Scope Model
  scope :active, -> { where(state: true) }
  scope :for_entity, ->(entity_id) { where(entity_id: entity_id) }
end
