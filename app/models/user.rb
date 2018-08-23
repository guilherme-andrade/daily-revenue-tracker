class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :daily_reports
  before_validation :set_email

  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable


  def set_email
    self.email = self.username + "@njord.li"
  end
end
