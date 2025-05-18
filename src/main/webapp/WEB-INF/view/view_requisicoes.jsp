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

    <h1 style="margin-top: 50px; margin-bottom: 50px;">Requisições</h1>
    <div class="container">
    <h2>Buscar</h2>
    <form action="/buscar-por-usuario" method="get">
        <label for="usuario">Buscar por nome do usuário da sessão:</label>
        <input type="text" id="usuario" name="usuario">
        <button type="submit">Buscar</button>
    </form>

    <form action="/buscar-por-tempo" method="get">
        <label for="tempo">Buscar requisições com tempo menor que (s):</label>
        <input type="number" id="tempo" name="tempo">
        <button type="submit">Buscar</button>
    </form>

    </div>

      <div class="container">
      <h2>Visualizar</h2>
      <table>
          <thead>
          <tr>
              <th>URL</th>
              <th>Status Code</th>
              <th>Tempo (ms)</th>
              <th>Usuario</th>
          </tr>
          </thead>
          <tbody>
          <tr>
              <td>/homeasdasdasdasdasdasdasdasdasd</td>
              <td>200</td>
              <td>120</td>
              <td>text/html</td>
          </tr>
          <tr>
              <td>/login</td>
              <td>401</td>
              <td>87</td>
              <td>application/json</td>
          </tr>
          <tr>
              <td>/api/data</td>
              <td>500</td>
              <td>300</td>
              <td>application/json</td>
          </tr>
          <tr>
              <td>/perfil</td>
              <td>200</td>
              <td>75</td>
              <td>text/html</td>
          </tr>
          <tr>
              <td>/relatorio/download</td>
              <td>404</td>
              <td>52</td>
              <td>application/pdf</td>
          </tr>
          </tbody>
      </table>

    </div>

</body>
</html>
