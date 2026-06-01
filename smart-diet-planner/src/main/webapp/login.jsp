<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Connexion – Smart Diet Planner</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .login-container {
            max-width: 400px;
            margin: 80px auto;
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }
        .login-container h2 {
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
    <p>Connexion requise</p>
</header>
<main>
    <div class="login-container">
        <h2>Authentification</h2>
        <form action="login" method="post">
            <label>Login: <input type="text" name="login" required></label>
            <label>Mot de passe: <input type="password" name="password" required></label>
            <button type="submit">Se connecter</button>
        </form>

        <!-- ✅ Sign-up link -->
        <p style="text-align:center; margin-top:15px;">
            Pas de compte ? <a href="register.jsp" style="color:#47c17a;">S'inscrire</a>
        </p>

        <p class="error">${erreur != null ? erreur : ""}</p>
    </div>
</main>
<footer>
    <p>&copy; 2026 Smart Diet Planner</p>
</footer>
</body>
</html>