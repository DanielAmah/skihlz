class AddCompletedAndPaymentTime < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :completed, :boolean, :default =>  true
    add_column :orders, :time_of_payment, :datetime
    #Ex:- :default =>''
  end
end
