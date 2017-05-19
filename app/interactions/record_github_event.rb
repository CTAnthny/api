class RecordGithubEvent
  include Interactor

  def call
    return unless merged_pull_request?
    return if user && post_event_to_api
    context.fail!(errors: context.errors)
  end

  private

  def merged_pull_request?
    payload.dig("pull_request", "merged").to_s == "true"
  end

  def user
    context.user ||= User.find_by("lower(github_handle) = ?", user_that_opened_pull_request&.downcase)
  end

  def user_that_opened_pull_request
    payload.dig("pull_request", "user", "login")
  end

  def post_event_to_api
    event_params = {
      category: event_category,
      user_id:  user["id"],
      info:     build_event_info
    }

    result = CreateEvent.call(event_params: event_params)

    context.event = result.event
  end

  def event_category
    "#{event_type.singularize}_#{event_action}"
    # => "issue_created", "pull_request_opened", etc.
  end

  def build_event_info
    {
      title:  payload.dig("pull_request", "title"),
      url:    payload.dig("pull_request", "html_url"),
      number: payload.dig("pull_request", "number")
    }
  end

  def request
    context.request
  end

  def event_type
    request.env["HTTP_X_GITHUB_EVENT"]
  end

  def event_action
    payload["action"]
  end

  def payload
    return @payload if @payload

    request.body.rewind
    payload_body = request.body.read
    @payload = JSON.parse(payload_body)
  end
end
