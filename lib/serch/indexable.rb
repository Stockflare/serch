module Serch
  # The Indexable module is a concern that allows the definition of indices
  # for a particular object. It also provides helper methods for creating
  # and updating the indices.
  #
  # By default, the Indexable module will create an index with the downcased
  # stringified name of the class it is included within, assuming the presence
  # of #id and #to_map methods.
  #
  # @example Using Indexable to define indexes with an inline class proc
  #   index :stock, -> (stock) { stock.to_map }
  #
  # @note The proc that is defined expects a single depth hash of
  #   key => values that will be sent as indexes to be searched over.
  #
  # @note An #id method will be used by default, to identify the index for
  #   a particular instance of an object
  module Indexable

    extend ActiveSupport::Concern

    included do

      self.cattr_accessor :index_name
      self.index_name = self.name.downcase

      self.cattr_accessor :indices
      self.indices = -> { to_map }

      self.cattr_accessor :index_ident
      self.index_ident = -> { id }

      def self.index(name, map=nil)
        self.index_name = name
        self.indices = map if map
      end

    end

    def create_index
      initialize_index.save
    end

    def update_index
      initialize_index.update
    end

    def destroy_index
      initialize_index.destroy
    end

    private

    def initialize_index
      Serch::Index.new(*index_parameters)
    end

    def index_parameters
      id = instance_exec &self.class.index_ident
      type = self.class.to_s.downcase
      body = instance_exec &self.class.indices
      name = self.class.index_name
      [name, type, id, body]
    end

  end
end
