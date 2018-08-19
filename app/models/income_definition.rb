class IncomeDefinition < ActiveRecord::Base
  belongs_to :cost_center
  belongs_to :entity

  scope :invoice, -> { where(invoice: true) }
  scope :for_entity, ->(entity_id) { where(entity_id: entity_id) }
end
