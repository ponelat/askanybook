require 'active_model'

class Persona
  include ActiveModel::Model
  include ActiveModel::Attributes
  # include ActiveModel::Validations

  attribute :template, :string, default: "$$context $$question"

  # # TODO: Add Embeddings type
  # attribute :embeddings
  # validates :embeddings, presence: true

  # TODO: Handle double-replacing (in the event that "context" includes the token "$$question")
  def self.fill_template(str, context, question)
    str.gsub('$$question', question).gsub('$$context', context)
  end

end
