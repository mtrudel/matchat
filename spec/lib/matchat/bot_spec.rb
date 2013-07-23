require 'spec_helper'

require 'matchat/bot'

describe Matchat::Bot do
  before :each do
    ENV['ROOM_JID'] = 'foo@bar.com'
    ENV['ROOM_PASSWORD'] = 'sekrit'
    ENV['ROOM_HOST'] = 'example.com'
    
    subject.stub :setup
    subject.stub :when_ready
    subject.stub :message
    EM.stub :run
    @room = double 'room'
    @room.stub :handle_message
    Matchat::Room.stub(:new) { @room }
  end

  describe 'Setting up the bot' do
    it 'should properly set up the credentials' do
      subject.should_receive(:setup).with('foo@bar.com', 'sekrit', 'example.com')
      subject.run
    end

    it 'should call handle_message on its room' do
      subject.should_receive(:setup).with('foo@bar.com', 'sekrit', 'example.com')
      subject.run
    end

    it 'should defer to the room to handle messages' do
      @room.should_receive(:handle_message).with('message')
      subject.should_receive(:message).with(:chat?, :body)
      subject.stub(:message) { |&arg| arg.call 'message' }
      subject.run
    end

    it 'should extend the with the correct delivery methods' do
      subject.run
      @room.kind_of?(Matchat::BlatherDelivery).should == true
    end

    it 'should setup the room delivery client' do
      client = double 'client'
      subject.stub(:client) { client }
      @room.should_receive(:client=).with(client)
      subject.run
    end
  end

  describe 'attribute readers' do
    it 'should return the correct username' do
      subject.username.should == 'foo@bar.com'
    end

    it 'should return the correct password' do
      subject.password.should == 'sekrit'
    end

    it 'should return the correct host' do
      subject.host.should == 'example.com'
    end

    it 'should return the correct room' do
      Matchat::Room.should_receive(:new).once
      subject.room.should == @room
      subject.room.should == @room
    end
  end
end
