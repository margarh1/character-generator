class Skill < ApplicationRecord
  belongs_to :character, dependent: :destroy
end
