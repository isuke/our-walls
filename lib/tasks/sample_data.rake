namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    users = Array.new
    walls = Array.new
    make_users(60, 3) do |user|
      users << user
    end
    make_walls(3) do |wall|
      walls << wall
    end

    make_friends(users)
    make_participants(walls, users)
  end
end

def make_users(num, limit=num)
  puts "make users"
  num.times do |n|
    u =  make_user(n)
    yield u if n < limit
  end
end

def make_walls(num, limit=num)
  puts "make walls"
  num.times do |n|
    w = make_wall(n)
    yield w if n < limit
  end
end

def make_friends(users)
  puts "make friends"
  users.each_with_index do |user, i|
    dup_users = users.dup
    main_user = dup_users.delete_at(i)
    dup_users.each do |user|
      make_friend(main_user, user)
    end
  end
end

def make_participants(walls, users)
  puts "make participants"
  walls.each_with_index do |wall, i|
    dup_users = users.dup
    owner_user = dup_users.delete_at(i)
    make_participant_and_posts(10, wall, owner_user, true)
    dup_users.each do |user|
      make_participant_and_posts(10, wall, user)
    end
  end
end

private

  def make_participant_and_posts(num, wall, user, owner=false, limit=num)
    participant = make_participant(wall, user, owner)
    num.times do |n|
      post = make_post(participant)
      # yield post if n < limit
    end
  end

  def make_user(n)
    name  = Faker::Name.name
    email = "example-#{n}@example.com"
    password  = "foobar"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end

  def make_friend(user, target_user)
    user.friends.create!(target_user_id: target_user.id)
  end

  def make_wall(n)
    name = "Wall-#{n}"
    wall = Wall.create!(name: name)
  end

  def make_participant(wall, user, owner=false)
    wall.participants.create!(user_id: user.id, owner: owner)
  end

  def make_post(participant)
    content = Faker::Lorem.paragraph
    participant.posts.create!(content: content)
  end
