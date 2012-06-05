module Matchat
  module Room
    module Nick
      def nick_for(jid)
        members[jid][:nick] || jid.node
      end

      def set_nick_for(jid, nick)
        old_nick = nick_for jid
        members[jid][:nick] = nick
        send_to_room "#{old_nick} changed their nickname to #{nick}"
      end
    end
  end
end
