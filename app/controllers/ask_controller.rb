# frozen_string_literal: true

class AskController < ApplicationController

  def ask
    question = params.require(:question)

    ai_magic = OpenaiMagic.new(ENV['OPENAI_API_KEY'])

    # Create Persona from csv file
    manifest_path  = Rails.root.join('books', 'the-minimalist-entrepeneur.manifest.csv')
    manifest_csv = File.read(manifest_path)
    manifest = PersonaManifest.from_csv_s(manifest_csv)
    embeds_abs_path = Rails.root.join('books', manifest.embeds_path)
    embeds_csv = File.read(embeds_abs_path)
    embeds = Embeds.from_csv_s(embeds_csv)
    persona = Persona.new(embeds: embeds, template: manifest.prompt_template)

    # Build up the prompt
    embedding_res = ai_magic.get_embedding(question + '?') ## Note: does double `?` make a difference?
    question_embed = Embed.new(
      id: '',
      content: question,
      tokens: embedding_res.usage.prompt_tokens,
      embedding: embedding_res.embedding
    )
    prompt = persona.build_prompt(question_embed, 800)

    # Ask AI
    answer_res = ai_magic.get_completion(prompt)

    render json: { answer: answer_res.answer, tokens: answer_res.usage.total_tokens }

  end
end
