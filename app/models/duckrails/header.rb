class Duckrails::Header < ActiveRecord::Base
  belongs_to :mock

  validates :name, presence: true
  validates :value, presence: true
  validates :mock, presence: true
end
