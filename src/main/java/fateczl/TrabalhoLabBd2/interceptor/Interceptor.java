package fateczl.TrabalhoLabBd2.interceptor;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;

import fateczl.TrabalhoLabBd2.controller.RequisicaoController;

import org.springframework.ui.Model;

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

		if (request.getMethod().equals("GET")) {
			Cookie[] cookies = request.getCookies();
			if (cookies != null) {
				for (Cookie c : cookies) {
					if (c.getName().equals("sessao_id")) {
						String url = request.getRequestURL().toString();
						requisicaoController.requisicaoPagina(url, mv.getModelMap(), c.getValue());
					}
				}
			}
		}
	}

}
