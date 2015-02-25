module Serch
  # The Mappable module is a concern that can be included
  # into a model, that enables the mapping of fields and
  # nested model fields into a single hash map.
  #
  # @example Using Mappable to create a simple key-value hash map
  #
  #   map :last_post_author, [:post, 'last'], :author
  #   #=> object.post('last').author # Equivalent
  #
  # @example Using Mappable to create a number of attributes using the
  #   same method chain.
  #
  #   map [:created_at, :content, :author], :post, :comments, :first
  module Mappable

    extend ActiveSupport::Concern

    included do

      self.cattr_accessor :mappable_fields
      self.mappable_fields = {}

      self.cattr_accessor :map_paths
      self.map_paths = []

      def self.map(field, *chain)
        case field
        when Array
          field.each { |f| map(f, *(chain + [f])) }
        else
          mappable_fields[field.to_sym] = chain
        end
      end

      def self.map_from(*chain)
        map_paths << chain
      end

    end

    def to_map
      fields = Search::Mapping.new(self, self.class.mappable_fields)
      nested_maps.each { |map| fields.merge!(map) }
    rescue
      {}
    else
      fields
    end

    private

    # [[:company], [:company, :data], [:data]]
    def nested_maps
      self.class.map_paths.collect do |path|
        begin
          obj = self
          path.each { |key| obj = obj.send(key) }
          Search::Mapping.new(obj, obj.class.mappable_fields)
        rescue
          {}
        end
      end
    rescue
      []
    end

  end
end
