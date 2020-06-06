class ChangeCaptionToText < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :caption, :text
  end
end
