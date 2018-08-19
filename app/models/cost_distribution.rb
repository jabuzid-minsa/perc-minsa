class CostDistribution < ActiveRecord::Base
  belongs_to :geography
  belongs_to :language

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
end
