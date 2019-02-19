# Without this mimetype registration, controllers will not automatically parse JSON API params.
module JSONAPI
    MIMETYPE = "application/vnd.api+json"

#    MIMETYPE = "application/json"
end
Mime::Type.register(JSONAPI::MIMETYPE, :api_json)
  

ActionDispatch::Http::Parameters::DEFAULT_PARSERS[:api_json] = lambda do |body|
    JSON.parse(body)
end
ActionDispatch::Request.parameter_parsers = ActionDispatch::Request::DEFAULT_PARSERS