class Character < ApplicationRecord
  belongs_to :user
  has_many :traits
  has_many :skills
end
