module ApplicationHelper
  
  #Define the full title of the web page, appending an extra part when needed
  def full_title(page_title)
    base_title = "Test Page"
    if(page_title.empty?)
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def startup
    #create_random_users
    #create_microposts
    #create_relationships
  end
  
  def create_random_users
    User.delete_all
    name = "test"
    surname = "test"
    email = "test@test.test"
    password = "testtest"
    admin = User.create!(name: name,
                         surname: surname,
                         email: email,
                         password: password,
                         password_confirmation: password)
    admin.toggle!(:admin)
    
    99.times do |n|
      name = "Name-#{n+1}"
      surname = "Surname-#{n+1}"
      email = "email-#{n+1}@example.org"
      password = "password"
      User.create!(name: name,
                   surname: surname,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
  
  def create_microposts
    users = User.all(limit: 6)
    50.times do |n|
      content = "DAFUQ #{n}"
      users.each { |user| user.microposts.create!(content: content) }
    end
  end
  
  def create_relationships
    users = User.all
    user  = users.first
    followed_users = users[2..50]
    followers      = users[3..40]
    followed_users.each { |followed| user.follow!(followed) }
    followers.each      { |follower| follower.follow!(user) }
  end
end
