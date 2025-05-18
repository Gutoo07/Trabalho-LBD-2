<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8">
  <title>Visualizar Páginas</title>
   <style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
      font-family: Arial, sans-serif;
      background-color: #f2f2f2;
    }
    .container {
    
      max-width: 900px;
      margin: auto;
      margin-top: 25px;
      margin-bottom: 50px;
      background-color: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h1, h2 {
      text-align: center;
      color: #333;
    }
    form {
      margin-bottom: 20px;
    }
    label {
      display: block;
      margin-top: 10px;
      color: #333;
    }
    input[type="text"],
    input[type="number"],
    button {
      width: 100%;
      padding: 10px;
      margin-top: 5px;
      box-sizing: border-box;
      border-radius: 4px;
      border: 1px solid #ccc;
    }
    button {
      background-color: #2865e9;
      color: white;
      border: none;
      cursor: pointer;
    }
    button:hover {
      background-color: #2865e9;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 30px;
    }
    th, td {
      padding: 10px;
      border-bottom: 1px solid #ddd;
      text-align: left;
    }
    th {
      background-color: #2865e9;
      color: white;
    }
    tr:hover {
      background-color: #f5f5f5;
    }
  </style>
</head>
<body>

	<jsp:include page="menu.jsp" />

    <div class="container">
	    <h1>Enviar Requisição</h1>
	    <form action="/requisicaoPagina" method="post">
	      <label for="url">Digite a URL:</label>
	      <input type="text" id="url" name="url" placeholder="https://exemplo.com">
	      <button type="submit">Enviar</button>
	    </form>
  	</div>
  
	<c:if test="${not empty requisicao}">
		<div class="container">
		  <h2>Detalhes</h2>
		  <span>Url: ${requisicao.getPagina().getPaginaUrl()}<span><br>
		  <span>Content-Type: ${requisicao.getPagina().getTipoConteudo()}<span><br>
		  <span>Status Code: ${requisicao.getCodigoHttp()}<span><br>
		  <span>Time: ${requisicao.getSegundos()}s<span><br>
		</div>
	</c:if>
	<c:if test="${not empty erro}">
		<div class="container" style="display:flex;flex-direction:column; align-items:center;">
		  <h2>Detalhes</h2>
		  <span style="color:red; margin-bottom:25px;margin-top:25px;">${erro}<span><br>
		</div>
	</c:if>
	
	<c:forEach var="pagina" items="${paginas}"> 
		<span>teste</span>
	</c:forEach>
  
</body>
</html>
