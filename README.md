## TTPS - Ruby - 2018 - TPI ##

### Description ###

Solution implemented for [this assignment](https://github.com/TTPS-ruby/practicas-ruby-ttps/blob/master/evaluaciones/2018/tpi/enunciado.md).


### How to use ###

* Run `bundle install`
* Run `rails db:seed`
* Run `bundle exec rails s`


### Endpoints ###

#### Users ####
* POST -> /users -> params: username, password, email, screen_name
* POST -> /sessions -> params: username, password

#### Questions ####
* GET -> /questions -> params: sort(optional)(needing_help|pending_first|latest), offset(for pagination)
* GET -> /questions/:id -> params: id
* POST -> /questions -> params: title, description. Token in header
* PUT -> /questions/:id -> params: id, title(optional), description(optional). Token in header
* DELETE -> /questions/:id -> params: id. Token in header
* PUT -> /questions/:id/resolve -> params: id, answer_id. Token in header

#### Answers ####
* GET -> /questions/:question_id/answers -> params: question_id
* POST -> /questions/:question_id/answers -> params: question_id, content. Token in header
* DELETE -> /questions/:question_id/answers/:id -> params: question_id, id. Token in header.


### Tests ###

### Owner ###
* Albanesi, Roberto. 09761/0

### Dependencies ###pa
* Ruby 2.5
* Rails 5.2
* Database_cleanner
