# frozen_string_literal: true

class ReservationsController < ApplicationController
  def create_or_update
    render json: Payload::ReservationProcessor.call(params), status: :ok
  end
end
