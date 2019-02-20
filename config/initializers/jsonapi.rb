JSONAPI.configure do |c|
    c.allow_include = false
    c.always_include_to_one_linkage_data = false
    c.json_key_format = :underscored_key
end
