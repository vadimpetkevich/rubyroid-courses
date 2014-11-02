require 'open-uri'
require 'nokogiri'

begin
  n_posts = Integer(ARGV[0])
  raise Exception if n_posts < 0
rescue TypeError
  puts 'There are no command line arguments. Use bash.rb COUNT'
  exit 1
rescue Exception
  puts 'Number of posts must be positive integer.'
  exit 1
end

begin
  page = Nokogiri::HTML(open('http://bash.im')) unless n_posts == 0
rescue Errno::ENETUNREACH => net_exception
  puts net_exception.message
  file.close
  exit 1
end
file = File.new('bash.csv', 'w')

until n_posts == 0 do
  posts = page.css('div[class="text"]')
  posts_id = page.css('a[class="id"]')
  posts_date = page.css('span[class = "date"]')

  posts[0...n_posts].each_with_index do |post, i|
    file.puts(post.text + ';' + posts_id[i].text + ';' + posts_date[i].text)
  end

  n_posts = (n_posts - posts.length) < 0 ? 0 : n_posts - posts.length
  unless n_posts == 0
    current_page_number = Integer( page.css('input[min = "1"]').first['value'] )
    break if current_page_number == 0
    page = Nokogiri::HTML(open('http://bash.im/index/' + (current_page_number - 1).to_s))
  end
end

file.close