class CreateArtisans < ActiveRecord::Migration[7.1]
  def change
    create_table :artisans do |t|
      t.string :name
      t.text :bio
      t.string :contact_email

      t.timestamps
    end
  end
end
