package fateczl.TrabalhoLabBd2.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import fateczl.TrabalhoLabBd2.persistence.PaginaRepository;

@Controller
public class PaginaController {
	@Autowired
	private PaginaRepository paginaRep;
	
	@PostMapping("/uploadPagina")
	public void uploadPagina(@RequestParam("pagina") MultipartFile pagina,
			@CookieValue(name="sessao_id", defaultValue="") String sessaoIdStr) {
		System.out.println("Fazendo upload de pagina para sessao #"+sessaoIdStr);
		Long tamanhoPagina = pagina.getSize();
		System.out.println("Tamanho da Pagina: "+tamanhoPagina+ " bytes.");
	}
}
