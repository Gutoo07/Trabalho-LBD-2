package fateczl.TrabalhoLabBd2.persistence;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import fateczl.TrabalhoLabBd2.model.Link;

@Repository
public interface LinkRepository extends JpaRepository<Link, Long>{
	@Query(nativeQuery = true, value = "SELECT dbo.fn_qtd_referencias_link(:linkId)")
	public int getQtdReferenciasDoLink(@Param("linkId") Long linkId);
	
	@Query(value = "SELECT l.* FROM link l " +
            "INNER JOIN pagina_link pl ON pl.link_id = l.id " +
            "WHERE pl.pagina_id = :paginaId", nativeQuery = true)
	public List<Link> findLinksByPaginaId(@Param("paginaId") Long paginaId);

	
}
