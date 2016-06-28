require './category'
require './exporter'

$url = ENV['URL'] || 'http://www.wsdear.com/womens-jumpsuit.html'
$category = ENV['CATEGORY'] || ['Women', 'Jumpsuits']
$limit = ENV['LIMIT'] || 10

category = Category.new($url)
category.scrape!

# product = Product.new('http://www.wsdear.com/summer-blue-flowers-printed-sleeveless-v-neck-straps-rompers.html')
# product = Product.new('http://www.wsdear.com/fashion-summer-bright-candy-colored-beads-bracelet-for-women.html')

# product.scrape!

filename = "#{$category.join('_').downcase}.csv"
Exporter.export_products(category.products, filename)
