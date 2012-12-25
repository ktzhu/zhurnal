class Quote
  include Mongoid::Document

  field :content, type: String
  field :speaker, type: String
end
