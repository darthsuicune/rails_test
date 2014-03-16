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
end
