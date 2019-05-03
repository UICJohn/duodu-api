json.user do
  json.email @user.email
  json.username @user.username
  json.country @user.country
  json.city @user.city
  json.province @user.province
  json.into @user.intro
  json.suburb @user.suburb
  json.gender @user.gender
end