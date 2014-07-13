class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar_url, :created_at, :access_token
end
