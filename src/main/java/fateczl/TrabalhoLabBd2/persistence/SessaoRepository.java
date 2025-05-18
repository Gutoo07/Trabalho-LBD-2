package fateczl.TrabalhoLabBd2.persistence;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import fateczl.TrabalhoLabBd2.model.Sessao;

@Repository
public interface SessaoRepository extends JpaRepository<Sessao, Long>{
	public List<Sessao> findByUsuarioIp(String usuario_ip);
}
