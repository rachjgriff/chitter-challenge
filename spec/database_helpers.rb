require 'pg'

def persisted_data(id:)
  connection = PG.connect(dbname: "Chitter_Test")
  result = connection.query("SELECT * FROM peep WHERE id = #{id};")
  result.first
end
