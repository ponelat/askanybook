# frozen_string_literal: true

class HealthController < ApplicationController
  def index
    # raise 'Something'
    render json: { ok: true }
  end

end
