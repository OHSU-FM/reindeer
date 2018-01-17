require 'spec_helper'

RSpec.describe RoomChannel, type: :channel do
  subject(:channel) { described_class.new(connection, {}) }
  let(:current_user) { create :user }
  let(:connection) { TestConnection.new(current_user: current_user) }
  let(:action_cable) { ActionCable.server }
  let(:room) { create :room }
  let(:message) { create :message, room: room, user: current_user }

  let(:data) do
    {
      room_id: room.id,
      message: message
    }
  end
end
