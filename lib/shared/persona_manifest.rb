# frozen_string_literal: true

require 'active_model'

class PersonaManifest
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :embeds_path, :string
  validates :embeds_path, presence: true


  attribute :prompt_template, :string
  validates :prompt_template, presence: true

  def self.from_csv_s(csv_s)
    rows = CSV.parse(csv_s, headers: true)
    first = rows[0]
    embeds_path = first['embeds_path']
    prompt_template = first['prompt_template']
    PersonaManifest.new(embeds_path: embeds_path, prompt_template: prompt_template)
  end

  def to_csv_s()
    CSV.generate do |csv|
      csv << %w[embeds_path prompt_template]
      csv << [embeds_path, prompt_template]
    end
  end

end
