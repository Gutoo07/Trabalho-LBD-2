package fateczl.TrabalhoLabBd2.persistence;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import fateczl.TrabalhoLabBd2.model.PaginaLinkId;
import fateczl.TrabalhoLabBd2.model.Pagina_Link;

@Repository
public interface Pagina_LinkRepository extends JpaRepository<Pagina_Link, PaginaLinkId>{

}
