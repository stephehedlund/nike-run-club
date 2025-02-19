require 'json'

# Read the activities JSON file
activities_file = File.read('activities-0.json')

# Parse the activities JSON data
activities_data = JSON.parse(activities_file)

# Access the activity IDs and additional variables
activities_data['activities'].each do |activity|
  activity_id = activity['id']
  start_epoch_ms = activity['start_epoch_ms']
  # start_date = Time.at(start_epoch_ms/1000)
  # formatted_date = start_date.strftime('%B %d, %Y')
  summaries = activity ['summaries']
  tags = activity ['tags']
  results = {}

# Iterate over the summaries array
summaries.each do |summary|
  metric = summary['metric']
  value = summary['value']
  
  # Store the result in the corresponding variable based on the metric
  case metric
  when 'pace'
    results[:pace] = value
  when 'nikefuel'
    results[:nikefuel] = value
  when 'speed'
    results[:speed] = value
  when 'distance'
    results[:distance] = value
  when 'calories'
    results[:calories] = value
  when 'steps'
    results [:steps] = value  
  end
end

results_hash = {}

results_hash["Title"] = tags.fetch("com.nike.name")
results_hash["start_epoch_ms"] = start_epoch_ms
results_hash["Distance"] = "#{results[:distance]}"
results_hash["Pace"] = "#{results[:pace]}"
results_hash["Calories"] = "#{results[:calories]}"
results_hash["Steps"] = "#{results[:steps]}"


puts results_hash

 
  
end
