class CreateEvent < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.text :raw_data
      t.text :raw_headers
      t.timestamps
    end
  end
end
