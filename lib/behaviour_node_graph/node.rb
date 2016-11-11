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
        if next_nodes
          instructions.next_nodes = add_children_to_graph(graph, next_nodes)
        end
      end
    end

    def load_from_graph(graph, instructions, node_graph)
      instructions[:attributes].each do |attribute, value|
        public_send(:"#{attribute}=", value)
      end
      if instructions[:next_nodes]
        self.next_nodes = instructions[:next_nodes].map do |node|
          Node.load_from_graph(graph, node, node_graph)
        end
      end
    end
  end
end
