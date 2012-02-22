require 'blather/client'
require 'chronic_duration'

setup ENV['JABBER_JID'], ENV['JABBER_PASSWORD'], ENV['JABBER_HOST']

@members = Hash[ENV['BOOTSTRAP_BUDDIES'].split.map {|x| [x, {}]}]

def send_to(dests, msg)
  dests = [dests] unless dests.respond_to? :each
  dests.each do |dest|
    dest = dest.jid || dest
    next if (Time.now <=> @members[dest.stripped.to_s][:dnduntil]) == -1
    say dest, msg
  end
end

# Auto approve subscription requests from members
subscription :request? do |s|
  puts "Joinging #{s.from}"
  from = s.from.stripped.to_s
  if @members.keys.include? from
    send_to my_roster, "#{from} just joined the room"
    write_to_stream s.approve!
  else
    write_to_stream s.refuse!
  end
end

before :message do |s|
  halt unless my_roster[s.from]
end

message :error? do |s|
  puts "We got an error of #{s}"
  halt
end

message :body => /^\/roster$/ do |m|
  result = my_roster.reduce('') { |str, item| str += "#{item.name} (#{item.jid}) #{item.status} #{item.subscription}\n" }
  send_to m.from, result
  halt
end

message :body => /^\/leave$/ do |m|
  my_roster.delete m.from
  write_to_stream Blather::Stanza::Presence::Subscription.new(m.from, :unsubscribed)
  send_to m.from, "You have left this room. You'll need to re-add this #{jid.stripped} to join again. Bye bye"
  halt
end

message :body => /^\/nick (.+)$/ do |m|
  nick = /^\/nick (.+)$/.match(m.body)[1]
  puts "#{m.from.stripped} changing nickname to #{nick}"
  send_to my_roster, "#{m.from.stripped} changing nickname to #{nick}"
  my_roster[m.from].name = nick
  write_to_stream my_roster[m.from].to_stanza(:set)
  halt
end

message :body => /^\/snooze (.+)$/ do |m|
  duration = ChronicDuration.parse /^\/snooze (.+)$/.match(m.body)[1]
  puts "#{m.from.stripped} sleeping for #{ChronicDuration.output duration}"
  send_to m.from, "Sleeping for #{ChronicDuration.output duration}"
  @members[m.from.stripped.to_s][:dnduntil] = Time.now + duration
  halt
end

# Reflect messages out to everyone except the person who sent them
message :chat?, :body do |m|
  @members[m.from.stripped.to_s][:dnduntil] = nil
  puts "#{m.from.stripped} sending message #{m.body}"
  nick = my_roster[m.from].name || my_roster[m.from].jid.stripped
  send_to my_roster.reject { |i| i.jid.stripped == m.from.stripped }, "[#{nick}] #{m.body}"
  halt
end

when_ready { puts "Connected! Send messages to #{jid.stripped}" }

# Finally, reconnect if we get disconnected
disconnected { client.connect }
