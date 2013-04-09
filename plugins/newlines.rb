before_broadcast_filter do |m|
  m.xhtml_body.gsub!("\n", '<br/>')
end
