require 'rufus-scheduler'
require 'casa/relay/strategy/load_from_adj_in'

module CASA
  module Engine
    module Job
      class Relay

        attr_reader :interval
        attr_reader :adj_out_payloads_handler
        attr_reader :adj_in_payloads_handler
        attr_reader :logger

        def initialize options

          @interval = options['interval']
          @adj_out_payloads_handler = options['adj_out_payloads_handler']
          @adj_in_payloads_handler = options['adj_in_payloads_handler']
          @logger = options['logger']
          @scheduler = nil

        end

        def relay_options

          @relay_options ||= {
            'persistence' => {
              'adj_out_payloads' => {
                'handler' => adj_out_payloads_handler
              },
              'adj_in_payloads' => {
                'handler' => adj_in_payloads_handler
              }
            },
            'logger' => logger
          }

        end

        def started?

          !@scheduler.nil?

        end

        def start!

          return if started?

          create_scheduler.every interval, :overlap => false, :tag => 'relay-load_from_adj_in' do
            CASA::Relay::Strategy::LoadFromAdjIn.new(relay_options).execute!
          end

        end

        def create_scheduler

          @scheduler ||= Rufus::Scheduler.new

        end

      end
    end
  end
end