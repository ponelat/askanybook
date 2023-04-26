require "test_helper"

class PersonaTest <  ActiveSupport::TestCase
  require 'shared/persona'

  test '.fill_template should replace $$content and $$question' do
    str = Persona.fill_template('hello $$context and $$question', 'foo', 'bar')
    assert_equal 'hello foo and bar', str
  end

end
