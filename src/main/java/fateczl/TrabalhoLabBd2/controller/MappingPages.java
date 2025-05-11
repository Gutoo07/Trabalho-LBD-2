package fateczl.TrabalhoLabBd2.controller;

import java.sql.SQLException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MappingPages {
	@GetMapping("/")
	public String home(Model model) throws ClassNotFoundException, SQLException {
		return "index";
	}
}
