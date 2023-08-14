# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

password = SecureRandom.urlsafe_base64(10)
user = User.create!(name:                  'ゲストユーザー',
                    age:                    20,
                    gender:                '男性',
                    email:                 'guest@example.com',
                    password:              password,
                    password_confirmation: password,
                    admin:                  true,
                    confirmed_at:           Time.zone.today,
                    activated:              true,
                    introduce:              '初めまして!
                                             よろしくお願いします！'
                    )
20.times do |n|
  name = Faker::Name.name
  email = "test#{n}@example.com"
  User.create!(name:                 name,
              age:                    20,
              gender:                '男性',
              email:                 email,
              password:              '111111',
              password_confirmation: '111111',
              admin:                  true,
              confirmed_at:           Time.zone.today,
              activated:              true,
              introduce:              "初めまして!\nよろしくお願いします!"
              )
end

image_files = [
  { file: 'カフェ内観.webp', name: 'カフェ内観.webp' },
  { file: '内観2.webp', name: '内観2.webp' },
  { file: 'コーヒー.webp', name: 'コーヒー.webp' },
  { file: 'ケーキ.webp', name: 'ケーキ.webp' }
]
15.times do |i|
  if i == 14
    target = user
  else
    target = User.find(i + 2)
  end
  image_attachments = image_files.map do |image_file|
    {
      io: File.open(Rails.root.join("app/assets/images/#{image_file[:file]}")),
      filename: image_file[:name]
    }
  end
  recruit = Recruit.new(user:            target,
                        title:          'カフェでゆっくりお話したい',
                        explain:        '今悩みがあります。それをただ聞いて欲しいです。
                                         食事代は私が出させていただきます。
                                         誰かに話すことで、状況の整理や頭の中で考えていることを言語化したいです。
                                         よろしくお願いします。',
                        date:            Date.current,
                        meeting_time:    1.minute.from_now,
                        required_time:   30,
                        address:        '東京都台東区秋葉原',
                        latitude:        35.702259,
                        longitude:       139.774475)

  tags = ["悩み相談", "飲食", "カフェ"]

  tags.each do |tag_name|
    tag = Tag.find_or_create_by(name: tag_name)
    recruit.tags << tag
  end

  recruit.images = image_attachments
  recruit.save!
end

users = User.all
applicant_users = users[1..5]
applicant_users.each_with_index do |user, i|
  Applicant.create(user_id: user.id, recruit_id: (i + 1))
  Relation.create(follower_id: user.id, followed_id: 1, recruit_id: i + 6)
  room = ChatRoom.create
  Member.create(user_id: 1, chat_room_id: room.id)
  Member.create(user_id: i + 2, chat_room_id: room.id)
  ChatMessage.create(chat_room_id: room.id, user_id: 1, content: "初めまして！よろしくお願いします！")
  ChatMessage.create(chat_room_id: room.id, user_id: i + 2, content: "初めまして！よろしくお願いします！")
end

5.times do |i|
  Applicant.create(user_id: (i + 7), recruit_id: user.recruits.first.id)
end

category = %w[relation comment applicant chat_message favorite]
2.times do
  category.each do |c|
    id = (c == 'comment' || c == 'applicant' || c == 'favorite') ? 1 : nil
    Notification.create(sender_id: users[0].id, receiver_id: users[2].id, category: c, read: false, recruit_id: id )
    Notification.create(sender_id: users[2].id, receiver_id: users[0].id, category: c, read: false, recruit_id: id )
  end
end


users.each_with_index do |user, i|
  content = Faker::Lorem.sentence(word_count: 10)
  if i != 2
    Evaluation.create(evaluator_id: user.id, evaluatee_id: users[2].id, score: rand(1..5), feedback: content, recruit_id: 1)
  end

  if i != 0
    Evaluation.create(evaluator_id: user.id, evaluatee_id: 1, score: rand(1..5), feedback: content, recruit_id: 1)
  end
end
