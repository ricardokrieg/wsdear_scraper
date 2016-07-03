require './category'
require './exporter'

urls = [
    'http://www.wsdear.com/womens-clothing-sweats.html',
    'http://www.wsdear.com/womens-jumpsuit.html',
    'http://www.wsdear.com/cheap-jewelry.html',
]

# $limit = ENV['LIMIT'] || 50
$limit = nil

urls.each do |url|
  begin
    puts

    category = Category.new(url)
    category.scrape!

    Exporter.export_products(category.products, category.filename)
  rescue => e
    puts "Error: #{e.message}"
    puts "Try again"
    retry
  else
    puts "URL: #{url} scraped and exported."
  end
end
