require "test_helper"

class AskControllerTest < ActionDispatch::IntegrationTest
  fixtures :questions

  test "POST /ask should reject missing question in request body" do
    post ask_path(question: nil)

    response_json = JSON.parse(response.body)

    assert_equal 400, response_json['status']
    assert_equal 'Bad Request', response_json['title']
    assert_equal 'param is missing or the value is empty: question', response_json['detail']
  end

  test 'POST /ask should raise an error if question is over 700 characters in length' do
    LIMIT = 700.0
    token = ' word'
    question_s = (token * 140) + '1'
    assert_equal 701, question_s.length # want to limit to 100 tokens (so hard limit of 100 * 7 = 700 characters)

    post ask_path(question: question_s)

    response_json = JSON.parse(response.body)

    assert_equal 400, response_json['status']
    assert_equal 'Bad Request', response_json['title']
    assert_equal 'Question is over the maximum length of 700', response_json['detail']
  end

  test 'POST /ask should use cached question if it exists' do
    post ask_path(question: 'how are you doing?')
    response_json = JSON.parse(response.body)
    assert_equal 'just fine', response_json['answer']
    assert_equal 2, response_json['asked_count'] # Two to account for this time its being asked

  end

  test 'POST /ask should bypass cache if no question exists' do
    skip 'Need to stub out openai service'
    post ask_path(question: 'what is the time')
    response_json = JSON.parse(response.body)
    assert_equal 'just fine', response_json['answer']
    assert_equal 2, response_json['asked_count'] # Two to account for this time its being asked
  end
end
