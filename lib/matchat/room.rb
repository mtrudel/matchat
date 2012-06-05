require File.join(File.dirname(__FILE__), %w(room core))
require File.join(File.dirname(__FILE__), %w(room membership))
require File.join(File.dirname(__FILE__), %w(room nick))

module Matchat
  module Room
    include Core
    include Membership
    include Nick
  end
end
