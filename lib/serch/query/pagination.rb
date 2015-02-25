module Serch
  class Query < Hash
    class Pagination < Hash

      def initialize(val, index = nil)
        self[:from] = offset val[:per_page], val[:page]
        self[:size] = val[:per_page]
      end

      private

      def offset(per_page, page = 0)
        per_page * (page > 0 ? page - 1 : page)
      end

    end
  end
end
