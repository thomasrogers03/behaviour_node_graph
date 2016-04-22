module BehaviourNodeGraph
  class Instructions < OpenStruct

    def method_missing(method, *args, &block)
      if method !~ /=$/
        super(method, *args, &block) || public_send(:"#{method}=", Instructions.new)
      else
        super(method, *args, &block)
      end
    end

  end
end
