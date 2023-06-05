class HomeController < ApplicationController

def home
  require "json"

# Array to store the activities data
@all_results = []

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
      when "heart_rate"
        results[:heart_rate] = value
      when "ascent"
        results[:ascent] = value
      when "descent"
        results[:descent] = value
      end
    end

    results_hash = {}

    results_hash["start_epoch_ms"] = start_epoch_ms
    results_hash["distance"] = "#{results[:distance]}"
    results_hash["pace"] = "#{results[:pace]}"
    results_hash["calories"] = "#{results[:calories]}"
    results_hash["steps"] = "#{results[:steps]}"
    results_hash ["heart_rate"] = "#{results[:heart_rate]}"
    results_hash ["ascent"] = "#{results[:ascent]}"
    results_hash ["descent"] = "#{results[:descent]}"
    @all_results << results_hash
  end
end


  render({:template=> "home/home.html.erb"})
end

end
