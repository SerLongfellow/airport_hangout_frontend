class Message
  attr_reader :id, :data, :sender_id, :sender_name

  def initialize(id, data, sender_id, sender_name)
    @id = id
    @data = data
    @sender_id = sender_id
    @sender_name = sender_name
  end
end
