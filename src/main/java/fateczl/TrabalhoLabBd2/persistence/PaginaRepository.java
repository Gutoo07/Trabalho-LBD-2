package fateczl.TrabalhoLabBd2.persistence;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import fateczl.TrabalhoLabBd2.model.Pagina;

@Repository
public interface PaginaRepository extends JpaRepository<Pagina, Long>{
	public List<Pagina> findByPagina_url(String pagina_url);
	public List<Pagina> findByTamanho_arquivo_bytes(Long tamanho_arquivo_bytes);
	@Query("SELECT p FROM pagina p WHERE p.tamanho_arquivo_bytes <?1")
	public List<Pagina> findByTamanhoMenorQue(Long tamanho_arquivo_bytes);
	
}
