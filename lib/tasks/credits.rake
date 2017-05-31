desc "Creates/Updates all credits that are in credits.yml"
task credits: :environment do
  credits = YAML.load_file "config/credits.yml"

  credits.each do |attrs|
    name = attrs["name"]
    credit = Credit.find_or_initialize_by(name: name)
    action = credit.new_record? ? "creating" : "updating"
    puts "#{action} Credit(name: #{name})"
    credit.update_attributes(attrs)
  end
end
