class Photo
  include Mongoid::Document

  field :caption, type: String
  field :url, type: String
end
