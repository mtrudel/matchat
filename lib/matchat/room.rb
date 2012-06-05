module Matchat
  module Room
    def initialize_room(members)
      if members.is_a? Array
        @members = Hash[members.map {|x| [x, {}]}]
      else
        @members = members || {}
      end
    end

    def forward_to_room(msg)
      body = "[#{msg.from.stripped.to_s}] #{msg.body}"
      members_except(msg.from).each do |dest|
        say dest, body
      end
    end

    private

    def members
      @members || {}
    end

    def members_except(jid)
      members.keys.reject { |x| x == jid.stripped.to_s }
    end
  end
end
