class StockAvailabilityController < ApplicationController
  def index
    logger.info('Supermarket Warehouse receiving stock level request')
    respond_to do |format|
      format.html {render json: {3 => 'low stock', 42 => '20% surplus'}}
      format.json {render json: {3 => 'low stock', 42 => '20% surplus'}}
    end
  end
end
