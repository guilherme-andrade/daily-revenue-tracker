class Spreadsheet < ApplicationRecord
  has_many :daily_reports, dependent: :nullify
end
