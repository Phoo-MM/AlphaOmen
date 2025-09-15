<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sign Up - Sticky Notes</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #f0f4f8, #d9e2ec);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .container {
            background: #fff;
            padding: 40px 30px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            width: 350px;
            position: relative;
            text-align: center;
        }
        .container img.logo {
            width: 80px;
            margin-bottom: 20px;
        }
        h2 {
            color: #333;
            margin-bottom: 25px;
            font-weight: 600;
        }
        .form-group {
            margin-bottom: 18px;
            text-align: left;
        }
        label {
            display: block;
            margin-bottom: 6px;
            color: #555;
            font-size: 14px;
        }
        input[type="email"], input[type="password"], input[type="text"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 14px;
            transition: 0.3s;
        }
        input[type="email"]:focus, input[type="password"]:focus, input[type="text"]:focus {
            border-color: #28a745;
            outline: none;
        }
        button {
            width: 100%;
            padding: 12px;
            background-color: #28a745;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s;
        }
        button:hover {
            background-color: #218838;
        }
        .message {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 6px;
            font-size: 14px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .info {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        .otp-section { display: none; }
        .toggle-link { margin-top: 20px; font-size: 14px; }
        .toggle-link a { color: #007bff; text-decoration: none; }
        .toggle-link a:hover { text-decoration: underline; }
        .decorative-img {
            position: absolute;
            width: 80px;
            opacity: 1;
        }
        .decorative-top-left { top: -20px; left: -20px; }
        .decorative-bottom-right { bottom: -20px; right: -20px; }
    </style>
</head>
<body>
    <div class="container">
        <img src="assets/images/alphaomen3.png" class="logo" alt="Sticky Notes Logo">
        <img src="assets/images/home.png" class="decorative-img decorative-top-left" alt="">
        <img src="assets/images/home1.png" class="decorative-img decorative-bottom-right" alt="">
        <h2>Sign Up</h2>

        <% 
            String message = (String) session.getAttribute("message");
            String messageType = (String) session.getAttribute("messageType");
            Boolean otpSent = (Boolean) session.getAttribute("otpSent");
            if (message != null) {
        %>
            <div class="message <%= messageType %>"><%= message %></div>
        <%
            session.removeAttribute("message");
            session.removeAttribute("messageType");
            }
        %>

        <form action="signup" method="post" id="signupForm">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" placeholder="Enter your username" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" placeholder="Enter password" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required>
            </div>
            <button type="submit"><i class="fa-solid fa-user-plus"></i> Sign Up</button>
            <input type="hidden" name="action" value="signup">
        </form>

        <div class="otp-section" id="otpSection">
            <form action="signup" method="post" id="otpForm">
                <div class="form-group">
                    <label for="otp">Enter OTP:</label>
                    <input type="text" id="otp" name="otp" maxlength="6" required>
                </div>
                <button type="submit"><i class="fa-solid fa-key"></i> Verify OTP</button>
                <input type="hidden" name="action" value="verifyOtp">
            </form>
        </div>

        <div class="toggle-link">
            <a href="login.jsp">Already have an account? Login</a>
        </div>

        <script>
            const otpSent = '<%= otpSent != null ? "true" : "false" %>';
            if (otpSent === 'true') {
                document.getElementById('signupForm').style.display = 'none';
                document.getElementById('otpSection').style.display = 'block';
            }
        </script>
    </div>
</body>
</html>
