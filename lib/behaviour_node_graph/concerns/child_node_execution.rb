module BehaviourNodeGraph
  module ChildNodeExecution

    def act
      executor = ImmediateExecutor.new(context)
      executor.execute(next_nodes)
    end

    private

    def execute_nodes(nodes)
      executor = ImmediateExecutor.new(context)
      executor.execute(nodes)
    end

  end
end
