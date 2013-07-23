require 'blather/client/dsl'
require_relative 'room'
require_relative 'blather_delivery'

module Matchat
  class Bot
    include Blather::DSL

    def run
      room.extend(BlatherDelivery)
      room.client = client

      setup username, password, host

      when_ready { puts "Connected! Send messages to #{jid.stripped}" }

      message :chat?, :body do |message|
        room.handle_message message
      end

      EM.run { client.run }
    end

    def username
      ENV['ROOM_JID']
    end

    def password
      ENV['ROOM_PASSWORD']
    end

    def host
      ENV['ROOM_HOST']
    end

    def room
      @room ||= Room.new
    end
  end
end
