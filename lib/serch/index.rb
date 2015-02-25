module Serch
  # The {Index} class handles creating and updating indexes within the
  # search object that has been bound to the {Serch} module. It has
  # an external dependence upon this object being defined.
  class Index < Hash

    attr_reader :name, :type, :id

    def initialize(name, type, id, body)
      @name = name
      @type = type
      @id = id
      merge! body
    end

    # Return this index as the hash that will be sent to an external service
    # The hash returned maps the individual elements of this Hash into the
    # expected format.
    #
    # @return [Hash] formatted hash ready to be transmitted
    def index(update = false)
      {
        index: name,
        type: type,
        id: id,
        body: (!update ? to_h : { doc: to_h })
      }
    end

    # Update or create the index on Elasticsearch
    #
    # @return [Boolean] true if successful, false otherwise.
    def update
      Serch.update(index(true))
    rescue
      false
    end

    # Save the index to an external service.
    #
    # @note This method is dependent upon the wrapper provided by the
    #   {Serch} module.
    #
    # @return [Boolean] true if successful, false otherwise.
    def save
      Serch.create(index)
    rescue
      false
    end

    def destroy
      Serch.delete(index)
    rescue
      false
    end

  end
end
