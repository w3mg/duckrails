FactoryGirl.define do
  factory :mock, class: Duckrails::Mock do
    status '200'
    request_method  'get'
    content_type 'application/json'
    route_path '/mocks/:id'
    name 'Default mock'
    active true
  end
end
