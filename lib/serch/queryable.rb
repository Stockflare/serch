module Serch
  module Queryable

    extend ActiveSupport::Concern

    included do

      self.cattr_accessor :query_index_name
      self.query_index_name = self.name.downcase

      def self.query_index(name)
        self.query_index_name = name
      end

      self.cattr_accessor :query_search_fields
      self.query_search_fields = []

      def self.search_fields(*fields)
        self.query_search_fields = fields
      end

    end

    module ClassMethods

      # The #filter method expects an array of fields and conditions to be
      # passed into it. Similar to the following example.
      #
      # The keys :fields, :pagination and :sorting will be processed and
      # applied to the resulting query
      #
      # @example Filtering for prices greater than 23.45
      #   my_shop.filter({ fields: { price: { greater_than: 23.45 } })
      #
      # @note Once filtering has been performed, this method will attempt to
      #   retrieve a collection of matching IDs by using the #find function.
      #
      # @return [Array, Mixed] Array of matching objects retrieved using #where
      def filter(conditions = {})
        query = Serch::Query.new(self.query_index_name, conditions)
        perform_filter(query)
      end

      # The #aggregate method performs field aggregations that can be mixed in
      # with other filtering (similar to #filter producing averages).
      #
      # @note Currently the only mode supported is :average
      #
      # @return [Float] the returned number represents an aggregate of the field
      #   for the matching set of records as applied through conditions.
      def aggregate(field, mode, conditions = {})
        conditions.merge!({ aggregation: { field: field, type: mode } })
        filter(conditions).aggregations[field.to_sym]
      end

      def search(term, conditions = {})
        term = { term: { query: term, fields: self.query_search_fields } }
        filter conditions.merge(term)
      end

      private

      def perform_filter(query)
        Serch::Filter.new(self.query_index_name, query, :id, self)
      end

    end

  end
end
