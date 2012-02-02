class Profile < ActiveRecord::Base

	##
	# Recupera apenas um unico perfil de usuario
	# Obs.: Como é para uma aplicação mais voltada para interação de alunos, a busca
	# prioriza o perfil de usuario aluno do usuario. Caso ele nao tenha esse perfil,
	# o primeiro listado é recuperado
	##
	def self.find_by_user_id(user_id)
		query = <<SQL
			SELECT DISTINCT t1.id, t1.name, t1.types, cast(t1.types & #{Profile_Type_Student} as boolean) AS type
			  FROM profiles        AS t1
			  JOIN allocations     AS t2 ON t2.profile_id = t1.id
			  JOIN allocation_tags AS t3 ON t3.id = t2.allocation_tag_id
			 WHERE t2.user_id = ?
			 ORDER BY type DESC, t1.types DESC
			 LIMIT 1;
SQL
		profile = Profile.find_by_sql([query, user_id])
		return profile.blank? ? nil : profile.first.id
	end

end
