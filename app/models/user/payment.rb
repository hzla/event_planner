class User
  module Payment

    def create_payment_user(params)
      return false if has_payment_user_id?
      response = WEPAY.call("/user/register", false, {
        client_id: WEPAY_CLIENT_ID,
        client_secret: WEPAY_CLIENT_SECRET,
        email: self.email,
        scope: 'view_user,preapprove_payments,collect_payments',
        first_name: self.first_name,
        last_name: self.last_name,
      }.merge(params))

      if response && response["user_id"]
        self.payment_user_id = response["user_id"]
        self.payment_access_token = response["access_token"]
        self.save!
        true
      else
        false
      end
    end

    def has_payment_user_id?
      payment_user_id.present?
    end

    def has_valid_payment_access_token?
      return false unless has_payment_access_token?
      response = WEPAY.call("/user", self.payment_access_token)
      response && response["user_id"] ? true : false
    end

    def has_payment_access_token?
      payment_access_token.present?
    end
  end
end
