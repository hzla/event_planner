class CreditCard < ActiveRecord::Base
  belongs_to :user

  attr_accessor :cc_number, :cvv, :expiration_month, :expiration_year, :address1, :address2, :city, :state, :zip, :original_ip, :original_device
  attr_accessible :cc_number, :cvv, :expiration_month, :expiration_year, :address1, :address2, :city, :state, :zip

  def wepay_create(args)
    response = WEPAY.call("/credit_card/create", user.payment_access_token, {
      client_id: WEPAY_CLIENT_ID,
      cc_number: cc_number,
      cvv: cvv,
      expiration_month: expiration_month,
      expiration_year: expiration_year,
      user_name: user.name,
      email: user.email,
      address: {
        address1: address1,
        address2: address2,
        city: city,
        state: state,
        country: "US",
        zip: zip,
      },
      original_ip: args[:original_ip],
      original_device: args[:original_device],
    })
  end

  def wepay_find
    response = WEPAY.call("/credit_card", false, {
      client_id: WEPAY_CLIENT_ID,
      client_secret: WEPAY_CLIENT_SECRET,
      credit_card_id: wepay_credit_card_id,
    })
  end

  def wepay_delete
    response = WEPAY.call("/credit_card/delete", false, {
      client_id: WEPAY_CLIENT_ID,
      client_secret: WEPAY_CLIENT_SECRET,
      credit_card_id: wepay_credit_card_id,
    })
  end
end
