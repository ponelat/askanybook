require 'openai'
require 'stopwords'

# Docs for embeddings: https://platform.openai.com/docs/guides/embeddings/what-are-embeddings

class OpenAIMagic

  # For text-embedding-ada-002
  EMBEDDINGS_DIMENSIONS = 1536 # Number of columns in the embeddings
  # EMBEDDINGS_MAX_TOKENS = 8191 # Number of tokens accepted as input

  def initialize(api_key)
    @client = OpenAI::Client.new(access_token: api_key)
  end

  def get_completion(str)
    # TODO: Add response error handling
    str = OpenAIMagic.sanitize_text(str)
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required.
        messages: [{ role: "user", content: str}], # Required.
        temperature: 0.0,
      })
    response.dig("choices", 0, "message", "content")
  end

  def get_embedding(str)
    # TODO: Account for max tokens (i.e., EMBEDDINGS_MAX_TOKENS)
    # TODO: Add response error handling
    str = OpenAIMagic.sanitize_text(str)
    response = @client.embeddings(
        parameters: {
          model: "text-embedding-ada-002",
          input: str
        }
    )
    response.dig("data", 0, "embedding")
  end

  # Downcase, remove punctiation and stop words (the,a).
  def self.sanitize_text(text)
    text = text.downcase
    # Remove punctuation and special characters
    text = text.gsub(/[^\w\s]/, '')
    # Remove stop words (the, an, etc)
    text = text.split(' ').reject { |word|  Stopwords.is?(word) }.join(' ')
    return text
  end

end
