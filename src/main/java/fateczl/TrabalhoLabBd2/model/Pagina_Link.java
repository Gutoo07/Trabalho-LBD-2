package fateczl.TrabalhoLabBd2.model;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "pagina_link")
@Getter
@Setter
public class Pagina_Link {
	@EmbeddedId
	private PaginaLinkId paginaLinkId;	
}