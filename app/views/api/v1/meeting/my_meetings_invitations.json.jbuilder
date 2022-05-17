json.my_meetings_invitations @my_meetings_invitations do |meeting|
  json.id meeting.id
  json.start_time meeting.start_time
  json.end_time meeting.end_time
  json.room Room.find(meeting.room_id).name
  json.owner_name meeting.owner.name
  json.owner_email meeting.owner.email
  json.subject meeting.subject
  json.created_at meeting.created_at
  json.updated_at meeting.updated_at
  json.participants meeting.users do |participant|
    json.name participant.name
    json.email participant.email
  end
end
