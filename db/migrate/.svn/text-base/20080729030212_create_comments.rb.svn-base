class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :name, :limit => 40
      t.string :email, :limit => 40
      t.string :website, :limit => 40
      t.text :body
      t.boolean :approved, :default => false
      t.integer :article_id

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
