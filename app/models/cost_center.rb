class CostCenter < ActiveRecord::Base
  belongs_to :cost_center
  belongs_to :geography
  belongs_to :language
  belongs_to :staff
  belongs_to :supply
  belongs_to :cost_distribution
  belongs_to :primary_production_unit, :class_name => 'ProductionUnit'
  belongs_to :secondary_production_unit, :class_name => 'ProductionUnit'
  belongs_to :tertiary_production_unit, :class_name => 'ProductionUnit'
  belongs_to :quaternary_production_unit, :class_name => 'ProductionUnit'
  belongs_to :quinary_production_unit, :class_name => 'ProductionUnit'
  has_many :entity_cost_centers
  has_many :entities, :through => :entity_cost_centers
  has_many :programming_hours
  has_many :production_cost_centers
  has_many :distribution_costs

  # Array allowed functions
  enum function: [:administrative_support, :logistical_support, :care_support, :final]

  # Model validations
  validates :code, presence: true, length: { maximum: columns_hash['code'].limit }
  validates :description, presence: true, length: { maximum: columns_hash['description'].limit }
  validates :definition, length: { maximum: columns_hash['definition'].limit }
  validates :function, :inclusion => {:in => CostCenter.functions}
  validates :geography_id, presence: true
  validates :language_id, presence: true
  validates :state, inclusion: { in: [ true, false ] }
  validates :code, uniqueness: { scope: [:code, :geography_id] }

  # Scope Model
  scope :active, -> { where(state: true) }
  scope :idiom, ->(abbreviation = I18n.locale.to_s.split('_')[0]) { joins(:language).where(languages: {abbreviation: abbreviation}) }
  scope :final_centers, -> { where(function: self.functions[:final]) }
  scope :groupers, -> { where(cost_center_id: [0, nil]) }
  scope :selectable, -> { where.not(cost_center_id: [0, nil]) }
  scope :available_for_country, ->(country_ids) { where(geography_id: country_ids) }
  scope :with_function, ->(function) { where( function: function ) }

  scope :cost_centers_available, ->(entity_id=0) {
    where.not(id: EntityCostCenter.where(entity_id: entity_id).select(:cost_center_id).uniq)
  }

  scope :associated_cost_centers, ->(entity_id=0, function=0) {
    joins(:entity_cost_centers).where(:entity_cost_centers => {:function => function, :entity_id => entity_id})
  }

  scope :for_entity, ->(entity_id) {
    joins(:entities).where( :entities => { id: entity_id } )
  }

  scope :finals, -> { where(function: self.functions[:final]) }
  scope :supports, -> { where(function: [ self.functions[:administrative_support], self.functions[:care_support], self.functions[:logistical_support] ]) }

  scope :selectable, -> { where.not(cost_center_id: nil) }
  #
  def self.order_priority
    order('CASE WHEN cost_centers.function = 3 THEN 1 WHEN cost_centers.function = 2 THEN 2 WHEN cost_centers.function = 1 THEN 3 WHEN cost_centers.function = 0 THEN 4 END')
  end

  def self.order_distribution
    order('CASE WHEN cost_centers.function = 3 THEN 4 WHEN cost_centers.function = 2 THEN 3 WHEN cost_centers.function = 1 THEN 1 WHEN cost_centers.function = 0 THEN 2 END, cost_centers.code DESC')
  end
end
