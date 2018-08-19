class TypeDistribution < ActiveRecord::Base
  belongs_to :geography
  belongs_to :language

  # Scope Model
  scope :active, -> { where(state: true) }
  scope :idiom, ->(abbreviation = I18n.locale.to_s.split('_')[0]) { joins(:language).where(languages: {abbreviation: abbreviation}) }
end
