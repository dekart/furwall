require "factory_girl"

Factory.define :permission do |p|
  p.action  "test"
  p.rule    "test_rule"
end