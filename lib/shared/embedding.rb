require 'active_model'

class Embedding
  include ActiveModel::Model

  attr_accessor :id, :content, :embedding, :tokens

  validates :id, :string, presence: true
  validates :content,:string, presence: true
  validates :embedding, presence: true
  validates :tokens,:number, presence: true
end
