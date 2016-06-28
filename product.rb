require 'open-uri'
require 'nokogiri'

class Product
  attr_reader :url
  attr_accessor :attrs

  def initialize(url, categories=[])
    @url = url
    @categories = categories
  end

  def scrape!
    puts "Product: #{@url}"

    doc = Nokogiri::HTML(open(@url))

    @attrs = {
        name: doc.css('h1.product-name').text,
        price: doc.css('.price-info .price-box .regular-price').text.strip,
        sku: doc.css('.sku .value').text,
    }

    @attrs[:price_as_float] = @attrs[:price].gsub(/\$/, '').to_f

    @attrs[:category] = @categories

    options_array = []
    # FIXME use only if will extract attributes (model, color, size ...)
    # details_array = []

    doc.css('.product-options dl dt, .product-options dl dd').each do |dt_dd|
      case dt_dd.name
      when 'dt'
        options_array << dt_dd.text.strip.gsub(/^\*/, '')
      when 'dd'
        values = dt_dd.css('ul.options-list li span.label label').map(&:text)
        options_array << values.map(&:strip)
      end
    end

    # FIXME fix description
    # if doc.css('#decription table').any?
    #   # FIXME use only if will extract attributes (model, color, size ...)
    #   # details_array = doc.css('#decription table tr th strong, #decription table tr td.data').map(&:text)
    #   details = doc.css('#decription table').to_s
    # elsif doc.css('#decription .details').any?
    #   doc.css('#decription .details').children.each do |el|
    #     case el.name
    #     when 'strong'
    #       details_array << el.text.strip
    #     when 'text'
    #       details_array << el.text.strip.gsub(/\:\ /, '') if el.text.strip != ''
    #     end
    #   end
    # else
    #   puts "Alert: No description found (#{@url})"
    # end

    details = doc.css('#decription').inner_html

    # FIXME use only if will use the entire details section (including measure instructions)
    # doc.css('#decription').css('script').remove
    # details_html = doc.css('#decription').inner_html

    options = Hash[*options_array]
    # FIXME use only if will extract attributes
    # details = Hash[*details_array]

    # FIXME use only if will download thumbnails
    # thumbnail_urls = doc.css('ul.product-image-thumbs li a img').map{ |i| i.attr('src') }
    image_urls = doc.css('.product-image-gallery img').map { |i| i.attr('src') }
    images = []

    folder = "images/#{attrs[:sku]}"
    FileUtils.mkdir_p(folder)

    image_urls.each_with_index do |image_url, i|
      extension = image_url.split('.').last

      image_path = "#{folder}/image_#{i}.#{extension}"
      File.open image_path, 'wb' do |io|
        io.write open(image_url).read
      end

      images << image_path
    end

    @attrs[:option_types] = options
    @attrs[:image_urls] = image_urls
    @attrs[:images] = images

    @attrs[:description] = details

  end
end
