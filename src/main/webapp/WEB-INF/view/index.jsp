<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Nova Sessao</title>
	<link rel="stylesheet" href="/resources/css/styles.css">
	<link rel="stylesheet" href="/resources/css/menu.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

</head>
<body>

    <form action="/novaSessao" method="POST">
        <h2>Iniciar Sessão</h2>
		
		<!-- <label>ID da Sessão:</label> <input type="number" name="sessao_id"><br> -->
        <label>Usuário:</label> <input type="text" name="usuario"><br>
        <label>IP:</label> <input type="text" name="usuario_ip"><br>
        <button type="submit">Entrar</button>
    </form>

</body>
</html>