class Room < ApplicationRecord
  has_many :new_model, dependent: :destroy
  has_many :room_problem, dependent: :destroy
end
