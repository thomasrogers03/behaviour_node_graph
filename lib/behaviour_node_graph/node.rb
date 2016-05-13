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
      def new_node(*args)
        new(SecureRandom.base64, *args)
      end
    end

    def initialize(id, *args)
      @id = id
      super(*args)
    end

    def add_to_graph(graph)
      graph[id] ||= Instructions.new(id: id, node_type: self.class, attributes: to_h).tap do |instructions|
        if next_node
          next_node.add_to_graph(graph)
          instructions.next_node = next_node.id
        end
      end
    end

    def act
      if next_node
        next_node.context = context
        next_node.act
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
