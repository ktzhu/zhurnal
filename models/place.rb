class Place
  include Mongoid::Document

  field :name, type: String
  field :person, type: String
  # field :geotag or is this coordinates idk look at 4sq API later
end
