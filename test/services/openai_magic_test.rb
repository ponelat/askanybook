# frozen_string_literal: true

require 'test_helper'

class OpenaiMagicTest < ActiveSupport::TestCase

  test '.sanitize_text should downcase' do
    assert_equal('apple', OpenaiMagic.sanitize_text('AppLE'))
  end

  # TODO: Consider addding stopwords back or completely remove
  # Stop words might be too powerful. They removed "one", for some reason.
  # test ".sanitize_text should remove stop words" do
  #   assert_equal("juicy apple", OpenaiMagic.sanitize_text('this is a juicy apple'))
  # end

  test '.sanitize_text should remove punctuation' do
    assert_equal('juicy apple', OpenaiMagic.sanitize_text('juicy -> apple.'))
  end

  test '.sanitize_text should remove newlines' do
    assert_equal('juicy apple', OpenaiMagic.sanitize_text("juicy \n\n apple."))
  end

  # TODO: replace with tiktoken_ruby
  test '.token_count should return number of tokens in str' do
    assert_equal OpenaiMagic.token_count('one two three four five'), 5
  end
end
