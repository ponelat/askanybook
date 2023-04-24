require "test_helper"

class OpenAIMagicTest < ActiveSupport::TestCase
  require_dependency "shared/openai_magic"

  test ".sanitize_text should downcase" do
    assert_equal("apple", OpenAIMagic.sanitize_text('AppLE'))
  end

  # TODO: Consider addding stopwords back or completely remove
  # Stop words might be too powerful. They removed "one", for some reason. 
  # test ".sanitize_text should remove stop words" do
  #   assert_equal("juicy apple", OpenAIMagic.sanitize_text('this is a juicy apple'))
  # end

  test ".sanitize_text should remove punctuation" do
    assert_equal("juicy apple", OpenAIMagic.sanitize_text('juicy -> apple.'))
  end

  test ".sanitize_text should remove newlines" do
    assert_equal("juicy apple", OpenAIMagic.sanitize_text("juicy \n\n apple."))
  end

end
