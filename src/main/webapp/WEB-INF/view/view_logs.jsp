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

    <h1 style="margin-top: 50px; margin-bottom: 50px;">Logs</h1>

    <div class="container">
    <h2>Visualizar Logs</h2>
    <form action="/buscar-log-por-ip" method="get">
        <label for="ip_log">Buscar logs por IP:</label>
        <input type="text" id="ip_log" name="ip">
        <button type="submit">Buscar</button>
    </form>
    </div>

     
    </div>

      <div class="container">
      <h2>Visualizar</h2>
      <table>
          <thead>
          <tr>
              <th>Logs</th>
          </tr>
          </thead>
          <tbody>
            <tr>
                <td>[Kevin] : 127.0.0.1 >> Acessou : siga.cps.sp.gov.br</td>
            </tr>
            <tr>
                <td>[Gustavo] : 10.15.76.55 >> Acessou : www.example.com</td>
            </tr>
          </tbody>
      </table>

    </div>

</body>
</html>
