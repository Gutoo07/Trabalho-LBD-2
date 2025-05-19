package fateczl.TrabalhoLabBd2.controller;

import java.sql.SQLException;
import java.util.Map;

import org.hibernate.HibernateException;
import org.hibernate.JDBCException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import fateczl.TrabalhoLabBd2.model.Sessao;
import fateczl.TrabalhoLabBd2.persistence.SessaoRepository;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Cookie;


@Controller
public class SessaoController {
	
	@Autowired
	private SessaoRepository sessaoRep;
	
	@PostMapping("/novaSessao")
	public String novaSessao (@RequestParam Map<String, String> params, ModelMap model, HttpServletResponse response,
			@CookieValue(value = "sessao", defaultValue = "") Long sessaoId) {
		Long sessaoIdStr = 0L;
		String usuario = params.get("usuario");
		String usuario_ip = params.get("usuario_ip");
		String erro = "";
		Sessao sessao = new Sessao();
		sessao.setUsuario(usuario);
		sessao.setUsuarioIp(usuario_ip);
		try {
			sessaoRep.save(sessao);
		} catch (JDBCException  e) {
			erro = e.getMessage();
		} finally {
			model.addAttribute("erro", erro);
		}
		sessaoIdStr = sessao.getId();
		Cookie cookie_sessao_id = new Cookie("sessao_id", String.valueOf(sessaoIdStr));
		cookie_sessao_id.setMaxAge(3600);
		response.addCookie(cookie_sessao_id);
		return "requisicao";
	}
}
