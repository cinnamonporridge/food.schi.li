Rake::Task['db:fixtures:load'].invoke if Rails.env.development?
