package fateczl.TrabalhoLabBd2.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

import fateczl.TrabalhoLabBd2.persistence.PaginaRepository;

@Controller
public class PaginaController {
	@Autowired
	private PaginaRepository paginaRep;
	
	@PostMapping("/uploadPagina")
	public void uploadPagina() {
		System.out.println("Fazendo upload de pagina");
	}
}
