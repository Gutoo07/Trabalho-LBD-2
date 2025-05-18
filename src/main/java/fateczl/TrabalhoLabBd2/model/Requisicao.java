package fateczl.TrabalhoLabBd2.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "requisicao")
@Getter
@Setter
public class Requisicao {
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Column(name = "id", nullable = false)
	private Long id;
	@Column(name = "codigo_http", length = 200, nullable = false)
	private String codigoHttp;
	@Column(name = "segundos", nullable = false)
	private float segundos;
	
	@ManyToOne(targetEntity = Sessao.class, fetch = FetchType.LAZY)
	@JoinColumn(name = "sessao_id", nullable = false)
	private Sessao sessao;
	@ManyToOne(targetEntity = Pagina.class, fetch = FetchType.LAZY)
	@JoinColumn(name = "pagina_id", nullable = false)
	private Pagina pagina;
}