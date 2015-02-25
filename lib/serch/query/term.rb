module Serch
  class Query < Hash
    class Term < Hash

      attr_accessor :index

      def initialize(val, index)
        self.index = index
        self[:query] = query_body(val)
      end

      private

      def query_body(body)
        {
          multi_match: {
            query: body[:query],
            type: "phrase_prefix",
            fields: parse_fields(body[:fields].dup)
          }
        }
      end

      def parse_fields(fields)
        fields.map! do |field|
          case field
          when Array
            field.map { |f| parse_key *f }
          when Hash
            parse_fields [field.to_a]
          else
            parse_key(field)
          end
        end

        fields.flatten!

        fields
      end

      def parse_key(key, boost=1)
        "#{index}.#{key}^#{boost}"
      end

    end
  end
end
