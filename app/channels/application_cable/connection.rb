module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Warden
    identified_by :current_user
 
    def connect
      self.current_user = find_verified_user
    end
 
    private

    def find_verified_user
      if verified_user = JWTAuth::UserDecoder.new.call(access_token, :user, nil)
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def access_token
      request.headers['Authorization'].gsub('Bearer ', '')
    end
  end
end
