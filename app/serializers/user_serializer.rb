class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar_url, :token, :created_at, :updated_at
end
