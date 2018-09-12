class AddPaymentStatus < ActiveRecord::Migration[5.2]
  def change
    change_column :payment_notifications, :order_id, :string
    add_column :payment_notifications, :status, :string
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
