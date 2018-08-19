class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Validations for paperclip
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>", small: "50x50" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  # Relationships for model
  belongs_to :geography
  has_and_belongs_to_many :entities
  has_and_belongs_to_many :networks

  # Array allowed roles
  enum role: [:global_administrator, :level_one_local_administrator, :level_two_local_administrator, :level_three_local_administrator,
              :level_one_manager, :level_two_manager, :level_three_manager, :level_one_operator, :level_two_operator, :level_three_operator, 
              :basic_administrator]

  # Model validations
  validates :role, inclusion: {in: roles.keys}

  # Methods to validate the role of the current user
  def is_global_administrator?
    self.role == 'global_administrator'
  end

  def is_basic_administrator?
    self.role == 'basic_administrator'
  end

  def is_level_one_local_administrator?
    self.role == 'level_one_local_administrator'
  end

  def is_level_two_local_administrator?
    self.role == 'level_two_local_administrator'
  end

  def is_level_three_local_administrator?
    self.role == 'level_three_local_administrator'
  end

  def is_level_one_manager?
    self.role == 'level_one_manager'
  end

  def is_level_two_manager?
    self.role == 'level_two_manager'
  end

  def is_level_three_manager?
    self.role == 'level_three_manager'
  end

  def is_level_one_operator?
    self.role == 'level_one_operator'
  end

  def is_level_two_operator?
    self.role == 'level_two_operator'
  end

  def is_level_three_operator?
    self.role == 'level_three_operator'
  end

  # Validation to verify if the current user is assigned a country and is different from id 1 (all countries)
  def is_valid_geography?
    self.geography_id.present? and self.geography_id > Geography.get_record_of_all_countries.first.id
  end

  # Validation for session country_id, verifying that the value of the same is not null and in turn greater than 1 (id of all countries)
  def is_valid_session_country?(country_id)
    country_id.present? and country_id.to_i > Geography.get_record_of_all_countries.first.id
  end
end
