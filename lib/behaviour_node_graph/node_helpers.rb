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
      end
    end
  end

end
