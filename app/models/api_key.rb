class ApiKey < ApplicationRecord
  scope :active, -> { where(active: true) }
end
