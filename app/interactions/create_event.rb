class CreateEvent
  include Interactor

  def call
    return if valid_event? && create_event && create_cred_transaction
    context.fail!(errors: context.errors)
  end

  private

  def valid_event?
    return true unless validator

    result = validator.call(context.to_h)
    result.success?.tap do |success|
      context.errors = result.errors unless success
    end
  end

  def validator
    "Validate#{event.category}".safe_constantize
  end

  def event
    context.event ||= Event.new(context.event_params)
  end

  def create_event
    context.errors = event.errors&.messages unless event.valid?
    event.save
  end

  def transaction
    context.transaction ||= CredTransaction.new(
      user_id:    event.user_id,
      event_id:   event.id,
      delta:      delta
    )
  end

  def create_cred_transaction
    context.errors = transaction.errors&.messages unless transaction.valid?
    transaction.save
  end

  def delta
    context.delta ||= event.quantity * event.credit.points_per_unit
  rescue NoMethodError
    context.fail!(errors: { credit: ["'#{event.category}' does not exist in db"] })
  end
end
