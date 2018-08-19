class EntityCostCenter < ActiveRecord::Base
  belongs_to :entity
  belongs_to :cost_center
end
