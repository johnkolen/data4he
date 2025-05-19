class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :person, inverse_of: :user, optional: true


  include MetaAttributes

  def add_builds!
  end

  def password_label
    "Password"
  end

  def password_str
    password
  end

  def password_pattern
    nil
  end

  def password_confirmation_label
    "Password Confirmation"
  end

  def password_confirmation_str
    password_confirmation
  end

  def password_confirmation_pattern
    nil
  end

  def remember_me_label
    "Remember me"
  end

  def role_label
    "Role"
  end

  ROLES = {
    0 => "None",
    1 => "Admin",
    2 => "Support",
    101 => "Recruiter",
    102 => "Registrar",
    103 => "Student",
    104 => "Faculty",
    105 => "Administration"
  }

  ROLES.each do |id, label|
    define_method "#{label.downcase}?" do
      role_id == id
    end
    const_set "Role#{label}", id
  end

  def role_str
    ROLES[role_id]
  end

  def role_options
    ROLES.map{|k,v| [v,k]}
  end
end
