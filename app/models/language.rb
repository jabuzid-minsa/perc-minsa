class Language < ActiveRecord::Base
  # Model validations
  validates :abbreviation, uniqueness: { case_sensitive: false }, presence: true, length: { maximum: columns_hash['abbreviation'].limit }
  validates :name, uniqueness: { case_sensitive: false }, presence: true, length: { maximum: columns_hash['name'].limit }

  # Scope of the model
  scope :active, -> {where(state: true)}

  def current_idiom
    I18n.locale.split('_')[0]
  end
end
