class Message < ApplicationRecord
  belongs_to :messagable, polymorphic: true
  belongs_to :user
  validates_presence_of :body, :user

  after_create_commit {MessageBroadcastJob.perform_later self}
  after_create_commit :send_channel_notification

  private

    def send_channel_notification
      if self.messagable.class == Channel
        ActionCable.server.broadcast("groups_channel", {
          channel: Channel.find(self.messagable_id).id
        })
      end
    end

end
