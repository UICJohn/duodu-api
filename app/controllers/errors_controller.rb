class ErrorsController < ApplicationController
  def not_found
    error!({message: 'bad request'}, 404)
  end
end
