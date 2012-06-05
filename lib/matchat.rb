require 'rubygems'
require 'blather/client'

require File.join(File.dirname(__FILE__), *%w[matchat room])

include Matchat::Room

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
  set_nick_for m.from, /^\/(nick|alias) (.+)$/.match(m.body)[2]
end

message :chat?, :body do |m|
  forward_to_room m
end
