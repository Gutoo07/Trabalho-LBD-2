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
@Table(name = "sessao")
@Getter
@Setter
public class Sessao {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;
	@Column(name = "usuario", length = 30, nullable = false)
	private String usuario;
	@Column(name = "usuario_ip", length = 20, nullable = false)
	private String usuario_ip;
}
