module Serch
  class Query < Hash
    class Aggregation < Hash

      def initialize(val, index = nil)
        self[:aggs] = {
          val[:field] => {
            type(val[:type]) => {
              field: val[:field]
            }
          }
        }
      end

      private

      def type(type)
        case type.to_sym
        when :average
          :avg
        end
      end

    end
  end
end
