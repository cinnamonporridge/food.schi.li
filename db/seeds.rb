Rake::Task["db:fixtures:load"].invoke if Rails.env.development?

User.find_or_create_by!(email: "global@global.localhost") do |user|
  user.password = SecureRandom.alphanumeric(72)
end
