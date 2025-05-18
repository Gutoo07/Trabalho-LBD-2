package fateczl.TrabalhoLabBd2.persistence;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import fateczl.TrabalhoLabBd2.model.Logs;
import fateczl.TrabalhoLabBd2.model.Sessao;

@Repository	
public interface LogsRepository extends JpaRepository<Logs, Long>{
	@Query("SELECT l FROM Logs l JOIN l.sessao s WHERE s.usuarioIp =?1")
	public List<Logs> findBySessaoUsuarioIp(String usuario_ip);
	public List<Logs> findBySessao(Sessao sessao);
}
