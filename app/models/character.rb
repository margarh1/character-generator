class Character < ApplicationRecord
  belongs_to :user
  has_many :traits, dependent: :destroy
  has_many :skills, dependent: :destroy

  validates :name, presence: true

end
