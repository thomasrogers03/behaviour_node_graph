module BehaviourNodeGraph
  module Node
    attr_reader :id
    attr_accessor :context

    def self.load_from_graph(graph, node_id)
      instructions = graph[node_id]
      instructions.node_type.new(node_id).tap do |node|
        instructions[:attributes].each do |attribute, value|
          node.public_send(:"#{attribute}=", value)
        end
      end
    end

    def initialize(id, *args)
      @id = id
      super(*args)
    end

    def add_to_graph(graph)
      graph[id] ||= Instructions.new(id: id, node_type: self.class, attributes: to_h)
    end
  end
end
