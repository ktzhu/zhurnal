class Quote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :speaker, type: String

  validates_uniqueness_of :content
end
