class CreateCharts < ActiveRecord::Migration[5.0]
  def change
    create_table :charts do |t|
      t.text :x_variables
      t.text :y_variables
      t.text :chart_string
      t.string :name

      t.timestamps
    end
  end
end
