class AppointmentsController < ApplicationController

  def index
    render json: { 
      errors: ['room_id must be present']
    }, status: :bad_request and return if params[:room_id].blank?

    appointments = Appointment.where(room_id: params[:room_id])
    appointments.map { |a| a.attributes }

    render json: { appointments: appointments }, status: :ok
  end

  def create
    appointment = Appointment.new(appointment_attributes)

    head :ok and return if appointment.save
    
    render json: { errors: appointment.errors.full_messages }, status: :bad_request
  end

  def show
    appointment = Appointment.find(params[:id])

    render json: { appointment: appointment.attributes }, status: :ok
  end

  def update
    appointment = Appointment.find(params[:id])

    head :ok and return if appointment.update(appointment_attributes)

    render json: { errors: appointment.errors.full_messages }, status: :bad_request
  end

  def destroy
    appointment = Appointment.find(params[:id])

    appointment.destroy

    head :ok
  end

  private

  def appointment_attributes
    params.require(:appointment).permit(:responsible_name, :start_time, :end_time, :room_id)
  end
end
