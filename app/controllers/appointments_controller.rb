class AppointmentsController < ApplicationController
  def create
    appointment = Appointment.new(appointment_attributes)

    head :ok and return if appointment.save
    
    render json: { errors: appointment.errors. full_messages }, status: :bad_request
  end

  def show
    appointment = Appointment.find(params[:id])

    render json: { appointment: appointment.attributes }, status: :ok
  end

  private
  def appointment_attributes
    params.require(:appointment).permit(:responsible_name, :start_time, :end_time, :room_id)
  end
end
