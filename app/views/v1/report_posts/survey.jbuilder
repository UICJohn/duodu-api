json.call(@survey, :id, :title, :body)
json.options do
  json.array! @survey.survey_options do |option|
    json.call(option, :id, :body, :position, :custom_option)
  end
end
