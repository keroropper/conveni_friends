# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!(name:                  'ryoya',
                    age:                    20,
                    gender:                '男性',
                    email:                 'test1@example.com',
                    password:              '111111',
                    password_confirmation: '111111',
                    admin:                  true,
                    confirmed_at:           Time.zone.today,
                    activated:              true
                    )

20.times do 
  recruit = Recruit.new(user:            user,
                        title:          'title',
                        explain:        'explain',
                        date:            Time.zone.tomorrow,
                        meeting_time:   '0:00',
                        required_time:   30,
                        address:        '東京都台東区秋葉原',
                        latitude:        35.702259,
                        longitude:       139.774475)

  tags = ["tag1", "tag2", "tag3"]
  tags.each do |tag_name|
    tag = Tag.find_or_create_by(name: tag_name)
    recruit.tags << tag
  end
  
  recruit.images.attach(io: File.open(Rails.root.join('app/assets/images/kitten.jpg')), filename: 'kitten.jpg')
  recruit.images.attach(io: File.open(Rails.root.join('app/assets/images/frog.png')), filename: 'frog.png')
  recruit.images.attach(io: File.open(Rails.root.join('app/assets/images/メギド72_01.jpg')), filename: 'メギド72_01.jpg')
  recruit.images.attach(io: File.open(Rails.root.join('app/assets/images/縦長.jpeg')), filename: '縦長.jpeg')
  recruit.save!
end