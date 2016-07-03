require 'open-uri'

class Connection
  def self.load_url(url, tries=10)
    open(url)
  rescue => e
    puts "Error: #{e.message}"

    if (tries -= 1) > 0
      puts "Try again"
      retry
    else
      raise e
    end
  end
end
