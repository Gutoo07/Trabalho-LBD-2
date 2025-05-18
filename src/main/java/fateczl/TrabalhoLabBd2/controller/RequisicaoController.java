package fateczl.TrabalhoLabBd2.controller;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigInteger;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import fateczl.TrabalhoLabBd2.model.Link;
import fateczl.TrabalhoLabBd2.model.Logs;
import fateczl.TrabalhoLabBd2.model.Pagina;
import fateczl.TrabalhoLabBd2.model.PaginaLinkId;
import fateczl.TrabalhoLabBd2.model.Pagina_Link;
import fateczl.TrabalhoLabBd2.model.Requisicao;
import fateczl.TrabalhoLabBd2.model.Sessao;
import fateczl.TrabalhoLabBd2.persistence.LinkRepository;
import fateczl.TrabalhoLabBd2.persistence.LogsRepository;
import fateczl.TrabalhoLabBd2.persistence.PaginaRepository;
import fateczl.TrabalhoLabBd2.persistence.Pagina_LinkRepository;
import fateczl.TrabalhoLabBd2.persistence.RequisicaoRepository;
import fateczl.TrabalhoLabBd2.persistence.SessaoRepository;

@Controller
public class RequisicaoController {
	
	@Autowired
	private RequisicaoRepository requisicaoRep;
	@Autowired
	private PaginaRepository paginaRep;
	@Autowired
	private LinkRepository linkRep;
	@Autowired
	private Pagina_LinkRepository linkPaginaRep;
	@Autowired
	private LogsRepository logsRep;
	@Autowired
	private SessaoRepository sessaoRep;

	

	@PostMapping("/requisicaoPagina")
	public String requisicaoPagina(@RequestParam String url, Model model, @CookieValue(name = "sessao_id", required = false) String sessao_cookie) throws IOException, NoSuchAlgorithmException, InterruptedException {
		
		
		String baseUrl = url.replaceAll("^(https?://[^/]+).*", "$1");
		
		List<Link> link_list = new ArrayList<>();
		boolean hasLink = false;
		try {
			Document doc = Jsoup.connect(url).get();
			Elements links = doc.select("a[href]");
			for (Element link : links) {
			    String href = link.attr("href");
			    String title = link.attr("title");
			    title = (title.isEmpty()) ? link.text() : title;
	
	
			    if (href.startsWith("http")) {
			    	Link link_obj = new Link();
			    	link_obj.setLinkTarget("_blank");
			    	link_obj.setTitulo(title);
			    	link_obj.setUrlDestino(href);
			    	link_list.add(link_obj);
			        //System.out.printf("Link outra Pagina | Title:%s Link:%s\n",title, href);
			    } else if (href.startsWith("/")) {
			    	Link link_obj = new Link();
			    	link_obj.setLinkTarget("_self");
			    	link_obj.setTitulo(title);
			    	link_obj.setUrlDestino(baseUrl+href);
			    	link_list.add(link_obj);
			        //System.out.printf("Link Pagina | Title:%s | Link:%s\n",title, href);
			    } 
			    
			    hasLink = true;
	
			}
		}catch(Exception e) {
            model.addAttribute("erro", "Digite uma Url Válida!");            
			return "requisicao";
		}

		
		
		System.out.println("DEBUG 01");
		 // Criar cliente HTTP
        HttpClient client = HttpClient.newHttpClient();

        // Criar a requisição
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        System.out.println("DEBUG 02");
        // Enviar a requisição e obter a resposta como String
        long inicio = System.nanoTime();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        long fim = System.nanoTime();
        

        // Obter os dados
        float ms = (fim - inicio) / 1_000_000.000f;
        int statusCode = response.statusCode();
        String html = response.body();
        String tipo = response.headers().firstValue("Content-Type").orElse("Desconhecido");
        long tamanho = html.getBytes().length ;
        
        
        //if(tamanho)
        
        
        // Salvar Pagina
        Pagina pagina = new Pagina();
        pagina.setCodigoHtml(html);
        pagina.setPaginaUrl(url);
        pagina.setTamanhoArquivoBytes(tamanho);
        pagina.setTipoConteudo(tipo);
        
        try {
        	paginaRep.save(pagina);
        }catch(Exception e) {
            model.addAttribute("erro", "A Requisição Para o Site passou de 1mb ");            
            return "requisicao";
        }
        
        
        
        Sessao sessao = sessaoRep.getById(Long.parseLong(sessao_cookie));
        sessao.setId(sessao.getId());
        Requisicao requisicao = new Requisicao();
        try {
	        // Salvar Requisicao
	        
	        requisicao = new Requisicao();
	        requisicao.setCodigoHttp(String.valueOf(statusCode));
	        requisicao.setPagina(pagina);
	        requisicao.setSegundos(ms/1000);
	        requisicao.setSessao(sessao);
	        requisicaoRep.save(requisicao);
	        
	        
	        if(hasLink) {
	        	for(Link link : link_list) {
	        		
	         		linkRep.save(link);
	        		
	        		Pagina_Link paginaLink = new Pagina_Link();
	        		
	        		PaginaLinkId paginaLinkId = new PaginaLinkId();
	        		System.out.println("ID01: "+link.getId());
	        		System.out.println("ID02: "+pagina.getId());
	        		paginaLinkId.setLinkId(link.getId());
	        		paginaLinkId.setPaginaId(pagina.getId());
	        		
	        		paginaLink.setPaginaLinkId(paginaLinkId);
	        		
	        		linkPaginaRep.save(paginaLink);
	        	}
	        }
        }catch(Exception e) {
            


            pagina.setTipoConteudo("Passou de 1mb");
            requisicao.setCodigoHttp("404");
            requisicao.setPagina(pagina);
            model.addAttribute("requisicao", requisicao);
            paginaRep.delete(pagina);
            
            return "requisicao";
        }
        
        
        Logs log = new Logs();
        
        log.setSessao(sessao);
        log.setMensagem("["+sessao.getUsuario()+"]"+" : "+sessao.getUsuarioIp()+" >> Acessou : "+pagina.getPaginaUrl());
        

        
        logsRep.save(log);
        
        // Exibir informações
        System.out.println();
        System.out.println("BaseUrl: "+baseUrl);
        System.out.println("Url: " + url);
        System.out.println("Tipo: "+ tipo);
        System.out.println("Resposta Ms: "+ ms + "ms");
        System.out.println("Código de status: " + statusCode);
        System.out.println("Tamanho da página: " + tamanho+" mb");
        //System.out.println("HTML da página:\n" + html);
        requisicao.getPagina().getPaginaUrl();
        requisicao.getPagina().getTipoConteudo();
        model.addAttribute("requisicao", requisicao);
        
		return "requisicao";
	}
}
