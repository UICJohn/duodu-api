class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.create_or_update(attributes, key: nil)
    key_attrs = key.present? ? { key.to_s => attributes[key.to_sym] } : attributes
    if (obj = find_by(key_attrs))
      obj.update(attributes)
      obj
    else
      create(attributes)
    end
  end
end
