# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


f = File.open('logfile.txt', 'r')

contents = f.read

restaurants = contents.split("},{\"Id\":")
success = 0
failure = 0
popularity = 1

restaurants[1..-1].each do |r|
  begin 
    prefix = "{\"Id\":"
    suffix = "}"
    fixed =  prefix + r + suffix
    r = JSON.parse(fixed)
    rest = Restaurant.create(name: r["Name"], address: r["Address"], lat: r["Lat"],
    long: r["Lon"], opentable_id: r["Id"], popularity: popularity)
    if r["Reviews"]
      rest.update_attributes rating: r["Reviews"]["Rating"], review_count: r["Reviews"]["Total"]
    end
    if r["PriceBand"]
      rest.update_attributes pricing: r["PriceBand"]["Id"]
    end
    binding.pry
    p rest.name
    popularity += 1
    success += 1
  rescue
    failure += 1
  end
end

p success.to_s + " successes"
p failure.to_s + " failures"
