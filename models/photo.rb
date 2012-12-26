class Photo
  include Mongoid::Document

  field :caption, type: String
  field :url, type: String

  validates_uniqueness_of :url
end
