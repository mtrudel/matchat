message :body => /^\/dicks$/ do |m|
  length = rand(3..10)
  send_to members.except(m.from), "8#{'=' * length}D"
end
