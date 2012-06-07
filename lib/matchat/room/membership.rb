require File.join(File.dirname(__FILE__), %w(.. membership_list))

module Matchat
  module Room
    module Membership
      def initialize_room(members)
        @members = MembershipList.new members
      end

      def members
        @members
      end
    end
  end
end
