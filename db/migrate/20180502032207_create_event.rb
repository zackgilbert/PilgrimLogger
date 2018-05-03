class CreateEvent < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.text :raw_data
    end
  end
end
