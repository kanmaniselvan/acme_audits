class ObjectStatusesController < ApplicationController
  def index

  end

  def upload_csv
    file = params[:file]

    if file.blank? || 'csv' != file.path.split('.').last
      render json: { status: false, message: 'Invalid CSV file given!' } and return
    end

    render json: ObjectStatus.perform_import(File.open(file.path))
  rescue StandardError => ex
    render json: { status: ex, message: "Error occurred: #{ex}" }
  end
end
