class ApplicationController < ActionController::API
    include Knock::Authenticable
    include JSONAPI::ActsAsResourceController


    def token_from_request_headers
        unless request.headers['X-QA-Key'].nil?
            request.headers['X-QA-Key'].split.last
        end
    end
end
