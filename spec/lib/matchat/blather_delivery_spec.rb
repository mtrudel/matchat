require 'spec_helper'

require 'matchat/blather_delivery'

describe Matchat::BlatherDelivery do
  it 'should have attr accessors for client' do
    subject.should.respond_to? :client
    subject.should.respond_to? :client=
  end
end
