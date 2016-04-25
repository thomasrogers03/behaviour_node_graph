module BehaviourNodeGraph
  class NodeCollection
    attr_reader :id, :children
    attr_accessor :context

    def initialize(id, children = nil)
      @id = id
      @children = children
    end

    def add_to_graph(graph)
      graph[id] ||= begin
        Instructions.new.tap do |instructions|
          instructions.node_type = NodeCollection
          instructions.id = id
          instructions.children = children.map do |child|
            child.add_to_graph(graph)
            child.id
          end
        end
      end
    end

    def load_from_graph(graph, instructions, node_graph)
      @children = instructions.children.map do |child_id|
        Node.load_from_graph(graph, child_id, node_graph)
      end
    end

  end
end