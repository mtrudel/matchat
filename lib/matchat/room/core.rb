module Matchat
  module Room
    module Core
      def forward_to_room(msg)
        body = "[#{nick_for(msg.from)}] #{msg.body}"
        members.except(msg.from).each do |dest|
          say dest, body
        end
      end

      def send_to_room(msg)
        members.each do |dest|
          say dest, msg
        end
      end
    end
  end
end
