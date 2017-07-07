class CarrierMailer < ApplicationMailer

  # shipment - object, recipient - email address
  def send_invitation(shipment, recipient)
    @link = Settings.host + "/shipments/#{shipment.id}?invitation=#{shipment.secret_id}"
    mail to: recipient, subject: 'Invitation for proposing on shipment'
  end
end