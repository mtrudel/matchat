require 'rubygems'
require 'blather/jid'

module Matchat
  class MembershipList
    include Enumerable

    def initialize(members)
      if members.is_a? Array
        @members = Hash[members.map {|x| [key(x), {}]}]
      end
    end

    def [](member)
      @members[key(member)]
    end

    def []=(key,val)
      @members[key(key)] = val
    end

    def each
      @members.keys.each do |jid|
        yield jid
      end
    end

    def except(jid)
      @members.keys.reject { |x| x == key(jid) }
    end

    def key(jid)
      Blather::JID.new(jid).stripped.to_s
    end
  end
end
