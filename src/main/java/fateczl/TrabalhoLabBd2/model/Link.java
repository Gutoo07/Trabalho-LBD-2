package fateczl.TrabalhoLabBd2.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "link")
@Getter
@Setter
public class Link {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;
	@Column(name = "url_destino", length = 500, nullable = false)
	private String url_destino;
	@Column(name = "titulo", length = 100, nullable = true)
	private String titulo;
	@Column(name = "link_target", length = 7, nullable = false)
	private String link_target;
}