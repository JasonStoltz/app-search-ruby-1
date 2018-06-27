require 'bundler/setup'
require 'rspec'
require 'webmock'
require 'awesome_print'
require 'swiftype-app-search'

RSpec.shared_context "App Search Credentials" do
  let(:as_api_key) { ENV.fetch('AS_API_KEY' || 'AS_PRIVATE_KEY', 'API_KEY' || 'PRIVATE_KEY') }
  let(:as_account_host_key) { ENV.fetch('AS_ACCOUNT_HOST_KEY' || 'AS_HOST_IDENTIFIER', 'ACCOUNT_HOST_KEY' || 'HOST_IDENTIFIER') }
  let(:as_api_endpoint) { ENV.fetch('AS_API_ENDPOINT', nil) }
  let(:client_options) do
    {
      :api_key => as_api_key,
      :account_host_key => as_account_host_key
    }.tap do |opts|
      opts[:api_endpoint] = as_api_endpoint unless as_api_endpoint.nil?
    end
  end
end

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
