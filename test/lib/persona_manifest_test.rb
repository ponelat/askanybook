# frozen_string_literal: true

require 'test_helper'

class PersonaTest < ActiveSupport::TestCase
  require 'shared/persona_manifest'

  test '.from_csv_s should return new instance from string' do
    csv = "embeds_path,prompt_template\n.\/embeds.csv,this is $$context and a $$question"
    manifest = PersonaManifest.from_csv_s(csv)
    assert_equal './embeds.csv', manifest.embeds_path
    assert_equal 'this is $$context and a $$question', manifest.prompt_template
  end


  test '#to_csv_s should return str for csv file' do
    manifest = PersonaManifest.new(embeds_path: '/path/to/embeds.csv', prompt_template: 'foo')
    csv = manifest.to_csv_s
    assert_equal "embeds_path,prompt_template\n/path/to/embeds.csv,foo\n", csv
  end


  test '#to_csv_s should escape newlines' do
    manifest = PersonaManifest.new(embeds_path: '/path/to/embeds.csv', prompt_template: "foo\nbar")
    csv = manifest.to_csv_s
    assert_equal "embeds_path,prompt_template\n/path/to/embeds.csv,foo\\nbar\n", csv
  end

end
