# frozen_string_literal: true

require 'test_helper'

class PersonaTest < ActiveSupport::TestCase
  require 'shared/persona'

  one = Embeds.normalize_vector([1,1])
  two = Embeds.normalize_vector([1,2])
  three = Embeds.normalize_vector([1,3])
  four = Embeds.normalize_vector([1,4])

  # content = Embeds.from_csv_s(File.read('test/fixtures/files/basic.content.embeds.csv'))
  # subjects = Embeds.from_csv_s(File.read('test/fixtures/files/basic.subjects.embeds.csv'))
  embeds = Embeds.new(
    [{ id: 'one   ', tokens: 1, content: 'one', embedding: one },
     { id: 'two   ', tokens: 1, content: 'two', embedding: two },
     { id: 'three ', tokens: 1, content: 'three', embedding: three },
     { id: 'four  ', tokens: 1, content: 'four', embedding: four }]
  )

  test '.fill_template should replace $$content and $$question' do
    str = Persona.fill_template('hello $$context and $$question', 'foo', 'bar')
    assert_equal 'hello foo and bar', str
  end

  test 'build_prompt should take an embedding and return prompt' do
    persona = Persona.new(embeds: embeds, template: 'Intro. $$context. $$question')

    question_embed = Embed.new(
      id: 'five',
      content: 'five__',
      tokens: 1,
      embedding: Embeds.normalize_vector([1, 5])
    )

    prompt = persona.build_prompt(question_embed, 6)
    assert_equal 'Intro. four three two . five__', prompt
  end

end
