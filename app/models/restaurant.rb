class Restaurant < ActiveRecord::Base
  attr_accessible :pricing, :popularity, :name, :address, :city, :state, :review_count, :rating, :opentable_id, :lat, :long, :pricing_info

  def self.update_availabilities date, time
    response = HTTParty.get(url(date, time)).parsed_response
    restaurants = /{\"Id\".*}\]/.match(response)[0].split("},{\"Id\":")
    successes = 0
    failures = 0
    restaurants.each do |r|
      begin 
        prefix = "{\"Id\":"
        suffix = "}"
        json_ready =  prefix + r + suffix
        r = JSON.parse(fixed)
        #do something with parsed restauraunt here
        p r["Name"]
        successes += 1
      rescue => error
        p $!.message
        failures += 1
      end
    end
    "#{successes} successes, #{failures} failures"
  end

  def self.dump_and_refresh_all
    response = HTTParty.get("http://www.opentable.com/s/").parsed_response
    restaurants = /{\"Id\".*}\]/.match(response)[0].split("},{\"Id\":")
    successes = 0
    failures = 0
    popularity = 1
    restaurants.each do |r|
      begin 
        prefix = "{\"Id\":"
        suffix = "}"
        json_ready =  prefix + r + suffix
        r = JSON.parse(json_ready)
        rest = create(name: r["Name"], address: r["Address"], lat: r["Lat"],
        long: r["Lon"], opentable_id: r["Id"], popularity: popularity)
        # remember to add cuisine
        if r["Reviews"]
          rest.update_attributes rating: r["Reviews"]["Rating"], review_count: r["Reviews"]["Total"]
        end
        if r["PriceBand"]
          rest.update_attributes pricing: r["PriceBand"]["Id"]
        end
        p rest.name
        popularity += 1
        successes += 1
      rescue => error
        p $!.message
        failures += 1
      end
    end
    "#{successes} successes, #{failures} failures"
  end

  def self.url date, time
    #date format: yyyy-mm-dd
    #time format: HH:MM
    "http://www.opentable.com/s/?datetime=#{date}%20#{time}&covers=2&showmap=false&popularityalgorithm=NameSearches&tests=EnableMapview,ShowPopularitySortOption,srs,customfilters&sort=Popularity&excludefields=Description&from=0"
  end
end



