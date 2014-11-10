class User < ActiveRecord::Base
  has_many :favorites
  has_many :products, :through => :favorites

  def self.all_except(user)
    where.not(id: user)
  end
end
