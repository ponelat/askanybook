# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from Exception, with: :render_standard
  rescue_from StandardError, with: :render_standard
  rescue_from OpenaiMagicError, with: :render_openai_magic
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing

  private

  def render_parameter_missing(exception)
    problem = {
      title: 'Bad Request',
      status: 400,
      detail: exception.message
    }
    render json: problem, status: 400
  end

  private

  def render_standard(exception)
    problem = {
      title: 'Internal Server Error',
      status: 500,
      detail: exception.message
    }
    render json: problem, status: 500
  end


  def render_openai_magic(exception)
    problem = {
      title: 'OpenAI API Error',
      status: exception.status,
      detail: exception.message+ "\n#{exception.type}"
    }
    render json: problem, status: 500
  end


end
