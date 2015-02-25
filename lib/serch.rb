require 'elasticsearch'

require 'active_support/concern'
require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/string/inflections'
require 'active_support/inflector'

require 'serch/version'

# The {Serch} gem handles providing classes that facilitate the querying,
# updating, indexing and mapping of resources components to ElasticSearch.
module Serch

  extend ActiveSupport::Autoload

  autoload :Mappable
  autoload :Mapping

  autoload :Indexable
  autoload :Index

  autoload :Queryable
  autoload :Query

  autoload :Filter

  # @!attribute debug
  #   @!scope class
  #   Determines if Elasticsearch queries will be performed in debug mode.
  #   When set to true, all queries sent to Elasticsearch will be logged to
  #   STDOUT.
  #   @return [Boolean] True if debugging is enabled, false otherwise.
  mattr_accessor :debug
  self.debug = false

  # @!attribute host
  #   @!scope class
  #   The host address of Elasticsearch, without the port.
  #   @return [String] Host address of elasticsearch
  mattr_accessor :host
  self.host = false

  # @!attribute port
  #   @!scope class
  #   The port number that Elasticsearch is listening on
  #   @return [String] Port number of elasticsearch
  mattr_accessor :port
  self.port = 9200

  # Helper to configure the Search module.
  #
  # @yield [Search] Yields the {Search} module.
  def self.configure
    yield self
  end

  # Uses the bound connection to push an index up to the configured
  # external service.
  #
  # @return [Boolean] true if successful, false otherwise.
  def self.create(map)
    resp = connection.index(map)
    resp["created"]
  rescue
    false
  end

  # Uses the bound connection to update or upsert a new document into the
  # configured external service.
  #
  # @return [Boolean] true if successful, false otherwise.
  def self.update(map)
    resp = connection.update(map)
    true
  rescue
    false
  end

  # Uses the bound connection to delete an existing index that has been
  # previously created.
  #
  # @return [Boolean] true if successful, false otherwise.
  def self.delete(map)
    connection.delete(map)["found"]
  rescue
    false
  end

  def self.search(map)
    connection.search(map)
  end

  def self.connection
    @@connection ||= Elasticsearch::Client.new log: self.debug, host: "#{self.host}:#{self.port}"
  end

end
