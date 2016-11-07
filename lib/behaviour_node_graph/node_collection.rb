module BehaviourNodeGraph
  class NodeCollection
    include Graphing

    attr_reader :id, :children, :context_type
    attr_accessor :context, :next_node

    def self.new_node(children, context_type = Context)
      new(SecureRandom.base64, children, context_type)
    end

    def initialize(id, children = nil, context_type = Context)
      @id = id
      @children = children
      @context_type = context_type
    end

    def add_to_graph(graph)
      add_node_to_graph(graph) do |instructions|
        instructions.node_type = self.class
        instructions.id = id
        instructions.children = children.map do |child|
          child.add_to_graph(graph)
          child.id
        end
        instructions.context_type = context_type unless context_type == Context
        if next_node
          next_node.add_to_graph(graph)
          instructions.next_node = next_node.id
        end
      end
    end

    def load_from_graph(graph, instructions, node_graph)
      @children = instructions.children.map do |child_id|
        Node.load_from_graph(graph, child_id, node_graph)
      end
      @context_type = instructions.context_type if instructions[:context_type]
      self.next_node = Node.load_from_graph(graph, instructions.next_node, node_graph) if instructions[:next_node]
    end

    def act
      executor = Executor.new(self.context ||= Context.new)
      children.each { |child| executor.execute(child) }
    end

  end
end
