# frozen_string_literal: true

require 'openai'
# require 'stopwords'

# Docs for embeddings: https://platform.openai.com/docs/guides/embeddings/what-are-embeddings
class OpenaiMagic

  ChatCompletionResponse = Struct.new(:answer, :usage, keyword_init: true)
  EmbeddingResponse = Struct.new(:embedding, :usage, keyword_init: true)
  Usage = Struct.new(:prompt_tokens, :completion_tokens, :total_tokens)

  # Downcase, remove punctiation and stop words (the,a).
  def self.sanitize_text(text)
    text = text.downcase
    # Remove punctuation and special characters
    text = text.gsub(/[^\w\s]/, '')
    # Collapses words
    # TODO: add back stopword filter
    text.split(' ').join(' ')
  end

  # TODO: Replace with tiktoken_ruby
  def self.token_count(text)
    text.length / 4 # This is 'quick-mafths'. Should be using tiktoken
  end

  def initialize(api_key)
    @client = OpenAI::Client.new(access_token: api_key)
  end

  def get_completion(str)
    # TODO: Add response error handling
    puts 'OpenAI: Getting completion'
    str = OpenaiMagic.sanitize_text(str)
    response = @client.chat(
      parameters: {
        model: 'gpt-3.5-turbo', # Required.
        messages: [{ role: 'user', content: str }], # Required.
        temperature: 0.0
      }
    )
    answer = response.dig('choices', 0, 'message', 'content')
    usage_j = response['usage']
    usage = Usage.new(
      usage_j['prompt_tokens'],
      usage_j['completion_tokens'],
      usage_j['total_tokens']
    )
    ChatCompletionResponse.new(answer:, usage:)
  end

  def get_embedding(str)
    puts 'OpenAI: Getting embedding'
    # TODO: Account for max tokens (i.e., EMBEDDINGS_MAX_TOKENS)
    # TODO: Add response error handling 
    str = OpenaiMagic.sanitize_text(str)
    response = @client.embeddings(
      parameters: {
        model: 'text-embedding-ada-002',
        input: str
      }
    )

    # Throw error if needed
    # PS: Not a fan of the trailing "unless" pattern.
    error_res = response.dig('error')
    if !error_res.nil?
      raise OpenaiMagicError.new(400, { message: error_res['message'], type: error_res['type'] })
    end

    embedding = response.dig('data', 0, 'embedding')

    usage_j = response['usage']
    usage = Usage.new(
      usage_j['prompt_tokens'],
      usage_j['completion_tokens'],
      usage_j['total_tokens']
    )

    EmbeddingResponse.new(
      embedding:,
      usage:
    )


  end

  ## Example Responses
  # {
  #   "error": {
  #     "message": "This model's maximum context length is 8191 tokens, however you requested 8363 tokens (8363 in your prompt; 0 for the completion). Please reduce your prompt; or completion length.",
  #     "type": "invalid_request_error",
  #     "param": null,
  #     "code": null
  #   }
  # }
  class Error < StandardError
    attr_reader :status, :type,:message, :param, :code

    def initialize(status, error)
      @status = status
      @type = error[:type]
      @message = error[:message]
    end

    def to_s
      "OpenAI API Error #{@type}: {@message}"
    end
  end
end
