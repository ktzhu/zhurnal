class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :caption, type: String
  field :url, type: String

  validates_uniqueness_of :url

  scope :recent, order_by(:created_at => :desc)
end
