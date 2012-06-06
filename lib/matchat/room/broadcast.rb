module Matchat
  module Room
    module Broadcast
      def send_to(dest, msg)
        dest.each do |d|
          say d, msg
        end
      end

      def before_broadcast_filter(&block)
        @filters ||= []
        @filters << block
      end

      def before_broadcast_filters
        @filters || []
      end
    end
  end
end
