# Name
# Profile Pic
# Social media links/ Twitter, LinkedIn, GitHub, Blog(RSS)
# Quote
# About/ Bio, Education, Work
# Coder Cred / Treehouse, Codeschool, Coderwal .reject(Github)
# => Avi is using student_links = doc.search("div.home-blog a")
# => doc.search("a[href*=/students]")
        # This searches all links with students 
            # =>  e.g. linkedin = doc.search("div.page-title a[href*=linkedin]")
                    # searches all links w. Linkedin
        # We can also go to the specific class and then find its parent element
            # twitter = doc.search("i.icon-twitter").first.parent() .children or .parent  return 


require 'nokogiri'
require 'sqlite3'
require 'open-uri'

database = 'flatiron.db'


index_page = Nokogiri::HTML(open("http://students.flatironschool.com/")) 
index_student_name = index_page.css("div.big-comment h3 a")[8].attr("href")
index_student_url = "http://students.flatironschool.com/#{index_student_name}"
# puts index_student_url

# students_html_array = [index_student_url] # This is the hash that will hold our new html links

# # ==============================
# # Create a loop that scrapes the index page 

# # Keep track of all the student links that we've scraped
# # Return every student link into the student_html_array

index_page = Nokogiri::HTML(open("http://students.flatironschool.com/"))
index_student_name = index_page.css("div.big-comment h3 a").attr("href")

index_scrapes_array = []
index_student_url.each do |loop|
    index_scrapes_array << index_student_url.loop.attr("href").downcase
end

  # # create an array of relative URLs for each student
  # students_html_array = []
  # students.each do |student|
  #   students_html_array << student.attr("href").downcase
  # end
 
  puts "\nThe index_scrapes_array looks like this:\n #{index_scrapes_array.inspect}"
  
# # ==============================

begin
  db = SQLite3::Database.new database
  db.execute("DROP TABLE IF EXISTS Students")
  #db = SQLite3::Database.open database
  
# rescue SQLite3::Exception => e 
#   puts "Exception occurred"
#   puts e
# ensure
#   db.close if db
end 

index_scrapes_array.each do |student_html|
# index_scrapes_array.each do |student_html|

    index_page = Nokogiri::HTML(open(student_html))

    # To grab student name
    student_name_finder = "h4.ib_main_header"
    student_name = index_page.css("#{student_name_finder}").first.content 
    puts student_name

    # To grab student Twitter link
    student_twitter_finder = "div.social-icons a"
    student_twitter = index_page.css("#{student_twitter_finder}")[0].attr('href')
    puts student_twitter

    # To grab student LinkedIn link
    student_linkedin_finder = "div.social-icons a"
    student_linkedin = index_page.css("#{student_linkedin_finder}")[1].attr('href')
    puts student_linkedin

    # To grab student quote text
    student_quote_finder = "li#text-7 h3"
    student_quote = index_page.css("#{student_quote_finder}").first.content
    puts student_quote

# binding.pry is a gem puts you here in the terminal at line 63 totlaly in scope
# binding.pry


# section section-testimonials-curriculum quote-div

  # Deletes old database, creates new database
  begin
      # open the database
      db = SQLite3::Database.open database

      # create Students table if it doesn't exist
      db.execute("CREATE TABLE IF NOT EXISTS 
                    Students( id INTEGER PRIMARY KEY AUTOINCREMENT, 
                              name TEXT,
                              twitter_link TEXT,
                              linkedin_link TEXT,
                              quote TEXT
                              )"
                              #linkedin_link TEXT
                )

      # insert specific student into Students table if it doesn't exist
      db.execute("DELETE FROM Students WHERE name=?", student_name)
      db.execute("INSERT INTO Students(name, twitter_link, linkedin_link, quote)
                              VALUES(?,?,?,?)", student_name, student_twitter, student_linkedin, student_quote
                )            
  rescue SQLite3::Exception => e     
      puts "Exception occurred"
      puts e    


  ensure
      db.close if db
  end

end