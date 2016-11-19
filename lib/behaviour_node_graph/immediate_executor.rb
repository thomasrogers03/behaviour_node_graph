module BehaviourNodeGraph
  class ImmediateExecutor

    def initialize(context)
      @context = context
    end

    def execute(next_nodes)
      execute_internal(next_nodes) if next_nodes
    end

    private

    def execute_internal(next_nodes)
      next_nodes.each do |node|
        node.context = @context
        node.act
      end
    end

  end
end
