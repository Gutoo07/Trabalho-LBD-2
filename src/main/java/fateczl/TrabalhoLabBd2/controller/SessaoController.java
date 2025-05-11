package fateczl.TrabalhoLabBd2.controller;

import java.sql.SQLException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import fateczl.TrabalhoLabBd2.model.Sessao;
import fateczl.TrabalhoLabBd2.persistence.SessaoRepository;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class SessaoController {
	
	@Autowired
	private SessaoRepository sessaoRep;
	
	@PostMapping("/novaSessao")
	public void novaSessao (@RequestParam Map<String, String> params, ModelMap model, HttpServletResponse response,
			@CookieValue(value = "sessao", defaultValue = "") Long sessaoId) 
			throws ClassNotFoundException, SQLException {
		String sessaoIdStr = params.get("sessao_id");
		String usuario = params.get("usuario");
		String usuario_ip = params.get("usuario_ip");
		
		if (!sessaoRep.findById(Long.valueOf(sessaoIdStr)).isPresent()) {
			Sessao sessao = new Sessao();
			sessao.setId(Long.valueOf(sessaoIdStr));
			sessao.setUsuario(usuario);
			sessao.setUsuario_ip(usuario_ip);
			sessaoRep.save(sessao);
		}
		
	}
}
