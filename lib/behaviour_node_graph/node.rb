module BehaviourNodeGraph
  module Node
    attr_reader :id
    attr_accessor :context, :next_node

    def self.load_from_graph(graph, node_id, node_graph)
      node_graph[node_id] ||= begin
        instructions = graph[node_id]
        instructions.node_type.new(node_id).tap do |node|
          node.load_from_graph(graph, instructions, node_graph)
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      NO_INPUTS = [].freeze

      def new_node(*args)
        new(SecureRandom.base64, *args)
      end

      def inputs
        NO_INPUTS
      end

      def outputs
        NO_INPUTS
      end

      def output_nodes
        NO_INPUTS
      end

      def properties
        NO_INPUTS
      end
    end

    def initialize(id, *args)
      @id = id
      super(*args)
    end

    def add_to_graph(graph)
      unless graph[id]
        instructions = Instructions.new(id: id, node_type: self.class, attributes: to_h)
        graph[id] = instructions
        if next_node
          next_node.add_to_graph(graph)
          instructions.next_node = next_node.id
        end
      end
    end

    def load_from_graph(graph, instructions, node_graph)
      instructions[:attributes].each do |attribute, value|
        public_send(:"#{attribute}=", value)
      end
      self.next_node = Node.load_from_graph(graph, instructions.next_node, node_graph) if instructions[:next_node]
    end
  end
end
