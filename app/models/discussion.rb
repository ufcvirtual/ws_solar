class Discussion < ActiveRecord::Base
  has_many :discussion_posts

  ##
  # Recupera discussions
  ##
  def self.all_by_allocation_tag_id(allocation_tag_id)

    query = <<SQL
      SELECT t1.id, t1.name, t1.allocation_tag_id, t1.description, t1.schedule_id
        FROM discussions      AS t1
        JOIN allocation_tags  AS t2 ON t2.id = t1.allocation_tag_id
       WHERE t2.id = ?
SQL

    Discussion.find_by_sql([query, allocation_tag_id])
  end

end
