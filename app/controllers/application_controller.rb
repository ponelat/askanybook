# frozen_string_literal: true

class ApplicationController < ActionController::API

  rescue_from Exception, with: :render_standard
  rescue_from StandardError, with: :render_standard
  rescue_from OpenaiMagic::Error, with: :render_openai_magic
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing

  # Basic Authenciation 
  if Rails.env.production? and ENV['HTTP_BASIC_USERNAME']
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    http_basic_authenticate_with name: ENV['HTTP_BASIC_USERNAME'], password: ENV['HTTP_BASIC_PASSWORD'] # except: :index
  end


  class ProblemJson < StandardError
    attr_reader :status, :title, :detail, :instance

    def initialize(status: 500, title:, detail:, instance: nil)
      @status = status
      @title = title
      @detail = detail
      @instance = instance
    end

    def to_h
      {
        status: @status,
        title: @title,
        detail: @detail,
        instance: @instance
      }
    end
  end

  rescue_from ProblemJson, with: :render_problem

  private

  def render_problem(problem)
    render json: problem.to_h, status: problem.status
  end

  def render_parameter_missing(exception)
    problem = ProblemJson.new(
      title: 'Bad Request',
      status: 400,
      detail: exception.message
    )
    render_problem(problem)
  end

  private

  def render_standard(exception)
    problem = ProblemJson.new(
      title: 'Internal Server Error',
      status: 500,
      detail: exception.message
    )
    render_problem(problem)
  end


  def render_openai_magic(exception)
    problem = ProblemJson.new(
      title: 'OpenAI API Error',
      status: exception.status,
      detail: exception.message+ "\n#{exception.type}"
    )
    render_problem(problem)
  end

end
