class ObjectStatus < ApplicationRecord
  # Skipping all model validations since there is DB validation.
  # And, adding model validations will slow down bulk insert.
end
