before_broadcast_filter do |m|
  snooze m.from, false

  # Filter anyone out who's currently snoozing
  m.dest = m.dest.reject { |x| snoozing? x }
end

module Matchat
  module Room
    module Snooze
      def snoozing?(jid)
        members[jid][:dnduntil] && members[jid][:dnduntil] > Time.now
      end

      def snooze(jid, snooze)
        members[jid][:dnduntil] = snooze && Time.now + snooze
      end
    end
  end
end
