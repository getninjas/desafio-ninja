class Api::V1::OrganizationsController < Api::V1::ApiController

  before_action :set_organization, only: [:show, :update, :destroy]

  # GET /api/v1/organizations
  def index
    @organizations = Organization.all

    render json: @organizations
  end

  # GET /api/v1/organizations/{id}
  def show
    render json: @organization
  end

  # POST /api/v1/organizations
  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      render json: @organization, status: :created
    else
      render json: @organization.errors, status: :unprocessable_entity
    end

  end

  # PUT /api/v1/organizations/{id}
  def update
    if @organization.update(organization_params)
      render json: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/organizations/{id}
  def destroy
    @organization.destroy
  end

  private
    def set_organization
      @organization = Organization.find(params[:id])
    end

    def organization_params
      params.require(:organization).permit(:name, :adress, :number_of_rooms, :work_on_weekend, :business_hours_start, :business_hours_end)
    end
end
