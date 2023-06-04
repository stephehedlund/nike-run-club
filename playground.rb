require 'json'

# Read the activities JSON file
activities_file = File.read('activities-0.json')

# Parse the activities JSON data
activities_data = JSON.parse(activities_file)

# Access the activity IDs and additional variables
activities_data['activities'].each do |activity|
  activity_id = activity['id']
  start_epoch_ms = activity['start_epoch_ms']
  start_date = Time.at(start_epoch_ms/1000)
  formatted_date = start_date.strftime('%B %d, %Y')
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
  end
end


  # Perform operations with the variables
  # puts "Activity ID: #{activity_id}"
  # puts "Start_epoch_ms: #{start_epoch_ms}"
  puts tags.fetch("com.nike.name")
  puts "formatted_date: #{formatted_date}"
  # puts "summaries: #{summaries}"
  #puts summaries.first.fetch("metric")
  # puts summaries.first.fetch("value").round(2).to_s
  #puts summaries.at(3).fetch("metric")
  #puts summaries.at(3).fetch("value").round(2).to_s
  puts "Distance: #{results[:distance]}"
  puts "Pace: #{results[:pace]}"
  puts "Time: " + ("#{results[:distance]}".to_f * "#{results[:pace]}".to_f).round(2).to_s
  # puts "Speed: #{results[:speed]}"
 
  puts # Add more output or operations as needed
end
