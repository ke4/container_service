# See README.md for copyright details

class LocationSerializer < ActiveModel::Serializer
  attributes :id, :name

  belongs_to :layout
end
