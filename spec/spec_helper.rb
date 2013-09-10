require 'zend'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.default_cassette_options = { decode_compressed_response: true, serialize_with: :json, preserve_exact_body_bytes: true }
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

def stubbed_api
  @stubbed_api ||= ZendeskAPI::Client.new do |config|
    config.url = 'https://z3ntest76.zendesk.com/api/v2'
    config.username = 'jean@mertz.fm'
    config.password = 'password123'
  end
end

def capture_stdout(&block)
  $stdout.unstub(:write)
  original_stdout = $stdout
  $stdout = captured_stdout = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  captured_stdout.string
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before { $stdout.stub(:write) }
  config.after  { $stdout.unstub(:write) }
end
