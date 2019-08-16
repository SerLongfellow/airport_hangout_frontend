class Conversation
  attr_reader :id, :sender_id, :recipient_id, :messages
  attr_writer :id

  def initialize(sender_id, recipient_id, messages=[])
    @sender_id = sender_id
    @recipient_id = recipient_id
    @messages = messages

    @id = -1
  end
end
