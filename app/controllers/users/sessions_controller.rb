class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def wechat_auth
    if params[:code]
      response = Wechat::API.new.auth(params[:code])
      if @user = User.from_wechat({provider: 'wechat', uid: response["openid"], session_key: response["session_key"]})
        sign_in @user
      end
      render :template => "v1/profiles/show"
    end
  end

  private

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    head :no_content
  end

end
