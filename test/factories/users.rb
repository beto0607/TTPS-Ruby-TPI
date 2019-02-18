FactoryGirl.define do
    factory :user do
        username "pepe01"
        password "pepePassword"
        password_confirmation "pepePassword"
        screen_name "Jose Primero"
        email "pepe01@gmail.com"
    end

    factory :pep02, parent: :user do
        username: "pepe02"
        email: "pepe02@gmail.com"
    end
end