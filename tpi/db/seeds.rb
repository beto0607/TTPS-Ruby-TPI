# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

DatabaseCleaner.clean_with(:truncation)


u = User.create(username: 'test', password: Digest::SHA1.hexdigest("test"), screen_name: "test user", email: "test@test.com")
u.save

u_q = User.create(username: 'test_question', password: Digest::SHA1.hexdigest("test_question"), screen_name: "test question user", email: "test@question.com")
u_q.save

u_a = User.create(username: 'test_answer', password: Digest::SHA1.hexdigest("test_answer"), screen_name: "test answer user", email: "test@answer.com")
u_a.save


(u_q.questions.create(title: "Pregunta 1", description: "Descripción de la pregunta 1")).save


(u_q.questions.create(title: "Pregunta 3", description: "Descripción de la pregunta 3")).save


u_a.answers.create(question_id: 1, content: "Respuesta 1").save

(u_q.questions.create(title: "Pregunta 2", description: "Descripción de la pregunta 2", status: true, answer_id: 1)).save