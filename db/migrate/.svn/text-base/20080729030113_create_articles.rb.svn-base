class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string    :title
      t.text      :excerpt
      t.text      :body
      t.boolean   :published, :default => true
      t.integer   :user_id
      t.string    :permalink, :limit => 40
      t.datetime  :published_date
      t.timestamps
    end
    add_index :articles, :permalink, :unique => true
  end

  def self.down
    drop_table :articles
  end
end
