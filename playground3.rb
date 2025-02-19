require "json"

# Array to store the activities data
all_activities_data = []

# Retrieve a list of matching file names
activity_files = Dir.glob("activities-*.json")

# Iterate over the activity files
activity_files.each do |file_name|
  activities_file = File.read(file_name)
  activities_data = JSON.parse(activities_file)

  # Access the activity IDs and additional variables
  activities_data["activities"].each do |activity|
    activity_id = activity["id"]
    start_epoch_ms = activity["start_epoch_ms"]
    start_date = Time.at(start_epoch_ms / 1000)
    formatted_date = start_date.strftime("%B %d, %Y")
    summaries = activity["summaries"]
    tags = activity["tags"]
    results = {}

    # Iterate over the summaries array
    summaries.each do |summary|
      metric = summary["metric"]
      value = summary["value"]

      # Store the result in the corresponding variable based on the metric
      case metric
      when "pace"
        results[:pace] = value
      when "nikefuel"
        results[:nikefuel] = value
      when "speed"
        results[:speed] = value
      when "distance"
        results[:distance] = value
      when "calories"
        results[:calories] = value
      when "steps"
        results[:steps] = value
      end
    end

    puts "Title: " + tags.fetch("com.nike.name").to_s
    puts "formatted_date: #{formatted_date}"
    puts "Distance: #{results[:distance]}"
    puts "Pace: #{results[:pace]}"
    puts "Time: " + ("#{results[:distance]}".to_f * "#{results[:pace]}".to_f).round(2).to_s
    puts "Calories: #{results[:calories]}"
    puts "Steps: #{results[:steps]}"
    time = ("#{results[:distance]}".to_f * "#{results[:pace]}".to_f)
    steps = "#{results[:steps]}".to_f
    puts "Cadence: " + (steps / time).to_s
    puts
  end
end
