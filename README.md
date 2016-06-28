First install the gems

```shell
$ bundle install
```

Then open the file `wsdear_scraper.rb` and add the urls, as in this example:

```ruby
urls = [
  'http://www.wsdear.com/womens-clothing-sweats.html',
  'http://www.wsdear.com/womens-jumpsuit.html',
  'http://www.wsdear.com/cheap-jewelry.html',
]
```

Run it:

```shell
$ ruby wsdear_scraper.rb
```

The images will be saved on folder `images`

The csv files (one for each category/url) will be saved on folder `export`