json.extract! room, :id, :name, :ids, :password, :created_at, :updated_at
json.url room_url(room, format: :json)
