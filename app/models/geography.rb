class Geography < ActiveRecord::Base
  has_many :entities

  # Model validations
  validates :numerical_code, presence: true, numericality: { only_integer: true }
  validates :first_level, presence: true, length: { maximum: 3 }
  validates :second_level, numericality: { only_integer: true }
  validates :third_level, numericality: { only_integer: true }
  validates :fourth_level, numericality: { only_integer: true }
  validates :fifth_level, numericality: { only_integer: true }
  validates :description, presence: true, length: { maximum: columns_hash['description'].limit }
  validates :depth_detail, allow_blank: true, numericality: { only_integer: true }, inclusion: { in: 0..5 }
  validates :state, inclusion: { in: [ true, false ] }
  validates :numerical_code, uniqueness: { scope: [:numerical_code, :second_level, :third_level, :fourth_level, :fifth_level] }

  # Scope of the model
  scope :active, -> {where(state: true)}
  scope :get_record_of_all_countries, -> { where( numerical_code: 0 ) }
  scope :record_all_countries, -> { where( numerical_code: 0 ) } # Delete
  scope :countries_including_zero, -> {where(second_level: 0)}
  scope :countries, -> {where.not(numerical_code: 0).where(second_level: 0)}
  scope :regions, -> {where.not(numerical_code: 0, second_level: 0).where(third_level: 0)}
  scope :departments, -> {where.not(numerical_code: 0, second_level: 0, third_level: 0).where(fourth_level: 0)}
  scope :municipalities, -> {where.not(numerical_code: 0, second_level: 0, third_level: 0, fourth_level: 0).where(fifth_level: 0)}
  scope :towns, -> {where.not(numerical_code: 0, second_level: 0, third_level: 0, fourth_level: 0, fifth_level: 0)}


end
