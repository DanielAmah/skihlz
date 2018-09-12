class CreatePaymentNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_notifications do |t|
      t.text :params
      t.integer :order_id
      t.string :transaction_id
      t.timestamps
    end
  end
end
