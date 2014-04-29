class AddNameRuToCategory < ActiveRecord::Migration
  def change
      add_column :categories, :name_ru, :text
      Category.reset_column_information
      Category.connection.execute('UPDATE categories SET name_ru=name_en')
  end
end
