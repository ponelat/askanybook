# frozen_string_literal: true

require_relative './embed'
require_relative './tokenizer'

class Embeds
  def self.from_csv_s(csv_s)
    rows = CSV.parse(csv_s, headers: true)
    embeddings = rows.map do |row|
      id = row['id']
      content = row['content']
      tokens = Integer(row['tokens'])
      embedding_raw = row['embedding']
      embedding = embedding_raw.split(';').map { |n| Float(n) }
      Embed.new(id: id, content: content, tokens: tokens, embedding: embedding)
    end
    Embeds.new(embeddings)
  end

  def self.similarity(embedding_a, embedding_b)
    dot_product(embedding_a, embedding_b)
  end

  def get(id)
    @embeddings[id]
  end

  def similarity(id0, id1)
    Embeds.similarity get(id0).embedding, get(id1).embedding
  end

  def initialize(list_of_embeds)
    @length = list_of_embeds.length
    @embeddings = {}
    list_of_embeds.each do |embed|
      @embeddings[embed.id] = embed
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
        contexts << Tokenizer.split_into_tokens(content)[0, max_tokens - tokens_in_context].join(' ')
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

  # Note: OpenAI already normalizes the embeddings
  # If you want to compare arbitrary vectors (like in testing), call normalise_vector on each vector first.
  def self.dot_product(vec_a, vec_b)
    # Calculate the dot product of the two vectors
    # Dot product of vectors. To be useful,
    vec_a.zip(vec_b).map { |a, b| a * b }.reduce(:+)
  end

  # PS: L2 normalized to 1 = sum of all squares of all elements = 1
  def self.normalize_vector(vector)
    # Calculate the L2 norm of the vector
    l2_norm = Math.sqrt(vector.map { |v| v**2 }.reduce(:+))

    # Divide each value in the vector by the L2 norm
    vector.map { |v| v / l2_norm }
  end
end
