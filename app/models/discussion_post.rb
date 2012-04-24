class DiscussionPost < ActiveRecord::Base
  belongs_to :discussion
  before_save :verify_discussion_closed

  def verify_discussion_closed
    not Discussion.find(self.discussion_id).closed? # FALSE para nao cadastrar
  end

  ##
  # Todos os posts relacionados a discussion passada
  # As informações do usuário também são retornadas
  ##
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

  def self.news(opts = {})
    posts_by_discussion_id_and_date({ :type => 'news' }.merge(opts))
  end

  def self.history(opts = {})
    posts_by_discussion_id_and_date({ :type => 'history' }.merge(opts))
  end

  ##
  # type = [news, history]
  # order = [desc, asc]
  # limit = 20
  ##
  def self.posts_by_discussion_id_and_date(opts = {})
    opts = { :type => 'news', :order => 'desc', :limit => 20 }.merge(opts)
    type = (opts[:type] == 'news') ? '>' : '<'

    query = <<SQL
        SELECT t1.id,
               t1.parent_id,
               t1.profile_id,
               t1.discussion_id,
               t3.id                          AS user_id,
               t3.nick                        AS user_nick,
               t1.content                     AS content_first,
               NULL                           AS content_last,
               to_char(t1.updated_at::timestamp, 'YYYYMMDDHH24MISS') AS updated
          FROM discussion_posts AS t1
          JOIN discussions      AS t2 ON t2.id = t1.discussion_id
          JOIN users            AS t3 ON t3.id = t1.user_id
         WHERE t2.id = #{opts[:discussion_id]}
           AND t1.updated_at::timestamp #{type} '#{opts[:date]}'::timestamp
         ORDER BY t1.updated_at #{opts[:order]}, t1.id #{opts[:order]}
         LIMIT #{opts[:limit]}
SQL

    ActiveRecord::Base.connection.select_all query
  end
end
