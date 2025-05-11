package fateczl.TrabalhoLabBd2.model;

import jakarta.persistence.Embeddable;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Embeddable
@Getter
@Setter
@EqualsAndHashCode
public class PaginaLinkId {
	private Long pagina_id;
	private Long link_id;
}
