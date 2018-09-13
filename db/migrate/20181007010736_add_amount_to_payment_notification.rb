class AddAmountToPaymentNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_notifications, :amount, :string
  end
end
