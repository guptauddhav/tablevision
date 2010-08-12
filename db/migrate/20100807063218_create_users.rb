class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :firstname, :null => false
      t.string :lastname, :null => false
      t.string :username, :null => false
      t.string :email, :null => false
      t.string :hashed_password, :null => false
      t.string :salt, :null => false
      t.string :ip_address
      t.boolean :active
      t.datetime :last_login_date
      t.datetime :created_at
      t.string :activation_id
      
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :users
  end
end
