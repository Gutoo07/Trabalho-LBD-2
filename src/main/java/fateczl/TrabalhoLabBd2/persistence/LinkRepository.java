package fateczl.TrabalhoLabBd2.persistence;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import fateczl.TrabalhoLabBd2.model.Link;

@Repository
public interface LinkRepository extends JpaRepository<Link, Long>{
	@Query(nativeQuery = true, value = "SELECT dbo.fn_qtd_referencias_link(:linkId)")
	public int getQtdReferenciasDoLink(@Param("linkId") Long linkId);
}
