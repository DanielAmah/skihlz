class ModifyCompleted < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :completed
    add_column :orders, :completed, :boolean, :default => false
  end
end
