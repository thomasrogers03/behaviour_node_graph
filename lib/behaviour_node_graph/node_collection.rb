module BehaviourNodeGraph
  class NodeCollection
    include Graphing
    extend DefaultProperties

    OUTPUT_NODES = [:children].freeze

    attr_reader :id, :children, :context_type
    attr_accessor :context, :next_nodes

    def self.new_node(children, context_type = Context)
      new(SecureRandom.base64, children, context_type)
    end

    def self.output_nodes
      OUTPUT_NODES
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
        instructions.children = add_children_to_graph(graph, children)
        instructions.context_type = context_type unless context_type == Context
        add_next_nodes_to_graph(graph, instructions)
      end
    end

    def load_from_graph(graph, instructions, node_graph)
      @children = instructions.children.map do |child_id|
        Node.load_from_graph(graph, child_id, node_graph)
      end
      @context_type = instructions.context_type if instructions[:context_type]
      if instructions[:next_nodes]
        self.next_nodes = instructions[:next_nodes].map do |node|
          Node.load_from_graph(graph, node, node_graph)
        end
      end
    end

    def act
      executor = Executor.new(self.context ||= Context.new)
      children.each { |child| executor.execute(child) }
    end

  end
end
