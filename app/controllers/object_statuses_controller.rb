class ObjectStatusesController < ApplicationController
  def index

  end

  def upload_csv
    file = params[:file]

    if file.blank? || 'csv' != file.path.split('.').last
      flash[:error] = 'Invalid CSV file uploaded!'
      redirect_to object_statuses_path and return
    end

    ObjectStatus.perform_import(File.open(file.path))

    redirect_to object_statuses_path
  rescue StandardError => ex
    flash[:error] = "Error occurred: #{ex}"
    redirect_to object_statuses_path
  end

  def get_object_changes
    render json: ObjectStatus.get_object_changes(object_status_params)
  end

  private
  def object_status_params
    params.permit(:object_type, :object_id, :timestamp)
  end
end
