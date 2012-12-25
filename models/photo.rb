class Photo
  include Mongoid::Document

  field :title, type: String
  field :caption, type: String
  field :url, type: String
end
