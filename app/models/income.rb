class Income < ActiveRecord::Base
  audited
  belongs_to :cost_center
  belongs_to :entity

  # Scope Model
  scope :date, ->(year=Time.now.year, month=Time.now.month) { where(year: year, month: month) }
  scope :for_entity, ->(entity_id) { where(entity_id: entity_id) }
end
