class Favorite < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  scope :train, -> {where(label: true)}
end
