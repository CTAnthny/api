class CredTransactionSerializer < ActiveModel::Serializer
  attributes :id, :delta, :delta_type, :timestamp, :action

  def delta_type
    object.delta.positive? ? "positive" : "negative"
  end

  def action
    object.event&.credit&.title # screw you, law of demeter... this is ruby.
  end

  def timestamp
    object.created_at
  end
end
