class StaticController < ApplicationController
  def index
    # Render SPA frontend
    render file: Rails.root.join('public', 'index.html')
  end
end
