require File.join(File.dirname(__FILE__), %w(room nick))

module Matchat
  module Room
    include Nick

    def initialize_room(members)
      if members.is_a? Array
        @members = Hash[members.map {|x| [x, {}]}]
      else
        @members = members || {}
      end
    end

    def forward_to_room(msg)
      body = "[#{nick_for(msg.from)}] #{msg.body}"
      members_except(msg.from).each do |dest|
        say dest, body
      end
    end

    def send_to_room(msg)
      members.each do |dest|
        say dest, msg
      end
    end

    private

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
