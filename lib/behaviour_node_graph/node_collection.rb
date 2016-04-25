module BehaviourNodeGraph
  class NodeCollection
    attr_reader :id, :children, :context_type
    attr_accessor :context

    def initialize(id, children = nil, context_type = Context)
      @id = id
      @children = children
      @context_type = context_type
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
          instructions.context_type = context_type unless context_type == Context
        end
      end
    end

    def load_from_graph(graph, instructions, node_graph)
      @children = instructions.children.map do |child_id|
        Node.load_from_graph(graph, child_id, node_graph)
      end
      @context_type = instructions.context_type if instructions[:context_type]
    end

    def act
      self.context ||= Context.new
      children.each do |child|
        child.context = context
        child.act
      end
    end

  end
end
