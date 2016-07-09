require './category'
require './exporter'

urls = [
  'http://www.wsdear.com/womens-summer-dresses.html',
  'http://www.wsdear.com/womens-black-dresses.html',
  'http://www.wsdear.com/womens-chiffon-dresses.html',
  'http://www.wsdear.com/womens-casual-dresses.html',
  'http://www.wsdear.com/womens-lace-dresses.html',
  'http://www.wsdear.com/womens-maxi-dresses.html',
  'http://www.wsdear.com/womens-mini-dresses.html',
  'http://www.wsdear.com/womens-party-club-dresses.html',
  'http://www.wsdear.com/womens-bodycon-dresses.html',
  'http://www.wsdear.com/womens-clothing-shirts-blouses.html',
  'http://www.wsdear.com/womens-clothing-t-shirts.html',
  'http://www.wsdear.com/womens-tank-tops.html',
  'http://www.wsdear.com/womens-clothing-skirts.html',
  'http://www.wsdear.com/womens-clothing-jeans.html',
  'http://www.wsdear.com/womens-shorts-pants.html',
  'http://www.wsdear.com/womens-trousers-pants.html',
  'http://www.wsdear.com/womens-jumpsuit.html',
  'http://www.wsdear.com/womens-clothing-sweats.html',
  'http://www.wsdear.com/leggings.html',
  'http://www.wsdear.com/womens-swimwear-beachwear.html',
  'http://www.wsdear.com/womens-clothing-sweaters-cardigans.html',
  'http://www.wsdear.com/womens-clothing-plus-size.html',
  'http://www.wsdear.com/womens-clothing-blazers.html',
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
