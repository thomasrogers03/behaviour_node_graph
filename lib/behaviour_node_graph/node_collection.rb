module BehaviourNodeGraph
  class NodeCollection
    attr_reader :id, :children
    attr_accessor :context

    def initialize(id, children)
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

  end
end