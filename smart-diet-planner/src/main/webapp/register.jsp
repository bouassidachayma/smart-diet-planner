<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inscription – Smart Diet Planner</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .register-container {
            max-width: 450px;
            margin: 80px auto;
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }
        .register-container h2 {
            text-align: center;
            color: #2e7d67;
            margin-bottom: 20px;
        }
        .error {
            color: #d32f2f;
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<header>
    <h1>🥗 Smart Diet Planner</h1>
    <p>Créer un compte</p>
</header>
<main>
    <div class="register-container">
        <h2>Inscription</h2>
        <form action="register" method="post">
            <label>Nom complet: <input type="text" name="fullName" required></label>
            <label>Nom d'utilisateur: <input type="text" name="username" required></label>
            <label>Mot de passe: <input type="password" name="password" required></label>
            <label>Confirmer mot de passe: <input type="password" name="confirmPassword" required></label>
            <button type="submit">S'inscrire</button>
        </form>
        <p class="error">${erreur != null ? erreur : ""}</p>
        <p style="text-align:center; margin-top:15px;">
            Déjà un compte ? <a href="login.jsp">Se connecter</a>
        </p>
    </div>
</main>
<footer>
    <p>&copy; 2026 Smart Diet Planner</p>
</footer>
</body>
</html>