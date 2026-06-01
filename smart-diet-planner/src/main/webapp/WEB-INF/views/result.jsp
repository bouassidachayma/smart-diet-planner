<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Diet Plan</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<header>
    <h1>🥗 Smart Diet Planner</h1>
    <p>Your personalized path to healthy eating</p>
</header>

<main>
    <!-- ✅ User bar with welcome message and Quitter button -->
    <div class="user-bar">
        <span>👤 Bienvenue, <strong>${sessionScope.user}</strong></span>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">🚪 Quitter</a>
    </div>

    <section id="results">
        <h2>Your Personalized Diet Plan</h2>
        <p>Hello, <strong>${name}</strong>!</p>
        <p>Your BMI is <strong>${bmi}</strong> (${bmiCategory})</p>
        <p>Estimated daily calorie needs: <strong>${calories} kcal</strong></p>

        <div id="weeklyPlan">
            <h3>📅 Your 7‑Day Meal Calendar</h3>
            <div class="week-grid">
                <c:forEach var="dayEntry" items="${weekPlan}">
                    <c:set var="day" value="${dayEntry.key}" />
                    <c:set var="meals" value="${dayEntry.value}" />
                    
                    <!-- Calculate daily totals -->
                    <c:set var="dayCalories" value="0" />
                    <c:set var="dayProtein" value="0" />
                    <c:forEach var="mealEntry" items="${meals}">
                        <c:set var="meal" value="${mealEntry.value}" />
                        <c:set var="dayCalories" value="${dayCalories + meal.calories}" />
                        <c:set var="dayProtein" value="${dayProtein + meal.protein}" />
                    </c:forEach>

                    <div class="day-card">
                        <div class="day-header">
                            <span class="day-name">${day}</span>
                        </div>
                                                
                        <!-- Calorie Goal Progress (noticeable) -->
                        <div class="calorie-goal-container">
                            <div class="goal-label">
                                <span>🎯 Daily Goal: ${calories} kcal</span>
                                <span class="goal-percent">
                                    <c:set var="percent" value="${dayCalories * 100 / calories}" />
                                    <c:choose>
                                        <c:when test="${percent > 100}">100%+</c:when>
                                        <c:otherwise>${String.format("%.0f", percent)}%</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="calorie-progress">
                                <div class="progress-fill ${dayCalories > calories ? 'over' : (percent > 90 ? 'near' : 'good')}" 
                                     style="width: ${dayCalories > calories ? 100 : percent}%;">
                                </div>
                            </div>
                            <div class="goal-consumed">
                                🔥 Consumed: ${dayCalories} kcal · 💪 ${dayProtein}g protein
                            </div>
                        </div>
                                                
                        <div class="meals-container">
                            <c:forEach var="mealEntry" items="${meals}">
                                <c:set var="mealType" value="${mealEntry.key}" />
                                <c:set var="meal" value="${mealEntry.value}" />
                                <div class="meal-item ${fn:toLowerCase(mealType)}">
                                    <div class="meal-details">
                                        <span class="meal-type">${mealType}</span>
                                        <span class="meal-name">${meal.name}</span>
                                        <span class="meal-meta">🔥 ${meal.calories} kcal · 💪 ${meal.protein}g</span>
                                        <c:if test="${not empty meal.reason}">
                                            <span class="meal-reason" title="${meal.reason}"><span class="reason-text">${meal.reason}</span></span>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <p class="regenerate-note"><em>🎲 Want variety? Regenerate the plan to see new meals!</em></p>
        </div>        

        <p style="margin-top: 20px;"><a href="index.jsp">← Back to form</a></p>
    </section>
</main>


<!-- Chatbot Widget -->
<div class="chatbot-container">
    <button class="chatbot-toggle" id="chatbotToggle">💬</button>
    <div class="chatbot-window" id="chatbotWindow">
        <div class="chatbot-header">
            <span>🤖 Diet Assistant</span>
            <button class="chatbot-close" id="chatbotClose">✖</button>
        </div>
        <div class="chatbot-messages" id="chatbotMessages">
            <div class="message bot">Hello! Ask me about calories, protein, BMI, or health conditions.</div>
        </div>
        <div class="chatbot-input">
            <input type="text" id="chatbotInput" placeholder="Type your question..." />
            <button id="chatbotSend">Send</button>
        </div>
    </div>
</div>
<footer>
    <p>&copy; 2026 Smart Diet Planner. All rights reserved</p>
</footer>
<script>
(function() {
    const toggleBtn = document.getElementById('chatbotToggle');
    const windowEl = document.getElementById('chatbotWindow');
    const closeBtn = document.getElementById('chatbotClose');
    const messagesDiv = document.getElementById('chatbotMessages');
    const inputField = document.getElementById('chatbotInput');
    const sendBtn = document.getElementById('chatbotSend');

    // Toggle chat window
    toggleBtn.addEventListener('click', () => {
        windowEl.classList.toggle('active');
        if (windowEl.classList.contains('active')) {
            inputField.focus();
        }
    });

    closeBtn.addEventListener('click', () => {
        windowEl.classList.remove('active');
    });

    // Send message function
    function sendMessage() {
        const text = inputField.value.trim();
        if (text === '') return;

        // Add user message
        addMessage(text, 'user');
        inputField.value = '';

        // Call bot servlet
        fetch('${pageContext.request.contextPath}/chatbot', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'message=' + encodeURIComponent(text)
        })
        .then(response => response.text())
        .then(reply => {
            addMessage(reply, 'bot');
        })
        .catch(error => {
            addMessage('Sorry, I had a problem. Please try again.', 'bot');
            console.error('Chatbot error:', error);
        });
    }

    function addMessage(text, sender) {
        const msgDiv = document.createElement('div');
        msgDiv.classList.add('message', sender);
        msgDiv.textContent = text;
        messagesDiv.appendChild(msgDiv);
        messagesDiv.scrollTop = messagesDiv.scrollHeight;
    }

    sendBtn.addEventListener('click', sendMessage);
    inputField.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            sendMessage();
        }
    });

    // Close window when clicking outside (optional)
    document.addEventListener('click', (e) => {
        if (!windowEl.contains(e.target) && e.target !== toggleBtn && !toggleBtn.contains(e.target)) {
            windowEl.classList.remove('active');
        }
    });
})();
</script>
</body>
</html>