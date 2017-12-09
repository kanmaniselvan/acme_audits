class ObjectStatus < ApplicationRecord
  require 'csv'
  # Skipping all model validations since there is DB validation.
  # And, adding model validations will slow down bulk insert.

  OBJECT_TYPES = %w(Order Product Invoice)

  def self.perform_import(file)
    object_status = []

    # Read each line and build `ObjectStatus` and push it to an array
    CSV.foreach(file) do |row|
      object_status << ObjectStatus.new(object_id: row[0],
                                        object_type: row[1],
                                        timestamp: row[2],
                                        object_changes: JSON.parse(row[3]))
    end

    # Finally import everything in bulk.
    ObjectStatus.import object_status, on_duplicate_key_ignore: true,  validate: false

    { status: true, message: 'Import Success!' }
  end
end
