class User < ApplicationRecord
  has_many :characters, dependent: :destroy

  validates :username, presence: true
  validates :email, length: { maximum: 255 }, presence: true, format: { with: /\w+@\w+\.\w+/}, uniqueness: true
  validates :password, length: { maximum: 72 }, presence: true, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  has_secure_password

end
