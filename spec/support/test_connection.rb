# https://medium.com/@tomekw/unit-testing-actioncable-channels-with-rspec-ca67ca6834af
# This is the minimal ActionCable connection stub to make the Actioncable tests pass
class TestConnection
  attr_reader :identifiers, :logger

  def initialize(identifiers_hash = {})
    @identifiers = identifiers_hash.keys
    @logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(StringIO.new))

    # This is an equivalent of providing `identified_by :identifier_key` in ActionCable::Connection::Base subclass
    identifiers_hash.each do |identifier, value|
      define_singleton_method(identifier) do
        value
      end
    end
  end
end
