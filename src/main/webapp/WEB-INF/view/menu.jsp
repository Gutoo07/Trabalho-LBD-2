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

    <div style="background-color: rgb(32, 55, 156); padding: 15px; border-radius: 8px; max-width: 100%;">
        <nav style="display: flex; justify-content: space-around; flex-wrap: wrap;">
            <a href="/" style="color: white; text-decoration: none; font-weight: bold;">Nova Sessão</a>
            <a href="/requisicao" style="color: white; text-decoration: none; font-weight: bold;">Nova Requisição</a>
            <a href="/paginas" style="color: white; text-decoration: none; font-weight: bold;">Pagina</a>
            <a href="/sessoes" style="color: white; text-decoration: none; font-weight: bold;">Sessões</a>
            <a href="/requisicoes" style="color: white; text-decoration: none; font-weight: bold;">Requisições</a>
			<a href="/logs" style="color: white; text-decoration: none; font-weight: bold;">Logs</a>
            
        </nav>
    </div>

</body>
</html>
