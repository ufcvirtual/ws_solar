class CurriculumUnit < ActiveRecord::Base

  has_one :allocation_tag

  def self.find_default_by_user_id(user_id)
    query = <<SQL
    WITH cte_all_by_user AS (
        SELECT DISTINCT t2.id AS allocation_tag_id, t2.group_id, t2.offer_id, t2.curriculum_unit_id, t2.course_id
          FROM allocations      AS t1
          JOIN allocation_tags  AS t2 ON t2.id = t1.allocation_tag_id
         WHERE t1.status = 1
           AND t1.user_id = #{user_id}
    )
    --
    SELECT DISTINCT ON (name, id) * FROM (
        SELECT id, name, code FROM (
            (
                SELECT t2.*, NULL AS offer_id, NULL::integer AS group_id, NULL::varchar AS semester, t1.allocation_tag_id --usuarios vinculados direto a unidade curricular
                  FROM cte_all_by_user  AS t1
                  JOIN curriculum_units AS t2 ON t2.id = t1.curriculum_unit_id
            )
              UNION
            (
                SELECT t3.*, t2.id AS offer_id, NULL::integer AS group_id, semester, t1.allocation_tag_id --usuarios vinculados a oferta
                  FROM cte_all_by_user  AS t1
                  JOIN offers           AS t2 ON t2.id = t1.offer_id
                  JOIN curriculum_units AS t3 ON t3.id = t2.curriculum_unit_id
            )
              UNION
            (
                SELECT t4.*, t3.id AS offer_id, t2.id AS group_id, semester, t1.allocation_tag_id -- usuarios vinculados a turma
                  FROM cte_all_by_user  AS t1
                  JOIN groups           AS t2 ON t2.id = t1.group_id
                  JOIN offers           AS t3 ON t3.id = t2.offer_id
                  JOIN curriculum_units AS t4 ON t4.id = t3.curriculum_unit_id
            )
              UNION
            (
                select t4.*, t3.id AS offer_id, NULL::integer AS group_id, semester, t1.allocation_tag_id --usuarios vinculados a graduacao
                  FROM cte_all_by_user  AS t1
                  JOIN courses          AS t2 ON t2.id = t1.course_id
                  JOIN offers           AS t3 ON t3.course_id = t2.id
                  JOIN curriculum_units AS t4 ON t4.id = t3.curriculum_unit_id
            )
        ) AS curriculum_units ORDER BY name, semester DESC, id
    ) AS curriculum_units_with_allocations;
SQL

    ActiveRecord::Base.connection.select_all query
  end


end
