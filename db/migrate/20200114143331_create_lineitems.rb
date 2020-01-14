class CreateLineitems < ActiveRecord::Migration[5.2]
  def change
    create_table :lineitems do |t|
      t.integer :product_id
      t.integer :quantity
      t.decimal :line_item_total
      t.integer :order_id

      t.timestamps
    end
  end
end
