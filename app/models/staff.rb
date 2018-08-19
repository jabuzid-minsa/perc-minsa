class Staff < ActiveRecord::Base
  belongs_to :staff
  belongs_to :geography
  belongs_to :language
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
  scope :groupers, -> { where(staff_id: [0, nil]) }
  scope :children, -> (parent=0){ where(staff_id: parent) }
  scope :for_country, -> (country_id=0){ where(geography_id: [0, country_id]) }
  scope :child, -> { where.not(staff_id: [0, nil]) }
  scope :selectable, -> { where.not(staff_id: [0, nil]) }
  scope :available_for_country, ->(country_ids) { where(geography_id: country_ids) }

  scope :for_entity, ->(entity_id) {
    joins(:entities).where( :entities => { id: entity_id } )
  }
end
