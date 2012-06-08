module Matchat
  module DSL
    def augment_dsl(method = nil, &block)
      if method.nil?
        self.instance_eval &block
      else
        self.define_singleton_method method, &block
      end
    end

    def send_to(dest, msg)
      case dest
      when Hash
        dest = dest.keys
      when Array
        dest = dest
      else
        dest = [dest]
      end

      dest.each do |d|
        say d, msg
      end
    end

    def before_broadcast_filter(&block)
      @filters ||= []
      @filters << block
    end

    def before_filters
      @filters || []
    end
  end
end
