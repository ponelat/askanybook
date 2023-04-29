# frozen_string_literal: true

require 'active_model'

class Persona
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :template, :string, default: '$$context $$question'
  attribute :template_tokens, :string, default: '$$context $$question'
  # TODO: Use proper class types
  attribute :embeds

  def initialize(embeds:, template:)
    @embeds = embeds
    @template = template
    template_without_placeholders = Persona.fill_template(template, '', '')
    @template_tokens = Tokenizer.count_tokens(template_without_placeholders)
  end

  # TODO: Handle double-replacing (in the event that "context" includes the token "$$question")
  def self.fill_template(str, context, question)
    str.gsub('$$question', question).gsub('$$context', context)
  end

  def build_prompt(question_embed, max_tokens)
    tokens_left = max_tokens - question_embed.tokens - @template_tokens
    context = @embeds.get_best_context_for(question_embed.embedding, tokens_left)
    question = question_embed.content
    Persona.fill_template @template, context, question
  end
end
