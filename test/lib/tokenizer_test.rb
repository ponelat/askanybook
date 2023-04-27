# frozen_string_literal: true

require 'test_helper'

class TokenizerTest < ActiveSupport::TestCase
  require 'shared/tokenizer'

  test '.split_into_tokens should return list of tokens' do
    str = 'this is very naive'
    tokens = Tokenizer.split_into_tokens(str)
    assert_equal ['this i', 's very', ' naive'], tokens
  end

  test '.count_tokens should return number of tokens' do
    str = 'this is very naive'
    tokens = Tokenizer.split_into_tokens(str)
    length = Tokenizer.count_tokens(str)
    assert_equal length, tokens.length
  end

end
