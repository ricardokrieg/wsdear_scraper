require 'open-uri'
require 'nokogiri'

require './product'

class Category
  attr_reader :url, :title, :products

  def initialize(url)
    @url = url

    @title = nil
    @breadcrumb = []

    @product_urls = []
    @products = []
  end

  def scrape!
    @product_urls = []

    load
    scrape_products
  end

  def filename
    "#{@breadcrumb.join('_').downcase.gsub(/[^a-z_]/, '')}.csv"
  end

  private

  def load
    url_to_load = @url
    loop do
      url_to_load = load_url(url_to_load)

      break unless url_to_load
      break if !$limit.nil? && @product_urls.size >= $limit
    end

    puts "Page: #{@title} (#{@breadcrumb.join(' / ')})"
    puts "Collected #{@product_urls.size} urls"
  end

  def load_url(url)
    puts "Loading URL: #{url}"

    doc = Nokogiri::HTML(open(url))

    if @breadcrumb.empty?
      doc.css('ul.breadcrumb li').each do |li|
        next if ['home', 'product'].include?(li.attr('class'))

        @breadcrumb << li.text.strip
      end
    end

    @title ||= doc.css('h1').text
    @product_urls += doc.css('a.product-image').map {|a| a.attr('href') }

    if (next_page = doc.css('a.next.i-next')).any?
      return next_page.attr('href')
    else
      return false
    end
  end

  def scrape_products
    @product_urls.each do |product_url|
      product = Product.new(product_url, @breadcrumb)
      product.scrape!

      @products << product

      break if !$limit.nil? && @products.size >= $limit
    end
  end
end
