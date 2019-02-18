FactoryGirl.define do
#---------------USERS------------------
    factory :user do
        sequence(:username) {|n| "pepe#{n}"}
        password "pepePassword"
        password_confirmation "pepePassword"
        screen_name "Jose Primero"
        email {"#{username}@gmail.com"}
    
        factory :pepe02 do
            username "pepe02"
            email "pepe02@gmail.com"
        end
    end

#-------------QUESTIONS----------------
    factory :question do
        title "aTitle"
        description "aDescription"
        user
    end
#--------------ANSWERS-----------------
    factory :answer do
        content "aContent"
        pepe02
    end
end