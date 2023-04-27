# frozen_string_literal: true

class HealthController < ApplicationController
  def index
    render json: { ok: true }
  end
end
