# Create an admin account
user = User.find_or_initialize_by(email: 'admin@example.com')
user.name = 'administrator'
user.uin = Faker::Number.number(9)
user.email = "admin@example.com"
user.password = 'adminadmin'
user.admin = true
user.semester = 'Fall'
user.year =  2016.to_s #Faker::Number.between(2000 ,2026).to_s
user.course = 'CSCE606'
user.save!

# User.create!(name:  "administrator",
#              email: "admin@example.com",
#              password:              "adminadmin",
#              password_confirmation: "adminadmin",
#              admin: true)

# User.create!(name:  "Jasmeet Singh",
#              email: "jasmeet13n@tamu.edu",
#              password:              "iiit123",
#              password_confirmation: "iiit123",
#              admin: false)

 99.times do |n|
   name  = Faker::Name.name
   uin   = Faker::Number.number(9)
   email = "example-#{n+1}@railstutorial.org"
   password = "password"
   semester = n%3 == 0 ? "Spring" : "Fall"
   year = rand(2000..2026).to_s
   course = 'CSCE606'
   User.create!(name:  name,
                 uin: uin,
                 email: email,
                 semester: semester,
                 year: year,
                 course: course,
                 password:              password,
                 password_confirmation: password)
 end

 30.times do |n|
   title  = Faker::Company.catch_phrase
   organization = Faker::Company.name
   contact = Faker::Name.name + "  " + Faker::PhoneNumber.cell_phone
   description = Faker::Lorem.paragraph
   oncampus = n%3 == 0 ? false : true
   islegacy = n%4 == 0 ? false : true
   approved = false
   semester = 'Fall'
   year =  Faker::Time.between(2.years.ago, Time.now) #Faker::Number.between(2000 ,2026).to_s
   Project.create!(title:  title,
                   organization: organization,
                   contact: contact,
                   description: description,
                   oncampus: oncampus,
                   islegacy: islegacy,
                   approved: approved,
                   semester: semester,
                   year: year)
 end

 25.times do |n|
   title  = Faker::Company.catch_phrase
   organization = Faker::Company.name
   contact = Faker::Name.name + "  " + Faker::PhoneNumber.cell_phone
   description = Faker::Lorem.paragraph
   oncampus = n%3 == 0 ? false : true
   islegacy = n%4 == 0 ? false : true
   approved = true
   semester = 'Fall'
   year =  Faker::Time.between(2.years.ago, Time.now) #2016.to_s #Faker::Number.between(2000 ,2026).to_s
   Project.create!(title:  title,
                  organization: organization,
                   contact: contact,
                                      description: description,
                   oncampus: oncampus,
                   islegacy: islegacy,
                   approved: approved,
                   semester: semester,
                   year: year)
 end

 users = User.all

 20.times do |n|
   name = Faker::Internet.domain_word
   user_id = users[n].id
   code = Faker::Number.number(4)
   t = Team.create!(name: name, user_id: user_id, code: code)
   Relationship.create!(user_id: user_id, team_id: t.id)
 end
'''
 teams=Team.all
 proj=Project.where("approved = ?", false)
 3.times do |n|
   preassign = Preassignment.new do |p|
     p.team_id = teams[n+1].id
     p.project_id = proj[n+1].id
   end
   preassign.save
 end

 preassign = Preassignment.all
 preassign.each do |p|
   preteam = Team.find_by(id: p.team_id)
   teams -= [preteam]
 end
'''
# teams = Team.all
# projects = Project.where("approved = ?", true)
# rnd = Random.new(Time.now.to_i)

# teams.each do |t|
#   projects.each do |proj|
#     v = rnd.rand(-10..10)
#     if v > 9
#       v = 1
#     elsif v < 0
#       v = -1
#     else
#       v = 0
#     end
#     Preference.create!(team_id: t.id,
#                         project_id: proj.id,
#                         value: v)
#   end
# end
