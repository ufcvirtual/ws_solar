class DiscussionPost < ActiveRecord::Base
  belongs_to :discussion
  before_save :verify_discussion_closed

  ##
  # Verifica se a discussion em que se deseja postar já está encerrada
  ##
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
               t3.name                        AS user_name,
               t3.username                    AS user_username,
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

  ##
  # Recupera novos posts
  ##
  def self.find_news_by_discussion_id(discussion_id, date_last)
    posts_by_discussion_id_and_date(discussion_id, date_last, 'news')
  end

  ##
  # Recupera historico de posts
  ##
  def self.find_history_by_discussion_id(discussion_id, date_last)
    posts_by_discussion_id_and_date(discussion_id, date_last, 'history')
  end

  # Params: type = [news, history]
  def self.posts_by_discussion_id_and_date(discussion_id, date_post, type = 'news')
    operation = '>' if type == 'news'
    operation = '<' if type == 'history'

    query = <<SQL
        SELECT t1.id,
               t1.parent_id,
               t1.profile_id,
               t1.discussion_id,
               t3.id                          AS user_id,
               t3.name                        AS user_name,
               t3.username                    AS user_username,
               t1.content                     AS content_first,
               NULL                           AS content_last,
               to_char(t1.updated_at::timestamp, 'YYYYMMDDHH24MISS') AS updated
          FROM discussion_posts AS t1
          JOIN discussions      AS t2 ON t2.id = t1.discussion_id
          JOIN users            AS t3 ON t3.id = t1.user_id
         WHERE t2.id = ?
           AND t1.updated_at::timestamp #{operation} '#{date_post}'::timestamp
         ORDER BY t1.updated_at DESC, t1.id DESC
         LIMIT 20
SQL

    DiscussionPost.find_by_sql([query, discussion_id])
  end
end
