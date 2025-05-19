package fateczl.TrabalhoLabBd2.interceptor;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.Enumeration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import fateczl.TrabalhoLabBd2.controller.RequisicaoController;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class Interceptor implements HandlerInterceptor {
	@Autowired
	private RequisicaoController requisicaoController;
	
	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response,
			Object handler, ModelAndView mv) throws NoSuchAlgorithmException, IOException, InterruptedException {
		if (mv != null) {
			if (request.getMethod().equals("GET")) {
				Cookie[] cookies = request.getCookies();
				if (cookies != null) {
					for (Cookie c : cookies) {
						if (c.getName().equals("sessao_id")) {
							String url = request.getRequestURL().toString();
							String method = request.getMethod();
							if (method.equals("GET")) {
								requisicaoController.requisicaoPagina(url, method, mv.getModelMap(), c.getValue());
							} else if (method.equals("POST")) {
								requisicaoController.requisicaoPagina(url, method, mv.getModelMap(), c.getValue());
							}
						}
					}
				}
			}
		}
	}

}
