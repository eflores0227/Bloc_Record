module BlocRecord
  class Collection < Array

    def update_all(updates)
      ids = self.map(&:id)

      self.any? ? self.first.class.update(ids, updates) : false
    end

    def group(*args)
      ids = self.map(&:id)
      self.any? ? self.first.class.group_by_ids(ids, args) : false
    end

    def destroy_all
      ids = ""
      self.each do |object|
        ids << object.id + ","
      end

      connection.execute <<-SQL
        DELETE FROM #{table}
        WHERE id in (#{ids})
      SQL
    end

    def distinct
      new_collection = Collection.new
      length_minus_one = new_collection.length - 1

      self.each do |entry|
        entry_distinct = true
        new_collection.each do |collection_entry|
          if entry == collection_entry
            entry_distinct = false
            break
          end
          new_collection << entry if entry_distinct == true
        end
        new_collection
      end
    end
  end
end
