class Api::V1::ShipmentPresenter < Api::V1::JsonPresenter

  HASH = %w(id notes picture_url dim_w dim_h dim_l distance weight hazard pickup_at_from pickup_at_to arrive_at_from arrive_at_to price stackable n_of_cartons cubic_feet unit_count skids_count track_frequency)
  # http://rubendiazjorge.me/2015/03/23/faster-rails-json-responses-removing-jbuilder-and-view-rendering/
  def self.minimal_hash(shipment, current_user)
    if shipment.user == current_user
      hash = shipment.attributes.except!('created_at', 'updated_at', 'user_id').keys
    else
      hash = Api::V1::ShipmentPresenter::HASH
    end
    json = hash_for(shipment, hash)
    low_proposal  = shipment.low_proposal
    high_proposal = shipment.high_proposal
    avg_proposal = shipment.avg_proposal
    json[:proposals] = {low: low_proposal, high: high_proposal, avg: avg_proposal} unless shipment.hide_proposals?
    json
  end

end