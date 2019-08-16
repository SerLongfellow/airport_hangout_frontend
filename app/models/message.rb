class Message
  attr_reader :id, :conversation_id, :data, :sender_id, :sender_name

  def initialize(id, conversation_id, data, sender_id, sender_name)
    @id = id
    @conversation_id = conversation_id
    @data = data
    @sender_id = sender_id
    @sender_name = sender_name
  end
end
