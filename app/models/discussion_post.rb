class DiscussionPost < ActiveRecord::Base

  belongs_to :discussion

  ##
  # Todos os posts relacionados a discussion passada
  # As informações do usuário também são retornadas
  ##
  def self.find_all_by_discussion_id(discussion_id)
    query = <<SQL
        SELECT t3.name AS user_name, t3.username AS user_username,
               t1.discussion_id, t1.id, t1.content, t1.profile_id, to_char(t1.updated_at::timestamp, 'YYYYMMDDHHMISS') AS updated, t1.parent_id
          FROM discussion_posts AS t1
          JOIN discussions      AS t2 ON t2.id = t1.discussion_id
          JOIN users            AS t3 ON t3.id = t1.user_id
         WHERE t2.id = ?
         ORDER BY t1.updated_at DESC
SQL

    DiscussionPost.find_by_sql([query, discussion_id])
  end

end
