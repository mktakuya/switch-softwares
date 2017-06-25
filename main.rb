require 'csv'
require 'open-uri'
require 'nokogiri'

url = 'https://www.nintendo.co.jp/software/switch/index.html'
html = Nokogiri::HTML(open(url))

will_be_released = html.search('#section-will-be-released')[0]

softwares = []
will_be_released.search('.local-lineup-plans-grid__col--text').each do |div|
  software = {}
  software[:title] = div.search('.local-lineup-plans__textLink')[0].children[1].text.gsub(/\r|\n| /, "")
  begin
    software[:date] = Date.parse(div.search('.local-lineup-plans__textDate')[0].children[0].text)
  rescue
    software[:date] = div.search('.local-lineup-plans__textDate')[0].children[0].text.gsub(/\[.*\] /, '')
  end
  softwares.push(software)
end

CSV.open('./data.csv', 'wb') do |csv|
  csv << ['タイトル', '発売日']
  softwares.each do |software|
    csv << [software[:title], software[:date].to_s]
  end
end
