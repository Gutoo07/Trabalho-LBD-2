package fateczl.TrabalhoLabBd2.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import fateczl.TrabalhoLabBd2.model.Pagina;
import fateczl.TrabalhoLabBd2.persistence.PaginaRepository;

@Controller
public class MappingPages {
	
	@Autowired
	private PaginaRepository repPagina;
	
	@GetMapping("/")
	public String home(Model model) throws ClassNotFoundException, SQLException {
		return "index";
	}
	
	@GetMapping("/requisicao")
	public String requisicao(Model model) throws ClassNotFoundException, SQLException {
		return "requisicao";
	}
	
	@GetMapping("/logs")
	public String logs(Model model) throws ClassNotFoundException, SQLException {
	
		return "view_logs";
	}
	
	@GetMapping("/sessoes")
	public String sessoes(Model model) throws ClassNotFoundException, SQLException {
		return "view_sessoes";
	}
	
	@GetMapping("/requisicoes")
	public String requisicoes(Model model) throws ClassNotFoundException, SQLException {
		return "view_requisicoes";
	}
	
	@GetMapping("/paginas")
	public String paginas(Model model, @RequestParam(required = false) String url, @RequestParam(required = false) String link, @RequestParam(required = false) String size) throws ClassNotFoundException, SQLException {
		
		List<Pagina> list_pagina = new ArrayList<>();
		if(url != null && !url.isEmpty()) {
			System.out.println("UEPA");
			list_pagina = repPagina.findByPaginaUrl(url);
			model.addAttribute("paginas", list_pagina);
			return "view_paginas";
		}else if(size != null && !size.isEmpty()) {
			System.out.println("size: "+size);
			list_pagina = repPagina.findByTamanhoArquivoBytesLessThan((long) (Double.parseDouble(size) * 1048576.0));
			model.addAttribute("paginas", list_pagina);
			return "view_paginas";
		}else if(link != null && !link.isEmpty()) {
			list_pagina = repPagina.findPaginasByLinkUrlDestino(link);
			model.addAttribute("paginas", list_pagina);
			return "view_paginas";
		}
		
		list_pagina = repPagina.findAll();
		model.addAttribute("paginas", list_pagina);

		return "view_paginas";
	}
}
