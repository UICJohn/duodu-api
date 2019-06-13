json.user do
  json.email @user.email
  json.phone @user.hidden_phone
  json.username @user.username
  json.avatar URI.join(request.url, @user.avatar.url)
  json.country @user.country
  json.city @user.city
  json.province @user.province
  json.into @user.intro
  json.suburb @user.suburb
  json.gender @user.gender
  json.occupation @user.occupation
  json.tags @user.tags
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.school @user.school
  json.major @user.major
  json.intro @user.intro
  json.password_status @user.password_status
end