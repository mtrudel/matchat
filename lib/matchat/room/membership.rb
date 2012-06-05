module Matchat
  module Room
    module Membership
      def initialize_room(members)
        if members.is_a? Array
          @members = Hash[members.map {|x| [x, {}]}]
        else
          @members = members || {}
        end
      end

      def members
        @members.keys || []
      end

      def members_except(jid)
        members.reject { |x| x == key(jid) }
      end

      def key(jid)
        Blather::JID.new(jid).stripped.to_s
      end
    end
  end
end
