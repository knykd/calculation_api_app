class ApplicationController < ActionController::API
  # 200 Success
  def response_success(class_name, action_name, result)
    render status: 200, json: { status: 200, message: "Success #{class_name.capitalize} #{action_name.capitalize}", data: result }
  end

  # 400 Bad Request
  def response_bad_request
    render status: 400, json: { status: 400, message: 'Bad Request' }
  end
end
