package fateczl.TrabalhoLabBd2.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import fateczl.TrabalhoLabBd2.model.Link;
import fateczl.TrabalhoLabBd2.model.Logs;
import fateczl.TrabalhoLabBd2.model.Pagina;
import fateczl.TrabalhoLabBd2.model.Requisicao;
import fateczl.TrabalhoLabBd2.model.Sessao;
import fateczl.TrabalhoLabBd2.persistence.LinkRepository;
import fateczl.TrabalhoLabBd2.persistence.LogsRepository;
import fateczl.TrabalhoLabBd2.persistence.PaginaRepository;
import fateczl.TrabalhoLabBd2.persistence.RequisicaoRepository;
import fateczl.TrabalhoLabBd2.persistence.SessaoRepository;

@Controller
public class MappingPages {
	
	@Autowired
	private PaginaRepository repPagina;
	
	@Autowired
	private SessaoRepository repSessao;
	
	@Autowired
	private RequisicaoRepository repRequisicao;
	
	@Autowired
	private LogsRepository repLogs;
	
	@Autowired
	private LinkRepository repLink;
	
	@GetMapping("/")
	public String home(Model model) throws ClassNotFoundException, SQLException {
		return "index";
	}
	
	@GetMapping("/requisicao")
	public String requisicao(Model model) throws ClassNotFoundException, SQLException {
		return "requisicao";
	}
	
	@GetMapping("/logs")
	public String logs(Model model, @RequestParam Map<String, String> params) throws ClassNotFoundException, SQLException {
		List<Logs> list_logs = new ArrayList<>();
		String ip = params.get("ip");
		String acao = params.get("acao");
		
		if(ip != null && !ip.isEmpty()) {
			list_logs = repLogs.findBySessaoUsuarioIp(ip);
			model.addAttribute("logs",list_logs);
			return "view_logs";
		}else if (acao != null && !acao.isEmpty()) {
			String logId = params.get("id");
			if (logId != null && !logId.isEmpty()) {
				Optional<Logs> log = repLogs.findById(Long.valueOf(logId));
				if (log.isPresent()) {
					repLogs.delete(log.get());
				}
			}
		}		
		
		list_logs = repLogs.findAll();
		Logs logs = new Logs();		
		
		model.addAttribute("logs",list_logs);
		return "view_logs";
	}
	
	@GetMapping("/sessoes")
	public String sessoes(Model model, @RequestParam Map<String, String> params) throws ClassNotFoundException, SQLException {
		String ip = params.get("ip");
		String acao = params.get("acao");
		List<Sessao> list_sessao = new ArrayList<>();
		
		if(ip != null && !ip.isEmpty()) {
			list_sessao = repSessao.findByUsuarioIp(ip);
			model.addAttribute("sessoes",list_sessao);
			return "view_sessoes";
		}else if (acao != null && !acao.isEmpty()) {
			String sessaoId = params.get("id");
			if (sessaoId != null && !sessaoId.isEmpty()) {
				Optional<Sessao> sessao = repSessao.findById(Long.valueOf(sessaoId));
				if (sessao.isPresent()) {
					List<Logs> logs = repLogs.findBySessao(sessao.get());
					for (Logs l : logs) {
						repLogs.delete(l);
					}
					List<Requisicao> requisicoes = repRequisicao.findBySessao(sessao.get());
					for (Requisicao r : requisicoes) {
						repRequisicao.delete(r);
					}
					repSessao.delete(sessao.get());
				}
			}
		}
		
		
		
		list_sessao = repSessao.findAll();
		Sessao sessao = new Sessao();
		
		model.addAttribute("sessoes",list_sessao);
		
		return "view_sessoes";
	}
	
	@GetMapping("/requisicoes")
	public String requisicoes(Model model, @RequestParam Map<String, String> params) throws ClassNotFoundException, SQLException {
		List<Requisicao> list_requisicao = new ArrayList<>();
		String nome = params.get("nome");
		String tempo = params.get("tempo");
		String acao = params.get("acao");
		if(nome != null && !nome.isEmpty()) {
			list_requisicao = repRequisicao.findBySessaoUsuarioIp(nome);
			model.addAttribute("requisicoes",list_requisicao);
			return "view_requisicoes";
		}else if(tempo != null && !tempo.isEmpty()) {
			list_requisicao = repRequisicao.findByTempoMenorQue(Float.parseFloat(tempo));
			model.addAttribute("requisicoes",list_requisicao);
			return "view_requisicoes";
		}else if(acao != null && !acao.isEmpty()) {
			String requisicaoId = params.get("id");
			if (requisicaoId != null && !requisicaoId.isEmpty()) {
				Optional<Requisicao> requisicao = repRequisicao.findById(Long.valueOf(requisicaoId));
				if (requisicao.isPresent()) {
					repRequisicao.delete(requisicao.get());
				}
			}
		}		
		
		list_requisicao = repRequisicao.findAll();
		model.addAttribute("requisicoes",list_requisicao);
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
	
	@GetMapping("/page_detail")
	public String page_detail(Model model, @RequestParam(required = false) String pageId) throws ClassNotFoundException, SQLException {
		
		if(pageId != null && !pageId.isEmpty()) {
			Optional<Pagina> pagina = repPagina.findById(Long.parseLong(pageId));
			List<Link> list_link = repLink.findLinksByPaginaId(Long.parseLong(pageId));	
			model.addAttribute("pagina", pagina.get());
			model.addAttribute("links", list_link);
			return "page_detail";
		}
		return "page_detail";
	}
}
