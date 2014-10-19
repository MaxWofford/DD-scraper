require 'nokogiri'
require 'open-uri'
require 'pry'
require 'date'

base_url = "http://www.deviantart.com/dailydeviations/?day="
date = Date.today
url_addition = "#{date.year}-#{date.month}-#{date.day}"

## grab all broad links to popular destinations
output = File::open("DD_data.txt", "w")
output << '['

(1..365).each do |pg|
    url = base_url + url_addition
    Nokogiri::HTML(open(url)).css("a.thumb").each do |box|
        link = box["href"]
        category = box["title"]
        output << "{\"catagory\"   : \"#{category}\",
                \"link\"   : \"#{link}\"
                },"
    end
    puts "I just scraped Daily Deviations from #{date}!"
    sleep 1.0 + rand # sleep to avoid hitting the server too frequently
    date -= 1 # move down one day
end

output << "]"
output.close
puts "Done! ^_^"
