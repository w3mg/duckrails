class Duckrails::Mock < ActiveRecord::Base
  has_many :headers
  has_one :body

  validates :status, presence: true
  validates :method, presence: true
  validates :route_path, presence: true
  validates :name, presence: true
  validates :body_type, inclusion: { in: %w(static dynamic) }

  def dynamic?
    body_type == 'dynamic'
  end
end
