module BehaviourNodeGraph

  def self.define_simple_node(*attributes, &block)
    if attributes.any?
      Struct.new(*attributes) do
        include Node
        define_method(:act) do
          block.call.tap { super() }
        end
      end
    else
      Class.new do
        include Node
        define_method(:act) do
          block.call.tap { super() }
        end
        define_method(:to_h) { {} }

        def ==(rhs)
          rhs.is_a?(self.class) && id == rhs.id
        end
      end
    end
  end

end
