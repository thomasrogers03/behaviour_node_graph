module BehaviourNodeGraph
  module Node
    include Graphing

    attr_reader :id
    attr_accessor :context, :next_nodes

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
      include DefaultProperties

      def new_node(*args)
        new(SecureRandom.base64, *args)
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
        add_next_nodes_to_graph(graph, instructions)
      end
    end

    def load_from_graph(graph, instructions, node_graph)
      instructions[:attributes].each do |attribute, value|
        public_send(:"#{attribute}=", value)
      end
      load_next_nodes_from_graph(graph, instructions, node_graph)
    end
  end
end
