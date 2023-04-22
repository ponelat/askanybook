require 'openai'

class OpenAIMagic
  def initialize(api_key)
    @client = OpenAI::Client.new(access_token: api_key)
  end

  def get_completion(str)
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required.
        messages: [{ role: "user", content: str}], # Required.
        temperature: 0.0,
      })
    # TODO: Add error handling
    response.dig("choices", 0, "message", "content")
  end

  def get_embedding(str)
    [0.2, 0.4, 0.6]
  end
end
