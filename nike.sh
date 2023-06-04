#!/usr/bin/env bash

# fetch_nike_puls_all_activities.bash
# A simple bash script to fetch all activities and metrics from NikePlus.
# See `nike_plus_api.md` for the API details.

readonly bearer_token="eyJhbGciOiJSUzI1NiIsImtpZCI6IjMwZTQ0MjE1LThjZTAtNDdiZi04Y2Y1LWQwNGViOGM4ZTI1N3NpZyJ9.eyJpYXQiOjE2ODU4NDEwNjcsImV4cCI6MTY4NTg0NDY2NywiaXNzIjoib2F1dGgyYWNjIiwianRpIjoiYWU4Mzg5MDUtNWQ5Ny00YmYzLWFlYmMtMTE1NzdiMjY0NTg5IiwiYXVkIjoiY29tLm5pa2UuZGlnaXRhbCIsInNidCI6Im5pa2U6YXBwIiwidHJ1c3QiOjEwMCwibGF0IjoxNjg1ODQxMDY1LCJzY3AiOlsibmlrZS5kaWdpdGFsIl0sInN1YiI6ImNvbS5uaWtlLmNvbW1lcmNlLm5pa2Vkb3Rjb20ud2ViIiwicHJuIjoiZDQxNTZiM2YtZjI5MC00MzNhLWI4OTMtNDQyZWRlMGIzZTAyIiwicHJ0IjoibmlrZTpwbHVzIiwibHJzY3AiOiJvcGVuaWQgbmlrZS5kaWdpdGFsIHByb2ZpbGUgZW1haWwgcGhvbmUgZmxvdyBjb3VudHJ5In0.pKRohkcXTnQdX1X99t6uVY1L33gz58SfLWzGSE8OPaXfkXga39_EscarAApIypXbPjlmvuBjCjkZJZZou5D6ZBifKqoxFzFqA3eOIWW3MIheAlqKWM1b20RzhnUqddk93wH2O4SKHW1aplPfzb1C8yDeolwZFhI-GKXMWfHPS8UpUC-r4gGqp58tFxWQrxMAdmMRxMP6SpmesPLsW8lJwBZ6jaYc0o5SOWVP7mE49qRFhQYvBtX6AR9cn8_ETGzelkiZa8aw3PbjaB2CAhSrCQYZwDRx7F5-UpMfRIP2_20iOF1Naq2eB3HylsrP8elREz1-VVVaDHzWOsSARC5GcA"
if [[ -z "$bearer_token" ]]; then
  echo "Usage: $0 bearer_token"
  exit
fi

if ! type jq >/dev/null 2>&1; then
  echo "Missing jq, please install it. e.g. brew install jq" >&2
  exit 1
fi

nike_plus_api() {
  curl -H "Authorization: Bearer ${bearer_token}" "$@"
}

activity_ids=()
activities_page=0
while true; do
  activities_file="activities-${activities_page}.json"

  if [[ -z "$after_id" ]]; then
    url="https://api.nike.com/sport/v3/me/activities/after_time/0"
  else
    url="https://api.nike.com/sport/v3/me/activities/after_id/${after_id}"
  fi

  echo "Fetch $url..."
  nike_plus_api "$url" > "$activities_file"

  activity_ids=("${activity_ids[@]}" $(jq -r ".activities[].id" "$activities_file"))

  after_id=$(jq -r ".paging.after_id" "$activities_file")
  if [[ "$after_id" == "null" ]]; then
    break
  else
    activities_page=$((activities_page + 1));
  fi
done

for activity_id in ${activity_ids[@]}; do
  activity_file="activity-${activity_id}.json"

  url="https://api.nike.com/sport/v3/me/activity/${activity_id}?metrics=ALL"

  echo "Fetch $url..."
  nike_plus_api "$url" > "$activity_file"
done
