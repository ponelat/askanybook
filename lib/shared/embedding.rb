require 'active_model'

class Embedding
  include ActiveModel::Model

  attr_accessor :id, :content, :embedding

  validates :id, presence: true
  validates :content, presence: true
  validates :embedding, presence: true
end
