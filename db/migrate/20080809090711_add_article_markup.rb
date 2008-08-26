class AddArticleMarkup < ActiveRecord::Migration
  def self.up
    add_column :articles, :formatting_type, :string, :limit => 20, :default => "HTML"
  end

  def self.down
    remove_column :articles, :formatting_type
  end
end
