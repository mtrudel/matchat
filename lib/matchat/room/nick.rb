before_broadcast_filter do |m|
  m.body = "[#{nick m.from}] #{m.body}"
end

module Matchat
  module Room
    module Nick
      def nick(jid)
        members[jid][:nick] || jid.node
      end

      def set_nick(jid, nick)
        members[jid][:nick] = nick
      end
    end
  end
end
