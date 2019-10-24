class Supply < ActiveRecord::Base
  belongs_to :supply
  belongs_to :geography
  belongs_to :language
  belongs_to :supplies_category
  has_and_belongs_to_many :entities

  # Model validations
  validates :code, presence: true, length: { maximum: columns_hash['code'].limit }
  validates :description, presence: true, length: { maximum: columns_hash['description'].limit }
  validates :definition, length: { maximum: columns_hash['definition'].limit }
  validates :geography_id, presence: true
  validates :language_id, presence: true
  validates :state, inclusion: { in: [ true, false ] }
  validates :code, uniqueness: { scope: [:code, :geography_id] }

  # Scope Model
  scope :active, -> { where(state: true) }
  scope :idiom, ->(abbreviation = I18n.locale.to_s.split('_')[0]) { joins(:language).where(languages: {abbreviation: abbreviation}) }
  scope :groupers, -> { where(supply_id: [0, nil]) }
  scope :children, -> (parent=0){ where(supply_id: parent) }
  scope :child, -> { where.not(supply_id: [0, nil]) }
  scope :selectable, -> { where.not(supply_id: [0, nil]) }
  scope :available_for_country, ->(country_ids) { where(geography_id: country_ids) }
  scope :only_supply, -> {
    where(supplies_category_id: [1, 3])
  }

  scope :for_entity, ->(entity_id) {
    joins(:entities).where( :entities => { id: entity_id } )
  }
end
