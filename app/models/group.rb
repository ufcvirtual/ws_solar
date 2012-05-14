class Group < ActiveRecord::Base

  def self.all_by_user(user_id)
    query = <<SQL
      WITH cte_all_allocation_tags AS (
        SELECT t2.*
          FROM allocations AS t1
          JOIN allocation_tags AS t2 ON t2.id = t1.allocation_tag_id
          WHERE t1.user_id = ?
            AND status = ?
        ),
        cte_groups AS (
          SELECT *
            FROM cte_all_allocation_tags
           WHERE group_id IS NOT NULL
        ),
        cte_offers AS (
          SELECT *
            FROM cte_all_allocation_tags
           WHERE offer_id IS NOT NULL
        )
        --
        (SELECT t1.id
          FROM groups                   AS t1
          JOIN cte_offers               AS t2 ON t2.offer_id = t1.offer_id)
        UNION
          SELECT group_id FROM cte_groups
SQL

    self.find_by_sql([query, user_id, Allocation_Activated]).map { |group| group.id }
  end

end
