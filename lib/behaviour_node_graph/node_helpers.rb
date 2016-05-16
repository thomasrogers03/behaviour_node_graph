module BehaviourNodeGraph

  def self.define_simple_node(*attributes, &block)
    if attributes.any?
      Struct.new(*attributes) do
        include Node
        define_method(:act, &block)
      end
    else
      Class.new do
        include Node
        define_method(:act, &block)
        define_method(:to_h) { {} }

        def ==(rhs)
          rhs.is_a?(self.class) && id == rhs.id
        end
      end
    end
  end

end
