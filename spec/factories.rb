Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :work do |work|
  work.from "2012-03-03 12:00:00"
  work.to "2012-03-03 12:10:00"
  work.duration 10
  work.description "path to work"
  work.association :user
end