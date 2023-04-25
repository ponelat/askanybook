require 'test_helper'

class EmbeddingsTest <  ActiveSupport::TestCase
  require 'shared/embeddings'

  # Note: OpenAI already normalizes their embeddings to L2 = 1.
  # For testing arbitrary vectors, you'll need to normalize beforehand.
  near_a = Embeddings.normalize_vector([1,1]) 
  near_b = Embeddings.normalize_vector([1,2])
  far_a = Embeddings.normalize_vector([1,999])
  far_b = Embeddings.normalize_vector([1,900])

  # Contains IDs: apple, banana, ostrich, giraffe, newspaper, fruit, animal, yellow.
  # The last three (fruit, animal, yewllo) are treated like questions.
  # basic_fixture = CSV.read('../fixtures/basic.embeddings.csv', headers: true)


  test '.similarity near_a -> near_b greater than near_a -> far_a' do
    assert Embeddings.similarity(near_a, near_b) > Embeddings.similarity(near_a, far_a)
  end

  test '.similarity near_b -> near_a greater than near_b -> far_a' do
    assert Embeddings.similarity(near_b, near_a) > Embeddings.similarity(near_b, far_a)
  end

  test '.similarity far_a -> far_b greater than far_a -> near_a' do
    assert Embeddings.similarity(far_a, far_b) > Embeddings.similarity(far_a, near_a)
  end

  test '.new should accept a list of maps' do
    one = {id: '1', content: 'one', embedding: [0.1, -0.9]}
    two = {id: '2', content: 'two', embedding: [0.1, -0.9]}
    embeds = Embeddings.new([one, two])
    assert_equal(embeds.length, 2)
  end

  # TODO: Change to JSON serialization, its cleaner (CSV can have different flavours)
  test '#to_csv_s should produce string CSV' do
    apple = {id: 'a', content: 'apple', embedding: [0.1, -0.900000000000003]}
    embeds = Embeddings.new([apple])
    assert_equal("id,content,embedding\na,apple,0.1;-0.900000000000003\n", embeds.to_csv_s) # Not sure about the extra newline, but CSV.generate adds it so...
  end

  test '.from_csv_s should hydrate a new Embeddings from string CSV' do
    embeds = Embeddings.from_csv_s( "id,content,embedding\na,apple,0.1;-0.9\n")
    assert_equal(embeds.length, 1)
  end


end
