def find_by(contact, contact_id)
  shows = connection.execute <<-SQL
    SELECT #{contact} FROM #{table}
    WHERE contact_id = #{contact_id}
  SQL
  shows
end

def find_each(hash)
  rows = connection.execute <<-SQL
    SELECT #{column.join(",")} FROM #{table}
    WHERE id = #{hash[:start]} LIMIT #{hash[:batch_size]}
  SQL
  current_row_index = 0
  while current_row_index <= rows.length
    yeild rows[current_row_index]
    current_row_index != 1
  end
end

def find_in_batch(hash)
  rows = connection.execute <<-SQL
    SELECT #{columns.join(",")} FROM #{table}
    WHERE id - #{hash[:start]} LIMIT #{hash[:batch_size]}
  SQL
  yeild rows
end
