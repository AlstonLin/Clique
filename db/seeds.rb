# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
DEFAULT_ADMIN_EMAIL = "team@everestmg.com"
DEFAULT_ADMIN_PASSWORD = "AdminPassword"
User.new(
  :first_name => "Everest",
  :last_name => "Media Group",
  :email => DEFAULT_ADMIN_EMAIL,
  :can_generate_access_codes => true,
  :password => DEFAULT_ADMIN_PASSWORD,
  :password_confirmation => DEFAULT_ADMIN_PASSWORD
).save(:validate=> false)
