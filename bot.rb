require 'blather/client'
require 'chronic_duration'

setup ENV['JABBER_JID'], ENV['JABBER_PASSWORD'], ENV['JABBER_HOST']

@members = Hash[ENV['BOOTSTRAP_BUDDIES'].split.map {|x| [x, {}]}]

def send_to(dests, msg)
  dests = [dests] unless dests.is_a? Array
  dests.each do |dest|
    next if (Time.now <=> @members[dest][:dnduntil]) == -1
    say dest, msg
  end
end

# Auto approve subscription requests from members
subscription :request? do |s|
  from = s.from.stripped.to_s
  if @members.keys.include? from
    send_to @members.keys, "#{from} just joined the room", :type => :headline
    write_to_stream s.approve!
  else
    write_to_stream s.refuse!
  end
end

before :message do |s|
  halt unless @members.keys.include? s.from.stripped.to_s
end

message :body => /^\/eval (.+)$/ do |m|
  from = m.from.stripped.to_s
  code = /^\/eval (.+)$/.match(m.body)[1]
  send_to from, eval(code)
  halt
end

message :body => /^\/nick (\w+)$/ do |m|
  from = m.from.stripped.to_s
  nick = /^\/nick (\w+)$/.match(m.body)[1]
  puts "#{from} changing nickname to #{nick}"
  send_to @members.keys, "#{from} changing nickname to #{nick}"
  @members[from][:nickname] = nick
  halt
end

message :body => /^\/snooze (\d+[hmd])$/ do |m|
  from = m.from.stripped.to_s
  duration = ChronicDuration.parse /^\/snooze (\d+[hmd])$/.match(m.body)[1]
  puts "#{from} sleeping for #{ChronicDuration.output duration}"
  send_to from, "Sleeping for #{ChronicDuration.output duration}"
  @members[from][:dnduntil] = Time.now + duration
  halt
end

# Reflect messages out to everyone except the person who sent them
message :chat?, :body do |m|
  from = m.from.stripped.to_s
  @members[from][:dnduntil] = nil
  puts "#{from} sending message #{m.body}"
  nick = @members[from][:nickname] || from
  send_to @members.keys.reject { |k,v| k == from }, "[#{nick}] #{m.body}"
end

when_ready { puts "Connected! Send messages to #{jid.stripped}" }

# Finally, reconnect if we get disconnected
disconnected { client.connect }
