module Serch
  class Query < Hash
    class Field < Hash

      attr_accessor :index

      def initialize(fields, index)
        terms = []

        self.index = index
        fields.each do |key, value|
          terms << case value
          when Hash
            parse_hash(key, value)
          when Array
            parse_array(key, value)
          when /\*/
            parse_wildcard(key, value)
          when NilClass
            parse_nil(key)
          else
            parse_query(key, value)
          end
        end

        self[:query] = { bool: { must: terms } } unless terms.empty?
      end

      private

      def parse_key(key)
        "#{index}.#{key}"
      end

      def parse_nil(key)
        { filtered: { filter: { missing: { field: parse_key(key), null_value: true } } } }
      end

      def parse_array(key, body)
        { filtered: { filter: { terms: { key => body } } } }
      end

      def parse_hash(key, body)
        { range: { parse_key(key) => parse_hash_body(body) } }
      end

      def parse_query(key, val)
        { query_string: { default_field: parse_key(key), query: val } }
      end

      def parse_wildcard(key, val)
        { wildcard: { parse_key(key) => val } }
      end

      def parse_hash_body(hash)
        parsed = {}
        hash.each do |key, value|
          case key
          when :greater_than
            parsed[:gt] = value
          when :less_than
            parsed[:lt] = value
          end
        end
        parsed
      end

    end
  end
end
