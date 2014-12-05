class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.references :user, index: true
      t.string :wepay_credit_card_id
      t.string :nickname
      t.string :status
    end
  end
end
