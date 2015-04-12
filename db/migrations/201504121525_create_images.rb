Sequel.migration do
  up do
    create_table :images do
      String :title, text: true, null: false, unique: true
      DateTime :created_at, null: false
      primary_key :id, type: Integer
    end
    run "alter table images alter column created_at set default current_timestamp"
  end

  down do
    drop_table :images
  end
end
