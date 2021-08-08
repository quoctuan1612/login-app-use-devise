class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :confirmable, authentication_keys: [:login]

  # validate username
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validate :validate_username

  # validate phone
  validates :phone, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :phone, with: /^[0-9]*$/, :multiline => true
  validate :validate_phone


  attr_writer :login

  def login
    @login || self.username || self.email || self.phone
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value OR phone = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  def validate_username
    if User.where(email: username, phone: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def validate_phone
    if User.where(username: phone).exists?
      errors.add(:phone, :invalid)
    end
  end
end
