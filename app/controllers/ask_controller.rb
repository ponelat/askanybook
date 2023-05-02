# frozen_string_literal: true

class AskController < ApplicationController
  MAX_QUESTION_LENGTH_CHARS = 700

  def ask
    # TODO: Limit question to X characters/tokens. 
    question_param = params.require(:question)
    question_s = OpenaiMagic.sanitize_text(question_param)

    ai_magic = OpenaiMagic.new(ENV['OPENAI_API_KEY'])
    question = Question.find_by(question: question_s)

    if question.nil?
      
      if question_s.length >= MAX_QUESTION_LENGTH_CHARS
        raise ProblemJson.new(status: 400, title: 'Bad Request', detail: "Question is over the maximum length of #{MAX_QUESTION_LENGTH_CHARS}")
      end

      sahil = PersonaFromCsv.call('the-minimalist-entrepeneur')

      # Build up the prompt
      embedding_res = ai_magic.get_embedding(question_s + '?') ## Note: does double `?` make a difference?
      question_embed = Embed.new(
        id: '',
        content: question_s,
        tokens: embedding_res.usage.prompt_tokens,
        embedding: embedding_res.embedding
      )

      # The secrete sauce
      prompt = sahil.build_prompt(question_embed, 800)

      # Ask AI
      answer_res = ai_magic.get_completion(prompt)
      answer_s = answer_res.answer
      prompt_tokens = answer_res.usage.prompt_tokens
      answer_tokens = answer_res.usage.completion_tokens

      question = Question.create(
        question: question_s,
        answer: answer_s,
        prompt:,
        prompt_tokens:,
        answer_tokens:,
        asked_count: 1 
      )
    else
      question.asked_count += 1
      question.save
    end

    render json: {  answer: question.answer, asked_count: question.asked_count }

  end

end
