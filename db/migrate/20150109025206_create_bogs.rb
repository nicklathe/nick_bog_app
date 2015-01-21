class CreateBogs < ActiveRecord::Migration
  def change
    create_table :bogs do |t|
      t.string :name
      t.string :desc

      t.timestamps
    end
  end
end
