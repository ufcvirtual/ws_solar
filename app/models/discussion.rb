class Discussion < ActiveRecord::Base
  has_many :discussion_posts
  belongs_to :schedules

  ##
  # Recupera discussions
  ##
  def self.all_by_allocation_tag_id(allocation_tag_id)
    query = <<SQL
      SELECT t1.id,
        CASE WHEN t3.end_date < now() THEN t1.name ELSE t1.name || ' (fechado)' END AS name,
             t1.allocation_tag_id, t1.description, t1.schedule_id, CASE WHEN t3.end_date < now() THEN false ELSE true END AS closed
        FROM discussions      AS t1
        JOIN allocation_tags  AS t2 ON t2.id = t1.allocation_tag_id
        JOIN schedules        AS t3 ON t3.id = t1.schedule_id
       WHERE t2.id = ?
SQL

    Discussion.find_by_sql([query, allocation_tag_id])
  end

  ##
  # Retorna TRUE se esta discussion se encontra fechada
  ##
  def closed?
    Schedule.find(self.schedule_id).end_date.to_time < Time.now.to_time
  end

end
