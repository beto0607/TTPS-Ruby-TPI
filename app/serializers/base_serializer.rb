require 'jsonapi-serializers'

class BaseSerializer
    include JSONAPI::Serializer
  
    def base_url
      ''
    end

    def self_link
        "#{base_url}/#{type}/#{id}"
    end
    def relationship_self_link(attribute_name)
        
    end
    def relationship_related_link(attribute_name)
        
    end
  end
  
  