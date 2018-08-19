class Entity < ActiveRecord::Base
  belongs_to :care_level
  belongs_to :geography
  has_and_belongs_to_many :networks
  has_and_belongs_to_many :staffs
  has_and_belongs_to_many :supplies
  has_and_belongs_to_many :users
  has_many :entity_cost_centers
  has_many :cost_centers, :through => :entity_cost_centers

  # Array allowed functions
  enum payroll_type: [:consolidated, :detailed]

  # Scope Model
  scope :active, -> { where(state: true) }
  scope :available_for_country, ->(numerical_code) {
    joins(:geography).where(:geographies => { numerical_code: numerical_code})
  }

  scope :for_users, ->(user) {
    joins(:users).where(:users => { id: user })
  }

  scope :for_networks, ->(network_id) {
    joins(:networks).where(:networks => { id: network_id })
  }
end
