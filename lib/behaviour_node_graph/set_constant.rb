module BehaviourNodeGraph
  SetConstant = define_simple_node(:target, :value) do
    context.values[target] = value
  end
  SetConstant.outputs = [:target]
  SetConstant.properties = {value: :any}
end
