<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ page import="com.alphaomen.dao.*"%>
<%@ page import="com.alphaomen.model.*"%>
<%@ page import="com.alphaomen.db.DB"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
/* ===========================
   COLOR PALETTES
   =========================== */
:root {
  --color-primary: #90D6FF;   /* Soft sky blue (your color) */
  --color-secondary: #F8FAFC; /* Almost white background */
  --color-accent1: #7C8EA0;   /* Muted blue-gray for secondary text */
  --color-accent2: #E2E8F0;   /* Soft neutral borders */
  --color-dark: #1E293B;      /* Slate dark text */

  /* New softer accent shades */
  --accent-blue-bg: #dbeafe;   /* Light blue background */
  --accent-blue: #2563eb;      /* Bold blue */
  --accent-slate-bg: #f1f5f9;  /* Light slate background */
  --accent-slate: #334155;     /* Slate gray */
  --accent-amber-bg: #fde68a;  /* Soft amber background */
  --accent-amber: #b45309;     /* Dark amber */
  --accent-pink-bg: #fbcfe8;   /* Soft pink */
  --accent-pink: #be185d;      /* Bold pink/red */

  --bg-body: var(--color-secondary);
  --bg-card: #ffffff;
  --bg-sidebar: #E6F4FF;      /* Soft blue-tinted sidebar */
  --bg-topbar: #ffffff;

  --text-main: #1E293B;
  --text-muted: #64748B;
  --text-light: #ffffff;
  --topbar-btn: #334155;
  --border-color: #E2E8F0;
}

body.dark-mode {
  --color-primary: #0D9488;   /* Muted teal */
  --color-secondary: #0F172A; /* Dark navy background */
  --color-accent1: #64748B;
  --color-accent2: #1E293B;
  --color-dark: #F1F5F9;

  --bg-body: #0F172A;
  --bg-card: #1E293B;
  --bg-sidebar: #1E293B;
  --bg-topbar: #111827;

  --text-main: #F1F5F9;
  --text-muted: #94A3B8;
  --text-light: #ffffff;
  --topbar-btn: #CBD5E1;
  --border-color: #1E293B;
}

/* ===========================
   Body & Global Elements
   =========================== */
body {
  background: var(--bg-body);
  color: var(--text-main);
  font-family: 'Quicksand', sans-serif;
}

a {
  color: var(--color-primary);
  text-decoration: none;
}

a:hover {
  color: var(--color-accent1);
}

/* ================= Chatbot Floating FAQ UI ================= */
.chat-container.modern {
	position: fixed;
	bottom: 20px;
	right: 20px;
	width: 320px;
	max-height: 400px;
	display: flex;
	flex-direction: column;
	background: var(--bg-card);
	border-radius: 12px;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
	overflow: hidden;
	font-family: 'Quicksand', sans-serif;
	z-index: 9999;
}

/* Collapsed chatbot bubble */
.chat-container.modern.collapsed {
	width: 60px;
	height: 60px;
	border-radius: 50%;
	bottom: 20px;
	right: 20px;
	overflow: hidden;
	cursor: pointer;
}

/* Header */
.chat-header {
	background: var(--color-primary);
	color: var(--color-dark);
	font-weight: 600;
	font-size: 1rem;
	padding: 12px 15px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	cursor: pointer;
}

.chat-header i.toggle-icon {
	font-size: 1.2rem;
	transition: transform 0.3s ease;
}

/* Messages */
.chat-messages {
	scrollbar-width: thin;
	scrollbar-color: rgba(0,0,0,0.2) transparent;
	flex: 1;
	padding: 12px 15px;
	overflow-y: auto;
	display: flex;
	flex-direction: column;
	gap: 8px;
	background: var(--bg-card);
	scroll-behavior: smooth;
}
.chat-messages::-webkit-scrollbar {
  width: 4px;
}
.chat-messages::-webkit-scrollbar-thumb {
  background-color: rgba(0,0,0,0.2);
  border-radius: 2px;
}
.chat-messages::-webkit-scrollbar-track {
  background: transparent;
}

/* Messages: user vs bot */
.message {
	display: flex;
	flex-direction: column;
	max-width: 80%;
	word-wrap: break-word;
}

.user-msg {
	align-self: flex-end;
	text-align: right;
}

.user-msg .text {
	background: #DCF8C6;
	color: #000;
	border-radius: 12px 12px 0 12px;
	padding: 8px 12px;
	font-size: 0.9rem;
}

.bot-msg {
	align-self: flex-start;
	text-align: left;
}

.bot-msg .text {
	background: #f1f1f1;
	color: #000;
	border-radius: 12px 12px 12px 0;
	padding: 8px 12px;
	font-size: 0.9rem;
}

/* Timestamp */
.timestamp {
	font-size: 0.65rem;
	color: #888;
	margin-top: 2px;
}

/* Input area */
.chat-input {
	flex-shrink: 0;
	display: flex;
	border-top: 1px solid #ddd;
	background: var(--bg-card);
	padding: 6px 8px;
}

.chat-input input {
	flex: 1;
	border: 1px solid #ccc;
	padding: 6px 10px;
	font-size: 0.9rem;
	border-radius: 20px;
	outline: none;
}

.chat-input button {
	border: none;
	background: var(--color-primary);
	color: var(--color-dark);
	padding: 6px 12px;
	margin-left: 6px;
	font-size: 1rem;
	cursor: pointer;
	border-radius: 50%;
	transition: background 0.3s;
}

.chat-input button:hover {
	background: var(--color-accent1);
}

/* Animations */
@keyframes fadeIn {
	from { opacity: 0; transform: translateY(10px); }
	to { opacity: 1; transform: translateY(0); }
}
</style>
</head>
<body>
<%
	User user = (User) session.getAttribute("user");
	if (user != null) {
%>
	<div class="chat-container modern">
		<div class="chat-header" style="height: 60px;">
			<span><i class="fa-solid fa-robot me-1"></i></span>
			<i class="fa-solid fa-chevron-down toggle-icon"></i>
		</div>
		
		<div class="chat-messages" id="chatMessages">
			<c:if test="${not empty userInput}">
				<div class="message user-msg">
					<div class="text"><c:out value="${userInput}"/></div>
				</div>
			</c:if>
			
			<c:if test="${not empty botReply}">
				<div class="message bot-msg">
					<div class="text"><c:out value="${botReply}"/></div>
				</div>
			</c:if>
		</div>
		
		<form action="chat" method="post" class="chat-input" id="chatForm">
			<input type="text" name="message" id="messageInput"
				placeholder="Ask me anything..." required>
			<button type="submit">
				<i class="fa-solid fa-paper-plane"></i>
			</button>
		</form>
	</div>
<% } %>

<script>
const chatForm = document.getElementById('chatForm');
const chatMessages = document.getElementById('chatMessages');
const chatContainer = document.querySelector('.chat-container.modern');
const chatHeader = chatContainer.querySelector('.chat-header');
const toggleIcon = chatHeader.querySelector('.toggle-icon');

// Load state from localStorage (default: open)
let chatOpen = localStorage.getItem('chatOpen');
if (chatOpen === null || chatOpen === "true") {
    chatContainer.classList.remove('collapsed');
    toggleIcon.style.transform = 'rotate(0deg)';
} else {
    chatContainer.classList.add('collapsed');
    toggleIcon.style.transform = 'rotate(180deg)';
}

// Welcome message flag (session only, not localStorage)
let welcomeShown = false;

// Toggle collapse
chatHeader.addEventListener('click', () => {
    chatContainer.classList.toggle('collapsed');

    // Save state
    localStorage.setItem('chatOpen', !chatContainer.classList.contains('collapsed'));

    // Rotate icon
    if (chatContainer.classList.contains('collapsed')) {
        toggleIcon.style.transform = 'rotate(180deg)';
    } else {
        toggleIcon.style.transform = 'rotate(0deg)';

        // Show welcome message once
        if (!welcomeShown) {
            chatMessages.innerHTML += `
                <div class="message bot-msg">
                    <div class="text">👋 Hi there! How can I help you today?</div>
                </div>
            `;
            chatMessages.scrollTop = chatMessages.scrollHeight;
            welcomeShown = true;
        }
    }
});
</script>
</body>
</html>
