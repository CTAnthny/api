require 'open-uri'

desc "Records credit for meetup attendance"
task :meetup_attendance, [:uri] => :environment do |t, args|
  keys = %w(timestamp github_handle)
  io   = open(args.uri)
  csv = CSV.parse(io).map do |a|
    Hash[keys.zip(a)]
  end

  csv.each do |hsh|
    user = User.find_by(github_handle: hsh['github_handle'])
    next unless user
    puts "Found user via github_handle: #{hsh['github_handle']}"

    event_params = {
      category: "attended_meetup",
      user_id: user.id
      # Add info: { title, url } by looking up meetup API?
    }

    puts "Creating event:"
    puts event_params
    r = CreateEvent.call(event_params: event_params)
    if r.success?
      transaction = r.transaction
      time  = DateTime.strptime(hsh["timestamp"],"%m/%d/%Y %H:%M:%S")
      transaction.update(created_at: time)
      puts "Setting transaction created_at: #{time}"
      puts "SUCCESS"
    else
      puts "ERROR!!!!"
      puts r.errors
    end
    puts "=" * 75
  end
end
