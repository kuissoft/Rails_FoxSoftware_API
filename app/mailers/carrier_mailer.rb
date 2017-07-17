class CarrierMailer < ApplicationMailer

  # shipment - object, recipient - email address
  def send_invitation(shipment, recipient)
    @link = Settings.host + "/shipments/#{shipment.id}?invitation=#{shipment.secret_id}"
    mail to: recipient, subject: 'Invitation for proposing on shipment'
  end

  def offered_status(shipment)
    proposal = shipment.offered_proposal
    return unless proposal # well, its always has to be offered_proposal when calling this method, but in tests if can not
    @link = Settings.host + "/my/proposals/#{proposal.id}"
    @name = proposal.user.name
    mail to: proposal.user.email, subject: 'You got offer for your proposal!'
  end

  # When shipment accepted by the shipper, we let know all other carriers that their proposals are rejected
  def shipment_rejected(proposal)
    # shipment = proposal.shipment
    @name = proposal.user.name
    @link = Settings.host + '/my/proposals'
    mail to: proposal.user.email, subject: 'Your proposal has been rejected'
  end

  # def proposal_retracted(proposal)
  #   @shipment = proposal.shipment
  #   @shipper = @shipment.user
  #   @proposal = proposal
  #   mail to: @shipper.email, subject: "Proposal retracted for shipment: #{@shipment.id} by #{proposal.user.name}"
  # end

  # Updated while being in status :confirming
  def updated_shipment(shipment)
    proposal = shipment.offered_proposal
    return unless proposal
    @link = Settings.host + "/my/proposals/#{proposal.id}"
    @name = proposal.user.name
    @shipment = shipment
    mail to: proposal.user.email, subject: "Shipment ID:#{shipment.id} has been changed"
  end
end