class Trait < ApplicationRecord
  belongs_to :character, dependent: :destroy
end
