message :chat_state, :body => nil do |m|
  message = Struct.new(:from, :body, :xhtml_body, :dest).new(m.from, m.body, m.body, members)

  before_filters.each do |f|
    f.call message
  end

  # TODO -- this should fold into the send_to method
  message.dest.except(message.from).keys.each do |d|
    msg = Blather::Stanza::Message.new(d)
    msg.chat_state = m.chat_state
    write_to_stream msg
  end
end
