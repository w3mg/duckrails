class Duckrails::Mock < ActiveRecord::Base
  BODY_TYPE_EMBEDDED_RUBY = 'embedded_ruby'
  BODY_TYPE_STATIC = 'static'

  has_many :headers
  accepts_nested_attributes_for :headers, allow_destroy: true, reject_if: :all_blank

  has_one :body

  validates :status, presence: true
  validates :method, presence: true
  validates :route_path, presence: true
  validates :name, presence: true
  validates :body_type, inclusion: { in: [BODY_TYPE_STATIC,
                                          BODY_TYPE_EMBEDDED_RUBY],
                                     allow_blank: true },
                        presence: true

  def dynamic?
    body_type != BODY_TYPE_STATIC
  end
end
