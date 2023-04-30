# frozen_string_literal: true

# TODO: Replace with tiktoken_ruby
# For now useing the very "rough mafths" of 6 chars per token (which includes whitespace)
class Tokenizer
  MAGIC_NUMBER = 6.0

  def self.count_tokens(str)
    str.length / MAGIC_NUMBER
  end

  def self.split_into_tokens(str)
    str.chars.each_slice(MAGIC_NUMBER).map(&:join)
  end
end
