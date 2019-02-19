class ApplicationController < ActionController::API
    include Knock::Authenticable

    def token_from_request_headers
        unless request.headers['X-QA-Key'].nil?
            request.headers['X-QA-Key'].split.last
        end
    end

    rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
        error = {}
        error[parameter_missing_exception.param] = ['parameter is required']
        response = { errors: [error] }
        render json: response, status: :bad_request
    end

    def render_json object={}, status
        render json: object, status: status
    end

    # Convenience methods for serializing models:
    def serialize_model(model, options = {})
        options[:is_collection] = false
        JSONAPI::Serializer.serialize(model, options)
    end

    def serialize_models(models, options = {})
        options[:is_collection] = true
        JSONAPI::Serializer.serialize(models, options)
    end

    def serialize_errors errors
        JSONAPI::Serializer.serialize_errors(errors)
    end

end
