class AdverseMediaChecksController < ApplicationController
  def create
    @check = AdverseMediaCheck.new(adverse_media_check_params)

    if @check.save
      AdverseMediaCheckJob.perform_later(@check.id)

      respond_to do |format|
        format.html { redirect_to @check.adverse_media_checkable }
        format.turbo_stream
      end
    end
  end

  private

  def adverse_media_check_params
    params.expect(
      adverse_media_check: [
        :adverse_media_checkable_id,
        :adverse_media_checkable_type
      ]
    )
  end
end
