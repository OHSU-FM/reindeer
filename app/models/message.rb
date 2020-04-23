class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates_presence_of :room

  after_create_commit { MessageBroadcastJob.perform_later self, user }
  after_commit :do_retract_job, on: [:destroy] # TODO add check for archive on update

  private

  def do_retract_job
    MessageRetractJob.perform_now self
  end
end
