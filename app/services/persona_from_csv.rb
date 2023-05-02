# frozen_string_literal: true

class PersonaFromCsv
  def self.call(name)
    # TODO: Move into singleton or into an initilizer so this doesn't get called each invocation
    manifest_path  = Rails.root.join('books', "#{name}.manifest.csv")
    manifest_csv = File.read(manifest_path)
    manifest = PersonaManifest.from_csv_s(manifest_csv)
    embeds_abs_path = Rails.root.join('books', manifest.embeds_path)
    embeds_csv = File.read(embeds_abs_path)
    embeds = Embeds.from_csv_s(embeds_csv)
    Persona.new(embeds: embeds, template: manifest.prompt_template)
  end
end
