class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.create_or_update(attributes, key: nil)
    key_attrs = key.present? ? {"#{key}" => attributes[key.to_sym]} : attributes
    if obj = find_by(key_attrs)
      obj.update_attributes(attributes)
      return obj
    else
      return create(attributes)
    end
  end
end
