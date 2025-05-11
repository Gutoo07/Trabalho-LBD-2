package fateczl.TrabalhoLabBd2.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "pagina")
@Getter
@Setter
public class Pagina {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;
	@Column(name = "codigo_html", columnDefinition = "NVARCHAR(MAX)", nullable = false)
	private String codigo_html;
	@Column(name = "tipo_conteudo", length = 30, nullable = false)
	private String tipo_conteudo;
	@Column(name = "pagina_url", length = 500, nullable = false)
	private String pagina_url;
	@Column(name = "tamanho_arquivo_bytes", nullable = false)
	private int tamanho_arquivo_bytes;
}