class ObjectStatus < ApplicationRecord
  require 'csv'
  # Skipping all model validations since there is DB validation.
  # And, adding model validations will slow down bulk insert.

  IMPORT_STATUS_BROADCAST_THRESHOLD = 1000

  def self.perform_import(file)
    object_status = []
    total_rows_count = total_csv_rows_count(file)

    row_index = 0
    # Read each line and build `ObjectStatus` and push it to an array
    CSV.foreach(file) do |row|
      row_index += 1

      object_status << ObjectStatus.new(object_id: row[0],
                                        object_type: row[1],
                                        timestamp: row[2],
                                        object_changes: JSON.parse(row[3]))


      # Update the status for each 1000 records
      if IMPORT_STATUS_BROADCAST_THRESHOLD == row_index || total_rows_count == $.
        broadcast_import_status("Parsing the CSV file ... #{($..to_f * 100/total_rows_count).round(1)}% completed")

        row_index = 0
      end
    end

    broadcast_import_status('Importing records into the Database ...')

    # Finally import everything in bulk.
    ObjectStatus.import object_status, on_duplicate_key_ignore: true,  validate: false

    broadcast_import_status('Import Successful')
  end

  def self.get_object_changes(object_params)
    object_status = ObjectStatus.where(object_type: object_params[:object_type],
                                       object_id: object_params[:object_id],
                                       timestamp: object_params[:timestamp]).first

    object_changes = object_status.present? ? object_status.object_changes : {}

    { status: true, object_changes: object_changes.to_json }
  end

  # This will be run through CRON on the first day of every month to destroy all
  # month old entries.
  # Steps:
  #> crontab -e
  #> 0 0 1 * * /bin/bash -l -c 'cd <PROJECT_PATH> && RAILS_ENV=<ENV> bundle exec rails runner "ObjectStatus.delete_one_month_old_objects" --silent'
  def self.delete_one_month_old_objects
    ObjectStatus.where('DATE(created_at) <= ?', Date.today - 1.month).delete_all
  end

  private

  # Returns the total number of rows in the CSV file.
  def self.total_csv_rows_count(file)
    `wc -l "#{file.path}"`.split(' ').first.to_i
  end

  def self.broadcast_import_status(message)
    ActionCable.server.broadcast :csv_import_status_channel, message: message
  end
end
