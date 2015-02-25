module Serch
  # The {Mapping} class returns a Hash object that can be used to send to
  # an external service. It contains all the mappings and nested mappings
  # that have been defined.
  #
  # @example Using Mapping to retrieve values
  #   class Test
  #     def created
  #       Time.now.to_i
  #     end
  #
  #     def post_creator
  #       "Dave"
  #     end
  #
  #     def comments
  #       # => []
  #     end
  #   end
  #
  #   test = Test.new
  #
  #   map = Mapping.new(test, {
  #     author: [:post_creator],
  #     num_of_comments: [:comments, :count]
  #     created: nil
  #   })
  class Mapping < Hash

    def initialize(object, mappings)
      mappings.each do |key, chain|
        self[key] = if chain && chain.count > 0
          follow_chain(object, chain)
        else
          object.send(key)
        end
      end
    end

    private

    def follow_chain(obj, chain)
      chain.each do |action|
        if obj
          obj = respond_to_action(obj, action)
        else
          break
        end
      end
    rescue
      nil
    else
      obj
    end

    def respond_to_action(obj, action)
      case action
      when Symbol
        obj.send(action)
      when Array
        obj.send(*action)
      else
        nil
      end
    rescue
      nil
    end

  end
end
