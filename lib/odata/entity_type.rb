module OData

  class EntityType
    attr_reader :name
    attr_reader :base_type
    attr_reader :abstract
    attr_reader :open_type
    attr_reader :has_stream

    def initialize(options)
      @name       = options[:name]
      @base_type  = options[:base_type]
      @abstract   = options[:abstract] || false
      @has_stream = options[:has_stream] || false
      @open_type  = options[:open_type]
    end
  end
end
