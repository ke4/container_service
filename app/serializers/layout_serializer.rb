# See README.md for copyright details

class LayoutSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :locations
end
