class Api::V1::RoomsController < Api::V1::ApiController

  before_action :set_room, only: [:show, :update, :destroy]


  # GET /api/v1/organizations/{:org_id}/rooms
  def index
    @rooms = Room.where(organization_id: params[:organization_id])

    render json: @rooms
  end

  # GET /api/v1/organizations/{:org_id}/rooms/{:room_id}
  def show
    render json: @room
  end

  # POST /api/v1/organizations/{:org_id}/rooms
  def create
    @room = Room.new(room_params)

    if @room.save
      render json: @room, status: :created
    else
      render json: @room.errors, status: :unprocessable_entity
    end

  end

  # PUT /api/v1/organizations/{:org_id}/rooms/{:room_id}
  def update
    if @room.update(room_params)
      render json: @room
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/organizations/{:org_id}/rooms/{:room_id}
  def destroy
    @room.destroy
    render json: "Sala de reunião excluida com sucesso", status: :ok
  end

  private
    def set_room
      @room = Room.find(params[:id])
    end

    def room_params
      params.permit(:name, :organization_id)
    end
end
