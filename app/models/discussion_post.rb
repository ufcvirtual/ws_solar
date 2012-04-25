class DiscussionPost < ActiveRecord::Base
  belongs_to :discussion
  before_save :verify_discussion_closed

  def verify_discussion_closed
    not Discussion.find(self.discussion_id).closed? # FALSE para nao cadastrar
  end

  def self.find_all_by_discussion_id(discussion_id)
    query = <<SQL
        SELECT t3.id AS user_id,
               t1.id,
               t1.parent_id,
               t1.profile_id,
               t1.discussion_id,
               t3.id        AS user_id,
               t3.username  AS user_nick,
               t1.content,
               to_char(t1.updated_at::timestamp, 'YYYYMMDDHH24MISS') AS updated
          FROM discussion_posts AS t1
          JOIN discussions      AS t2 ON t2.id = t1.discussion_id
          JOIN users            AS t3 ON t3.id = t1.user_id
         WHERE t2.id = ?
         ORDER BY t1.updated_at DESC
SQL

    DiscussionPost.find_by_sql([query, discussion_id])
  end

end
