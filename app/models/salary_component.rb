class SalaryComponent < ActiveRecord::Base
  belongs_to :geography
  has_and_belongs_to_many :labor_laws

  # Scope Model
  scope :active, -> { where(state: true) }
  scope :available_for_country, ->(numerical_code) {
    joins(:geography).where(:geographies => { numerical_code: numerical_code})
  }
end
