Sequel.migration do
  up do
    create_table :users do
      String :username, text: true, null: false
      String :password, text: true, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      primary_key :id, type: Integer
    end
  end

  down do
    drop_table :users
  end
end
