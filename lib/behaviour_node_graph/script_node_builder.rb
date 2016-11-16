module BehaviourNodeGraph
  module ScriptNodeBuilder
    @builders = {}
    class << self
      attr_reader :builders

      def extended(base)
        base.node_cache = LruRedux::TTL::ThreadSafeCache.new(100, 5 * 60)
      end
    end

    attr_accessor :node_cache

    def register(language)
      ScriptNodeBuilder.builders[language] = self
    end

    def fetch(code)
      node_cache[script_sha(code)] ||= build(code)
    end

    private

    def script_sha(code)
      Digest::SHA1.base64digest(code)
    end
  end
end
