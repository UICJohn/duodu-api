json.user do
  json.email @user.hidden_email
  json.phone @user.hidden_phone
  json.username @user.username
  json.avatar URI.join(request.url, @user.avatar.try(:url)) if @user.avatar.attached?
  json.location do
    json.country @user.location.country
    json.city @user.location.city
    json.province @user.location.province
    json.suburb @user.location.suburb
  end if @user.location.present?
  json.into @user.intro
  json.company @user.company
  json.gender @user.gender
  json.occupation @user.occupation
  json.tags @user.tags
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.school @user.school
  json.major @user.major
  json.intro @user.intro
  json.dob @user.dob
  json.password_status @user.password_status
  json.unconfirmed @user.unconfirmed_email.present?
  json.preference do
    json.id @user.preference.id
    json.show_privacy_data @user.preference.show_privacy_data
    json.share_location @user.preference.share_location
    json.receive_all_message @user.preference.receive_all_message
  end
end