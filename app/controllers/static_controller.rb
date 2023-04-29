class StaticController < ApplicationController
  include ActionView::Rendering

  def index
    # Render SPA frontend
    render file: Rails.root.join('public', 'index.html')
  end
end
