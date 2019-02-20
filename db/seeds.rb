# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

testUser = User.new
testUser.username = "UserTest"
testUser.email = Faker::Internet.email
testUser.screen_name = Faker::Artist.name
testUser.password = testUser.password_confirmation = "Test1"
testUser.save

user1 = User.new
user1.username = Faker::Internet.username
user1.email = Faker::Internet.email
user1.screen_name = Faker::Artist.name
user1.password = user1.password_confirmation = "Test1"
user1.save

user2 = User.new
user2.username = Faker::Internet.username
user2.email = Faker::Internet.email
user2.screen_name = Faker::Artist.name
user2.password = user2.password_confirmation = "Test2"
user2.save



q1 = Question.new
q1.title = Faker::Book.title
q1.description = Faker::Lorem.paragraph(2)
q1.status = false
q1.user_id = user1.id
q1.save

a1 = Answer.new
a1.content = Faker::Lorem.paragraph(1)
a1.user_id = user2.id
a1.question_id = q1.id
a1.save


q2 = Question.new
q2.title = Faker::Book.title
q2.description = Faker::Lorem.paragraph(2)
q2.status = false
q2.user_id = user2.id
q2.save

a2 = Answer.new
a2.content = Faker::Lorem.paragraph(1)
a2.user_id = user1.id
a2.question_id = q2.id
a2.save

q2.answer_id = a2.id
q2.status = true
q2.save
