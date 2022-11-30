class LeasesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record_response

    def create
        lease = Lease.create!(lease_params)
        render json: lease, status: :created
    end

    def destroy
        lease = find_lease
        lease.destroy
        head :no_content
    end

    private

    def lease_params
        params.permit(:apartment_id, :tenant_id, :rent)
    end

    def find_lease
        Lease.find(params[:id])
    end

    def render_not_found_response
        render json: { error: lease.errors.full_messages }, status: :not_found
    end

    def render_invalid_record_response(invalid)
        render json: { error: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

end
