<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Diet Planner</title>
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

    <section id="user-form">
        <h2>Enter your details</h2>
        <form id="dietForm" action="plan" method="post">
            <!-- Hidden fields for selected conditions/allergies -->
            <input type="hidden" name="conditions" id="conditionsHidden">
            <input type="hidden" name="allergies" id="allergiesHidden">

            <label>Name: <input type="text" name="name" placeholder="Enter your name" required></label>
            <label>Weight (kg): <input type="number" step="0.1" name="weight" required></label>
            <label>Height (cm): <input type="number" step="0.1" name="height" required></label>
            <label>Age: <input type="number" name="age" required></label>

            <label>Gender:
                <select name="gender" required>
                    <option value="">Select</option>
                    <option value="male">Male</option>
                    <option value="female">Female</option>
                </select>
            </label>

            <label>Diet Type:
                <select name="dietType" required>
                    <option value="">Select</option>
                    <option value="normal">Normal</option>
                    <option value="vegetarian">Vegetarian</option>
                    <option value="vegan">Vegan</option>
                </select>
            </label>

            <!-- Health Conditions -->
            <fieldset class="condition-fieldset">
                <legend>Health Conditions:</legend>
                <div class="condition unchecked" data-value="none"><div class="circle"></div><span>None</span></div>
                <div class="condition unchecked" data-value="diabetes"><div class="circle"></div><span>Diabetes</span></div>
                <div class="condition unchecked" data-value="low_iron"><div class="circle"></div><span>Low Iron</span></div>
                <div class="condition unchecked" data-value="high_cholesterol"><div class="circle"></div><span>High Cholesterol</span></div>
                <div class="condition unchecked" data-value="hypertension"><div class="circle"></div><span>Hypertension</span></div>
            </fieldset>

            <!-- Allergies -->
            <fieldset class="allergy-fieldset">
                <legend>Allergies:</legend>
                <div class="allergy-option unchecked" data-value="none"><div class="circle"></div><span>None</span></div>
                <div class="allergy-option unchecked" data-value="gluten"><div class="circle"></div><span>Gluten</span></div>
                <div class="allergy-option unchecked" data-value="lactose"><div class="circle"></div><span>Lactose Intolerant</span></div>
                <div class="allergy-option unchecked" data-value="dairy"><div class="circle"></div><span>Dairy</span></div>
                <div class="allergy-option unchecked" data-value="nuts"><div class="circle"></div><span>Nuts</span></div>
                <div class="allergy-option unchecked" data-value="seafood"><div class="circle"></div><span>Seafood</span></div>
                <div class="allergy-option unchecked" data-value="soy"><div class="circle"></div><span>Soy</span></div>
                <div class="allergy-option unchecked" data-value="eggs"><div class="circle"></div><span>Eggs</span></div>
                <div class="allergy-option unchecked" data-value="sesame"><div class="circle"></div><span>Sesame</span></div>
                <div class="allergy-option unchecked" data-value="other"><div class="circle"></div><span>Other Allergies</span></div>
            </fieldset>

            <label>Activity Level:
                <select name="activity">
                    <option value="">Select</option>
                    <option value="low">Low</option>
                    <option value="moderate">Moderate</option>
                    <option value="high">High</option>
                </select>
            </label>

            <label>Goal:
                <select name="goal" required>
                    <option value="">Select</option>
                    <option value="lose">Lose Weight</option>
                    <option value="maintain">Maintain Weight</option>
                    <option value="gain">Gain Weight</option>
                </select>
            </label>

            <button type="submit">Generate Plan</button>
        </form>
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
        // Wait for the DOM to be fully loaded
        document.addEventListener('DOMContentLoaded', function() {
            const selectedConditions = new Set();
            const selectedAllergies = new Set();

            function setupSelectable(groupSelector, selectedSet, hiddenFieldId) {
                const options = document.querySelectorAll(groupSelector);
                const hiddenField = document.getElementById(hiddenFieldId);

                if (!hiddenField) {
                    console.error('Hidden field not found: ' + hiddenFieldId);
                    return;
                }

                options.forEach(option => {
                    option.addEventListener('click', function(e) {
                        const value = this.dataset.value;
                        const circle = this.querySelector('.circle');
                        const isNone = value === 'none';

                        if (isNone) {
                            const nowChecked = !this.classList.contains('checked');
                            // Reset all options
                            options.forEach(opt => {
                                opt.classList.remove('checked');
                                opt.classList.add('unchecked');
                                const circ = opt.querySelector('.circle');
                                if (circ) circ.textContent = '';
                                opt.classList.remove('disabled');
                            });
                            selectedSet.clear();
                            if (nowChecked) {
                                this.classList.add('checked');
                                if (circle) circle.textContent = '✔';
                                selectedSet.add('none');
                                options.forEach(opt => {
                                    if (opt !== this) opt.classList.add('disabled');
                                });
                            }
                        } else {
                            const noneOption = document.querySelector(groupSelector + '[data-value="none"]');
                            if (noneOption && noneOption.classList.contains('checked')) {
                                noneOption.classList.remove('checked');
                                noneOption.classList.add('unchecked');
                                const noneCircle = noneOption.querySelector('.circle');
                                if (noneCircle) noneCircle.textContent = '';
                                noneOption.classList.remove('disabled');
                                selectedSet.delete('none');
                            }

                            this.classList.toggle('checked');
                            this.classList.toggle('unchecked');
                            if (this.classList.contains('checked')) {
                                if (circle) circle.textContent = '✔';
                                selectedSet.add(value);
                            } else {
                                if (circle) circle.textContent = '';
                                selectedSet.delete(value);
                            }
                        }
                        // Update hidden field
                        hiddenField.value = Array.from(selectedSet).join(',');
                    });
                });
            }

            setupSelectable('.condition', selectedConditions, 'conditionsHidden');
            setupSelectable('.allergy-option', selectedAllergies, 'allergiesHidden');

            // Ensure hidden fields are populated before form submission
            const form = document.getElementById('dietForm');
            form.addEventListener('submit', function() {
                document.getElementById('conditionsHidden').value = Array.from(selectedConditions).join(',');
                document.getElementById('allergiesHidden').value = Array.from(selectedAllergies).join(',');
            });
        });
    })();
</script>
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
