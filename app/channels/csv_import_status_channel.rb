class CsvImportStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from :csv_import_status_channel
  end
end
