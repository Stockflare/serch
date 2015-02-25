module Serch
  class Query < Hash

    extend ActiveSupport::Autoload

    autoload :Field
    autoload :Term
    autoload :Sorting
    autoload :Pagination
    autoload :Aggregation

    attr_accessor :index

    def initialize(index, raw = {})
      @index = index
      append! raw
    end

    def append!(raw = {})
      raw.each do |key, val|
        deep_merge! self.class.const_get(key.to_s.singularize.camelize).new(val, index)
      end
    end

  end
end
