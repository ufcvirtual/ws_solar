class Discussion < ActiveRecord::Base
  has_many :discussion_posts
  belongs_to :schedules

  def self.all_by_allocation_tag_id(allocation_tag_id)
    query = <<SQL
      SELECT t1.id,
             CASE WHEN t3.end_date < now() THEN t1.name || ' (fechado)' ELSE t1.name END AS name,
             t1.allocation_tag_id,
             t1.description,
             CASE WHEN t3.end_date < now() THEN true ELSE false END     AS closed,
             max(to_char(t4.updated_at::timestamp, 'YYYYMMDDHH24MISS')) AS last_post_date
        FROM discussions      AS t1
        JOIN allocation_tags  AS t2 ON t2.id = t1.allocation_tag_id
        JOIN schedules        AS t3 ON t3.id = t1.schedule_id
   LEFT JOIN discussion_posts AS t4 ON t4.discussion_id = t1.id
       WHERE t2.id = ?
       GROUP BY t1.id, t3.end_date, t1.name, t1.allocation_tag_id, t1.description, t1.schedule_id
       ORDER BY closed, last_post_date DESC
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
