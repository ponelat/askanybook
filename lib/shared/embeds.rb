# frozen_string_literal: true

require_relative './embed'

class Embeds
 
  def self.from_csv_s(csv_s)
    rows = CSV.parse(csv_s, headers: true)
    embeddings = rows.map do |row|
      id = row['id']
      content = row['content']
      tokens = Integer(row['tokens'])
      embedding_raw = row['embedding']
      embedding = embedding_raw.split(';').map { |n| Float(n) }
      { id: id, content: content, tokens: tokens, embedding: embedding }
    end
    Embeds.new(embeddings)
  end

  def self.similarity(embedding_a, embedding_b)
    cosine_similarity(embedding_a, embedding_b)
  end

  def get(id)
    @embeddings[id]
  end

  def similarity(id_0, id_1)
    em_0 = get(id_0).embedding
    em_1 = get(id_1).embedding
    Embeds.similarity(em_0, em_1)
  end

  # TODO: Replace with tiktoken_ruby
  # For now useing the very "rough mafths" of 6 chars per token (which includes whitespace)
  def self.split_into_tokens(str)
    str.chars.each_slice(6).map(&:join)
  end

  def initialize(list_of_embeds)
    @length = list_of_embeds.length
    @embeddings = {}
    list_of_embeds.each do |row|
      e = Embed.new(row)
      @embeddings[e.id] = e
    end
  end

  def get_best_context_for(embedding, max_tokens)
    # Using an array makes it easier to deal with space between context
    # ...instead of context += ' ' + content
    contexts = []
    tokens_in_context = 0

    closest_ids(embedding).each do |id|
      next_embedding = get(id)
      tokens = next_embedding.tokens
      content = next_embedding.content

      # Add whole context, as we have space
      if tokens_in_context + tokens <= max_tokens
        contexts << next_embedding.content

        tokens_in_context += next_embedding.tokens

      # Handle interpolation case
      elsif tokens_in_context < max_tokens
        # Approximate
        percentage = (0.0 + max_tokens - tokens_in_context) / tokens
        chars_to_keep = (percentage * content.length).floor
        contexts << content.truncate(chars_to_keep, omission: '')
        tokens_in_context = max_tokens
        break

      # No more space
      else
        break
      end
    end
    contexts.join(' ')
  end

  attr_reader :length

  # TODO: Replace with vector DB.
  def closest_ids(embedding)
    @embeddings.values
               .sort_by { |e| Embeds.similarity(embedding, e.embedding) }
               .map(&:id)
               .reverse
  end

  def to_csv_s
    CSV.generate do |csv|
      csv << %w[id content tokens embedding]
      @embeddings.map do |_id, e|
        csv << [e.id, e.content, e.tokens, e.embedding.join(';')]
      end
    end
  end

  # Credit: ChatGPT, modified
  # Note: requires that the vectors are already normalized to 1. You can call ".normalize_vector" if you don't know.
  def self.cosine_similarity(a, b)
    # Calculate the dot product of the two vectors
    dot_product = a.zip(b).map { |a, b| a * b }.reduce(:+)

    # Calculate the L2 norm of each vector
    norm_1 = Math.sqrt(a.map { |v| v**2 }.reduce(:+))
    norm_2 = Math.sqrt(b.map { |v| v**2 }.reduce(:+))

    # Calculate the cosine similarity between the two vectors
    dot_product / (norm_1 * norm_2)
  end

  # OpenAI already normalizes their embedding vectors to 1, but for testing purpose (since I can't be arsed for the math), we re-normalize to one.
  # PS: L2 normalized to 1 = sum of all squares of all elements = 1
  # Credit: ChatGPT
  def self.normalize_vector(vector)
    # Calculate the L2 norm of the vector
    l2_norm = Math.sqrt(vector.map { |v| v**2 }.reduce(:+))

    # Divide each value in the vector by the L2 norm
    vector.map { |v| v / l2_norm }
  end
end
