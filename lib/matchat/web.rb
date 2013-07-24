require 'sinatra/base'

module Matchat
  class Web < Sinatra::Base
    get '/' do
      'Hello, world'
    end
  end
end
