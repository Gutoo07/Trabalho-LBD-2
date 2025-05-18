package fateczl.TrabalhoLabBd2.persistence;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import fateczl.TrabalhoLabBd2.model.Pagina;

@Repository
public interface PaginaRepository extends JpaRepository<Pagina, Long> {

    List<Pagina> findByPaginaUrl(String paginaUrl);

    List<Pagina> findByTamanhoArquivoBytes(Long tamanhoArquivoBytes);

    /*@Query("SELECT p FROM Pagina p WHERE p.tamanhoArquivoBytes < ?1")
    List<Pagina> findByTamanhoMenorQue(Long tamanhoArquivoBytes);*/
    
    List<Pagina> findByTamanhoArquivoBytesLessThan(Long tamanho);

    
    @Query("SELECT p FROM Pagina p " +
    	       "JOIN Pagina_Link pl ON p.id = pl.paginaLinkId.paginaId " +
    	       "JOIN Link l ON pl.paginaLinkId.linkId = l.id " +
    	       "WHERE l.urlDestino = :urlDestino")
	List<Pagina> findPaginasByLinkUrlDestino(@Param("urlDestino") String urlDestino);

}



