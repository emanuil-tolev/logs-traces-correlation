require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Supermarketwarehouse
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.logger = ActiveSupport::Logger.new(File.join(Rails.root, 'log', "supermarketwarehouse.log"))
    config.logger.datetime_format = "%Y-%m-%d %H:%M:%S"

    class MyAppFormatter < Logger::Formatter
      def call(severity, datetime, progname, msg)
        ElasticAPM.log_ids do |transaction_id, span_id, trace_id|
          {
            timestamp: "#{datetime}\n",
            severity: "#{severity}\n",
            message: "#{msg}",
            :'trace.id' => trace_id,
            :'transaction.id' => transaction_id,
            :'span.id' => span_id
          }.to_json + "\r\n"
        end
      end
    end
    config.logger.formatter = MyAppFormatter.new
  end
end
