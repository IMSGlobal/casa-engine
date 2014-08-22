require 'sinatra/base'
require 'sinatra/namespace'

module CASA
  module Engine
    class App < Sinatra::Base

      register Sinatra::Namespace
      set :protection, :except => :frame_options

    end
  end
end
