package fateczl.TrabalhoLabBd2.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "logs")
@Getter
@Setter
public class Logs {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;
	@Column(name = "mensagem", length = 200, nullable = false)
	private String mensagem;
	
	@ManyToOne(targetEntity = Sessao.class, fetch = FetchType.LAZY)
	@JoinColumn(name = "sessao_id", nullable = false)
	private Sessao sessao;
}