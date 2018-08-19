class Network < ActiveRecord::Base
  belongs_to :geography
  has_and_belongs_to_many :entities
  has_and_belongs_to_many :users

  # Scope Model
  scope :active, -> { where(state: true) }
  
  scope :available_for_country, ->(numerical_code) {
    joins(:geography).where(:geographies => { numerical_code: numerical_code})
  }

  scope :for_users, ->(user) {
    joins(:users).where(:users => { id: user })
  }
end
