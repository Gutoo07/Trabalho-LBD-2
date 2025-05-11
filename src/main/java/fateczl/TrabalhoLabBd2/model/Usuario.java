package fateczl.TrabalhoLabBd2.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "usuario")
@Getter
@Setter
public class Usuario {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;
	@Column(name = "usuario_ip", length = 20, nullable = false)
	private String usuario_ip;
	@Column(name = "nome", length = 30, nullable = false)
	private String nome;
}