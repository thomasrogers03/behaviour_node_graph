module BehaviourNodeGraph

  def self.define_simple_node(*attributes, &block)
    if attributes.any?
      Struct.new(*attributes) do
        include Node
        extend NodeHelpers
        define_method(:act, &block)
      end
    else
      Class.new do
        include Node
        extend NodeHelpers
        define_method(:act, &block)
        define_method(:to_h) { {} }

        def ==(rhs)
          rhs.is_a?(self.class) && id == rhs.id
        end
      end
    end
  end

  module NodeHelpers
    attr_accessor :inputs, :outputs, :output_nodes

    def self.extended(base)
      base.inputs = []
      base.outputs = []
      base.output_nodes = []
    end
  end

end
