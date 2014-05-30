namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_friends
    make_walls
    make_participants
  end
end

def make_users
  puts "make users"
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
  puts "make friends"
  users = User.all
  users[0..4].each do |u1|
    users[5..9].each do |u2|
      u1.friends.build(target_user_id: u2.id).save
    end
  end
end

def make_walls
  puts "make walls"
  5.times do |n|
    name = "Wall-#{n+1}"
    Wall.create!(name: name)
  end
end

def make_participants
  puts "make paticipants"
  User.limit(2).each do |user|
    Wall.limit(2).each do |wall|
      user.participants.build(wall_id: wall.id).save
    end
  end
end
