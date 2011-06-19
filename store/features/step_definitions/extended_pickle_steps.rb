Given /^#{capture_model} "([^"]*)" is updated to #{capture_fields}$/ do |model_name, name, fields|
  model(model_name).class.find_by_name(name).update_attributes!(parse_fields(fields))
end

