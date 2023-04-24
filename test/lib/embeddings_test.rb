require "test_helper"

class EmbeddingsTest <  ActiveSupport::TestCase
  require 'shared/embeddings'

  # Note: OpenAI already normalizes their embeddings to L2 = 1.
  # For testing arbitrary vectors, you'll need to normalize beforehand.
  near_a = Embeddings.normalize_vector([1,1]) 
  near_b = Embeddings.normalize_vector([1,2])
  far_a = Embeddings.normalize_vector([1,999])
  far_b = Embeddings.normalize_vector([1,900])

  test ".similarity near_a -> near_b greater than near_a -> far_a" do
    assert Embeddings.similarity(near_a, near_b) > Embeddings.similarity(near_a, far_a)
  end

  test ".similarity near_b -> near_a greater than near_b -> far_a" do
    assert Embeddings.similarity(near_b, near_a) > Embeddings.similarity(near_b, far_a)
  end

  test ".similarity far_a -> far_b greater than far_a -> near_a" do
    assert Embeddings.similarity(far_a, far_b) > Embeddings.similarity(far_a, near_a)
  end

end
