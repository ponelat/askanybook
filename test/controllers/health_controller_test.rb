# frozen_string_literal: true

require 'test_helper'
require 'json'

class HealthControllerTest < ActionDispatch::IntegrationTest
  test 'should get health' do
    get health_url
    assert_response :success
    response_body = JSON.parse(response.body)
    assert_equal({ 'ok' => true }, response_body)
  end
end
