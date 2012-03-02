Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :work do |work|
  work.date "03/03/2012"
  work.time "08:00"
  work.duration 20
  work.description "path to work"
  work.association :user
end