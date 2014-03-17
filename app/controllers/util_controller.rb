class UtilController < ApplicationController
    
    def handle_redirect
        redirect_to params[:url]
    end
    
end
