<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Nova Pagina</title>
	<link rel="stylesheet" href="/resources/css/styles.css">
	<link rel="stylesheet" href="/resources/css/menu.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
	<div align="center">
		<h2>Upload de Nova Página</h2>
		<form action="/uploadPagina" method="post" enctype="multipart/form-data">
            <label for="pagina" style="font-weight: bold;">URL da página:</label><br>
			<input type="text" id="pagina_url" name="pagina_url">
            <label for="pagina" style="font-weight: bold;">Selecionar arquivos:</label><br>
			<input type="file" id="pagina" name="pagina">
			<button type="submit" style="background-color: #2c974b; color: white; padding: 10px 20px; border: none; border-radius: 6px; cursor: pointer;">
            	Fazer Upload e Iniciar Teste
            </button>
		</form>
	</div>
</body>
</html>