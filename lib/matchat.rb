
# Load up the blather DSL
require 'blather/client'

# Introduce our Room DSL
require File.join(File.dirname(__FILE__), *%w[matchat room broadcast])
include Matchat::Room::Broadcast

require File.join(File.dirname(__FILE__), %w(matchat room membership))
include Matchat::Room::Membership

require File.join(File.dirname(__FILE__), %w(matchat room nick))
include Matchat::Room::Nick

setup ENV['JABBER_JID'], ENV['JABBER_PASSWORD'], ENV['JABBER_HOST']

when_ready { puts "Connected ! send messages to #{jid.stripped}." }

initialize_room ENV['MEMBERS'].split

subscription :request? do |s|
  write_to_stream s.approve!
end

message :error? do |s|
  puts "We got an error of #{s}"
  halt
end

message :body => /^\/(nick|alias) (.+)$/ do |m|
  nick = /^\/(nick|alias) (.+)$/.match(m.body)[2]
  old_nick = nick m.from
  set_nick m.from, nick
  send_to members, "#{old_nick} changed their nick to #{nick}"
  halt
end

message :chat?, :body do |m|
  Message ||= Struct.new(:from, :body, :dest)
  message = Message.new(m.from, m.body, members)

  before_broadcast_filters.each do |f|
    f.call message
  end

  send_to message.dest.except(message.from), message.body
end
