module BehaviourNodeGraph
  class Condition
    include Graphing

    INPUTS = [:condition].freeze
    OUTPUTS = [].freeze
    OUTPUT_NODES = [:true, :false].freeze

    attr_reader :id, :true_node, :false_node, :condition_source, :next_node
    attr_accessor :context

    def self.new_node(true_node, false_node, condition_source)
      new(SecureRandom.base64, true_node, false_node, condition_source)
    end

    def self.inputs
      INPUTS
    end

    def self.outputs
      OUTPUTS
    end

    def self.output_nodes
      OUTPUT_NODES
    end

    def self.properties
      OUTPUTS
    end

    def initialize(id, true_node = nil, false_node = nil, condition_source = nil)
      @id = id
      @true_node = true_node
      @false_node = false_node
      @condition_source = condition_source
    end

    def add_to_graph(graph)
      add_node_to_graph(graph) do |instructions|
        instructions.node_type = self.class
        instructions.id = id

        true_node.add_to_graph(graph)
        instructions.true_node = true_node.id

        false_node.add_to_graph(graph)
        instructions.false_node = false_node.id

        instructions.condition_source = condition_source
      end
    end

    def load_from_graph(graph, instructions, node_graph)
      @true_node = Node.load_from_graph(graph, instructions.true_node, node_graph)
      @false_node = Node.load_from_graph(graph, instructions.false_node, node_graph)
      @condition_source = instructions.condition_source
    end

    def act
      @next_node = context.values[condition_source] ? @true_node : @false_node
    end

  end
end
