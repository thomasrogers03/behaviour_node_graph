module BehaviourNodeGraph

  def self.define_simple_node(*attributes, &block)
    if attributes.any?
      Struct.new(*attributes) do
        include Node
        include ChildNodeExecution
        extend NodeHelpers

        define_method(:act) do
          result = instance_exec(&block)
          execute_nodes(next_nodes)
          result
        end
      end
    else
      Class.new do
        include Node
        include ChildNodeExecution
        extend NodeHelpers

        define_method(:act) do
          result = instance_exec(&block)
          execute_nodes(next_nodes)
          result
        end

        define_method(:to_h) { {} }

        def ==(rhs)
          rhs.is_a?(self.class) && id == rhs.id
        end
      end
    end
  end

  module NodeHelpers
    attr_accessor :inputs, :outputs, :output_nodes, :properties

    def self.extended(base)
      base.inputs = []
      base.outputs = []
      base.output_nodes = []
      base.properties = []
    end
  end

end
