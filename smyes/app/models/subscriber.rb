class Subscriber < ActiveRecord::Base
  validates :phone, :presence => true, :uniqueness => true,
					  :format => { :with => /^0\d{10}$/ }
	validates :name, :presence => true
end
