package fateczl.TrabalhoLabBd2.persistence;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import fateczl.TrabalhoLabBd2.model.Logs;

@Repository	
public interface LogsRepository extends JpaRepository<Logs, Long>{
	@Query("SELECT l FROM logs l JOIN l.sessao s WHERE s.usuario_ip =?1")
	public List<Logs> findBySessaoUsuario_ip(String usuario_ip);
}
