class Group < ActiveRecord::Base

  ##
  # Pesquisa grupos do usuario.
  # Lista somente grupos em que o usuario esta ativo
  ##
  def self.all_by_user(user_id)
    query = <<SQL
        SELECT t1.group_id AS id
          FROM allocation_tags  AS t1
          JOIN allocations      AS t2 ON t2.allocation_tag_id = t1.id
         WHERE t1.group_id IS NOT NULL
           AND t2.user_id = ?
           AND t2.status = ?
SQL

    groups = []
    g = self.find_by_sql([query, user_id, Allocation_Activated])
    g.each {|group| groups << group.id} # array com apenas os ids dos grupos

    return groups
  end

end
