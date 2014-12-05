class CreateCreditCard
  def self.call(credit_card, args)

    create_response = credit_card.wepay_create(args)
    if create_response && create_response["credit_card_id"]
      credit_card.wepay_credit_card_id = create_response["credit_card_id"]
    else
      credit_card.errors[:base] << create_response["error_description"]
      return credit_card
    end

    find_response = credit_card.wepay_find

    if find_response && find_response["credit_card_id"]
      credit_card.nickname = find_response["credit_card_name"]
      credit_card.status = find_response["state"]
      credit_card.save!
    else
      credit_card.errors[:base] << find_response["error_description"]
      return credit_card
    end

    credit_card
  end
end
