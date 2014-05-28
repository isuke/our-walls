namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_friends
  end
end

def make_users
  10.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@example.com"
    password  = "foobar"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_friends
  users = User.all
  users[0..4].each do |u1|
    users[5..9].each do |u2|
      u1.friends.build(target_user_id: u2.id).save
    end
  end
end
