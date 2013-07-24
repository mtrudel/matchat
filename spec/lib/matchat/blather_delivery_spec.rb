require 'spec_helper'

require 'matchat/blather_delivery'

describe Matchat::BlatherDelivery do
  it 'should have attr accessors for client' do
    subject.should.respond_to? :client
    subject.should.respond_to? :client=
  end

  it 'should provide a mechanism to send out to everyone in the room' do
    pending 'on membership'
  end

  it 'should provide a mechanism to send out to everyone in the room except the sender' do
    pending 'on membership'
  end

  it 'should provide a mechanism to reply to sender' do
    pending 'on membership'
  end
end
