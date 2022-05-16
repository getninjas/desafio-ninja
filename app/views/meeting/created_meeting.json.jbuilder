json.id @meeting_cadidate.id
json.start_time @meeting_cadidate.start_time
json.end_time @meeting_cadidate.end_time
json.room Room.find(@meeting_cadidate.room_id).name
json.owner_name @meeting_cadidate.owner.name
json.owner_email @meeting_cadidate.owner.email
json.subject @meeting_cadidate.subject
json.created_at @meeting_cadidate.created_at
json.updated_at @meeting_cadidate.updated_at
json.participants @meeting_cadidate.users do |participant|
  json.name participant.name
  json.email participant.email
end
