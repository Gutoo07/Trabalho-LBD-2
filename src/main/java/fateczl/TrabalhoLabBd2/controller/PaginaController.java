package fateczl.TrabalhoLabBd2.controller;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import fateczl.TrabalhoLabBd2.model.Pagina;
import fateczl.TrabalhoLabBd2.persistence.PaginaRepository;

@Controller
public class PaginaController {
	@Autowired
	private PaginaRepository paginaRep;
	
	@PostMapping("/uploadPagina")
	public void uploadPagina(@RequestParam("pagina") MultipartFile arquivo,
			@RequestParam("pagina_url") String paginaUrl,
			@CookieValue(name="sessao_id", defaultValue="") String sessaoIdStr) throws IOException, NoSuchAlgorithmException {
		
		System.out.println("Fazendo upload de pagina para sessao #"+sessaoIdStr);
		
		Long tamanhoPagina = arquivo.getSize();
		
		System.out.println("Tamanho da Pagina: "+tamanhoPagina+ " bytes.");
		if (tamanhoPagina > 1000000) {
			System.out.println("A pagina eh maior que 1MB: vai dar erro! ;)");
		}
		
		byte[] conteudoEmBytes = arquivo.getBytes();
		MessageDigest md = MessageDigest.getInstance("SHA1");
		byte[] sha1bytes = md.digest(conteudoEmBytes);
		BigInteger bigInt = new BigInteger(1, sha1bytes);
		String sha1 = bigInt.toString(16);
		
		Pagina pagina = new Pagina();
		InputStream is = arquivo.getInputStream();
		String codigoHtml = new String(is.readAllBytes(), StandardCharsets.UTF_8);
		pagina.setCodigo_html(codigoHtml);
		pagina.setPagina_url(paginaUrl);
		pagina.setSha1(sha1);
		pagina.setTamanho_arquivo_bytes(tamanhoPagina);
		pagina.setTipo_conteudo(arquivo.getContentType());
		paginaRep.save(pagina);
	}
}
