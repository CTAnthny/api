namespace :codewars do
  desc "Iterate over every user in DB and update codewars honor via API"
  task update_honor: :environment do
    User.all.each do |user|
      UpdateUserCodewarsHonor.call(user: user)
    end
  end
end
