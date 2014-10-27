require 'nokogiri'
require 'open-uri'
require 'pry'
require 'date'

base_url = "http://www.deviantart.com/dailydeviations/?day="
date = Date.today
url_addition = "#{date.year}-#{date.month}-#{date.day}"

## grab all broad links to popular destinations
output_text = File::open("DD_data.txt", "w")
output_csv = File.open("DD_data.csv", "w")
output_text << '['
output_csv << "date,link,top_level,category\n"

(1..(365 * 2)).each do |pg|
    url = base_url + url_addition
    Nokogiri::HTML(open(url)).css("a.thumb").each do |box|
        link = box["href"]
        category = box["title"]
        if category.is_a? String
            category = box["title"].sub(/^(.*?)\ in /, '').gsub(/,/, '')
            top_level = category.sub(/ >.*/, '')
        end
        output_csv << "#{date},\"#{link}\",\"#{top_level}\",\"#{category}\"\n"
        output_text << "{\"date\" : \"#{date}\",
                \"catagory\"   : \"#{category}\",
                \"link\"   : \"#{link}\"
                },"
    end
    puts "I just scraped Daily Deviations from #{date}!"
    sleep 1.0 + rand # sleep to avoid hitting the server too frequently
    if rand > 0.99
        sleep 5.0
    end
    date -= 1 # move down one day
end

output_text << "]"
output_text.close
puts "Done! ^_^"
