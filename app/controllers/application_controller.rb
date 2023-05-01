# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from StandardError, with: :render_problem

  private

  def render_problem(exception)
    problem = {
      title: 'Internal Server Error',
      status: 500,
      detail: exception.message
    }
    render json: problem, status: 500
  end
end
