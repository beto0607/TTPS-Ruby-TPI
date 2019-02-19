class ApplicationController < ActionController::API
    include Knock::Authenticable
    include JSONAPI::ActsAsResourceController

    def token_from_request_headers
        unless request.headers['X-QA-Key'].nil?
            request.headers['X-QA-Key'].split.last
        end
    end

    def render_response resource_class, resource, fields, status = :ok
        render json: JSONAPI::ResourceSerializer.new(
                resource_class,
                fields: fields
            ).serialize_to_hash(resource_class.new(resource, nil)), 
            status: status

    end

    rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
        error = {}
        error[parameter_missing_exception.param] = ['parameter is required']
        response = { errors: [error] }
        render json: response, status: :bad_request
    end
end
