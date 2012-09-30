class CreatePaymentsTransactions < ActiveRecord::Migration

  def change
    create_table :payments_transactions do |t|
      t.references :orderable, :polymorphic => true
      t.string :action
      t.float :amount
      t.string :reference
      t.boolean :success
      t.boolean :test
      t.text :message
      t.text :params
      t.integer :position

      t.timestamps
    end

  end

end
