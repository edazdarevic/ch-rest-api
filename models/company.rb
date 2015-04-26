require 'paper_trail'

class Company < ActiveRecord::Base
  has_paper_trail
  validates_presence_of :name, :address, :city, :country
  has_many :passports
end
