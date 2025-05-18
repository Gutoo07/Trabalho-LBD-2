<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8">
  <title>Detalhes da Página</title>
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
    <h2 style="margin-top:5px;margin-bottom:50px;">Detalhes da Página</h2>

    <div class="info">
      <p><strong>URL:</strong> ${pagina.getPaginaUrl()}</p>
      <p><strong>Content-Type:</strong> ${pagina.getTipoConteudo()}</p>
      <p><strong>Tamanho:</strong> 
		<fmt:formatNumber value="${pagina.getTamanhoArquivoBytes() / 1048576.0}" maxFractionDigits="4" />mb
	</p>
    </div>

    <h2 style="margin-top:25px;margin-bottom:50px;">Links Encontrados</h2>

    <table>
      <thead>
        <tr>
          <th>Titulo</th>
          <th>URL</th>
        </tr>
      </thead>
      <tbody>
		<c:forEach var="link" items="${links}">
	        <tr>			
	          <td>${link.getTitulo()}</td>
	          <td style="word-break: break-all; max-width: 95%;">${link.getUrlDestino()}</td>
	        </tr>
		</c:forEach>
      </tbody>
    </table>
  </div>

</body>
</html>
