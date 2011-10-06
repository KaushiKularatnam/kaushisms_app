class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.text :description
      t.timestamp :date_added

      t.timestamps
    end
  end
end
