message :body => /^\/(space)?dicks$/ do |m|
  matches = /^\/(space)?dicks$/.match(m.body)
  length = rand(3..10)
  prefix = matches[1] ? ' %%>' : ''
  suffix = (rand(0...2) == 1)? ' ~o' : ''
  send_to members.except(m.from), "#{prefix}8#{'=' * length}D#{suffix}"
end
