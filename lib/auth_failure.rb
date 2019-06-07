class AuthFailure < Devise::FailureApp
  def respond
    json_error_response
  end

  private
  def json_error_response
    self.status = 401
    self.content_type = "application/json"
    self.response_body = { code: 401, error: i18n_message }.to_json
  end
end