module BehaviourNodeGraph
  class SetConstant < Struct.new(:target, :value)
    include Node

    def act
      context.values[target] = value
    end
  end
end
