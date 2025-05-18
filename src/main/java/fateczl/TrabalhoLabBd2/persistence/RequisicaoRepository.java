package fateczl.TrabalhoLabBd2.persistence;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import fateczl.TrabalhoLabBd2.model.Requisicao;
import fateczl.TrabalhoLabBd2.model.Sessao;

@Repository
public interface RequisicaoRepository extends JpaRepository<Requisicao, Long>{
	@Query("SELECT r FROM Requisicao r WHERE r.segundos <?1")
	public List<Requisicao> findByTempoMenorQue(Float segundos);
	@Query("SELECT r FROM Requisicao r JOIN r.sessao s WHERE s.usuario =?1")
	public List<Requisicao> findBySessaoUsuarioIp(String usuario);
	public List<Requisicao> findBySessao(Sessao sessao);
}
