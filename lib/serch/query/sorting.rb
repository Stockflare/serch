module Serch
  class Query < Hash
    class Sorting < Hash

      def initialize(val, index = nil)
        self[:sort] = sorting(val)
      end

      private

      def sorting(values = {})
        values.to_a.collect do |key, value|
          if value
            { key => value }
          else
            key
          end
        end
      end

    end
  end
end
