<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.alphaomen.model.*"%>
<%@ page import="com.alphaomen.dao.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*, com.alphaomen.db.DB"%>
<%@ page import="java.time.LocalDate, java.util.Map"%>
<%
// DAO instances 
NoteDAO noteDAO = new NoteDAO();
MoodDAO moodDAO = new MoodDAO();

List<Note> notes = new ArrayList<>();
User user = (User) session.getAttribute("user");

String todayMood = null;
String motivationQuote = "";

// Ads 
int noteCount = 0;
String userPlan = "guest";
if (user != null) {
	if (user.getPlanId() == 2) {
		userPlan = "premium";
	} else {
		userPlan = "free";
	}
	noteCount = user.getNoteCount();
}
List<Ad> ads = new ArrayList<>();
// Separate ads by type, only if free user
List<Ad> bannerAds = new ArrayList<>();
List<Ad> sidebarAds = new ArrayList<>();
List<Ad> popupAds = new ArrayList<>();

if ("free".equals(userPlan)) {
	AdDAO adDAO = new AdDAO();
	ads = adDAO.getActiveAds();
	for (Ad ad : ads) {
		switch (ad.getDisplayType().toLowerCase()) {
	case "banner" :
		bannerAds.add(ad);
		break;
	case "sidebar" :
		sidebarAds.add(ad);
		break;
	case "popup" :
		popupAds.add(ad);
		break;
		}
	}
}

// End of Ads

if (user != null) {
	notes = noteDAO.getNotesByUser(user.getId());

	Map<String, String> moodHistory = moodDAO.getMoodHistory(user.getId(), java.time.YearMonth.now());
	LocalDate thisday = LocalDate.now();
	todayMood = moodHistory.getOrDefault(thisday.toString(), "No mood selected");

	if ("Happy".equals(todayMood))
		motivationQuote = "Keep smiling! Happiness looks good on you 😊";
	else if ("Sad".equals(todayMood))
		motivationQuote = "Every cloud has a silver lining. Stay strong 💪";
	else if ("Angry".equals(todayMood))
		motivationQuote = "Take a deep breath. Calm mind, clear path 🌿";
	else if ("Neutral".equals(todayMood))
		motivationQuote = "Embrace today as it comes. Balance is key ⚖️";
	else
		motivationQuote = "Select your mood today to get a motivational quote! ✨";

}

// Notes categorization
List<Note> pinnedNotes = new ArrayList<>();
List<Note> upcomingNotes = new ArrayList<>();
List<Note> otherNotes = new ArrayList<>();

java.util.Date today = new java.util.Date();

for (Note n : notes) {
	if (n.isPinned())
		pinnedNotes.add(n);
	else if (n.getDueDate() != null) {
		long diffDays = (n.getDueDate().getTime() - today.getTime()) / (1000 * 60 * 60 * 24);
		if (diffDays >= 0 && diffDays <= 2)
	upcomingNotes.add(n);
		else
	otherNotes.add(n);
	} else
		otherNotes.add(n);
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AlphaOmen</title>
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Font Awesome (Optional for Icons) -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
	rel="stylesheet">

<link rel="stylesheet" href="assets/css/style.css">
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

/* ===========================
   Sidebar
   =========================== */
.sidebar {
  background-color: var(--bg-sidebar) !important;
  color: var(--text-main) !important;
  position: sticky; 
  top: 0; 
  height: 100vh; 
  overflow-y: auto;
}

.sidebar a {
  display: block;
  text-decoration: none;
  color: var(--text-main);
  background: transparent;
  padding: 12px 20px;
  margin-bottom: 5px;
  border-radius: 8px;
  transition: 0.3s;
}

.sidebar a:hover,
.sidebar a.active {
  background-color: var(--color-primary);
  color: var(--color-dark);
}
/* ===========================
   Offcanvas Sidebar Styling (Mobile)
   =========================== */
.offcanvas {
    background-color: var(--bg-sidebar);
    color: var(--text-main);
}

.offcanvas .offcanvas-header {
    background-color: var(--bg-topbar);
    border-bottom: 1px solid var(--border-color);
}

.offcanvas .offcanvas-title {
    color: var(--text-main);
}

.offcanvas .btn-close {
    filter: invert(0.5); /* adjust for visibility */
}

/* Navigation Links */
.offcanvas .nav-link {
    display: block;
    text-decoration: none;
    color: var(--text-main);
    background: transparent;
    padding: 12px 20px;
    margin-bottom: 5px;
    border-radius: 8px;
    transition: 0.3s;
}

.offcanvas .nav-link:hover,
.offcanvas .nav-link.active {
    background-color: var(--color-primary);
    color: var(--color-dark);
}

/* Adjust dropdowns inside offcanvas */
.offcanvas .dropdown-menu {
    background-color: var(--bg-sidebar);
    border: 1px solid var(--border-color);
}

.offcanvas .dropdown-item {
    color: var(--text-main);
}

.offcanvas .dropdown-item:hover {
    background-color: var(--color-primary);
    color: var(--color-dark);
}

/* Dark mode adjustments */
body.dark-mode .offcanvas {
    background-color: var(--bg-sidebar);
    color: var(--text-main);
}

body.dark-mode .offcanvas .nav-link:hover,
body.dark-mode .offcanvas .nav-link.active {
    background-color: var(--color-primary);
    color: var(--text-dark);
}

body.dark-mode .offcanvas .dropdown-item:hover {
    background-color: var(--color-primary);
    color: var(--text-dark);
}

/* ===========================
   Topbar
   =========================== */
.navbar {
  background: var(--bg-topbar);
  color: var(--text-light);
  z-index: 1030;
}

.navbar .btn-light {
	background-color: var(--topbar-btn);
	color: var(--text-light);
}


/* Main content: leave space for sidebar + topbar */
.main-content {
    margin-left: 220px;       /* space for sidebar */
    padding: 30px;
    padding-top: 60px;        /* enough space for topbar + banner */
    background: #f4f7fa url('assets/images/background-pattern.png') repeat;
    min-height: 100vh;
    width: calc(100% - 220px); /* take full width minus sidebar */
    box-sizing: border-box;
    align-items: stretch; 
}

.main-content.no-banner {
	padding-top: 15px; /* only topbar */	
}

/* Weather/Location section */
.weather-location {
	background: url('assets/images/weather-bg.jpg') no-repeat center center;
	background-size: cover;
	padding: 20px;
	margin-bottom: 20px;
	border-radius: 8px;
	color: #fff;
}

/* Responsive */
@media ( max-width : 768px) {
	.sidebar {
		width: 60px;
	}
	.sidebar a span {
		display: none;
	}
	.main-content {
		padding: 15px;
	}
}
/********************************************* Ads Style ************************************/
/* Sidebar Ads */
.sidebar .ad {
	width: 100%;
	max-width: 220px; /* fits sidebar width */
	height: 200px;
	margin-bottom: 20px;
	border: 1px solid #ddd;
	padding: 5px;
	text-align: center;
	background: #fff;
	border-radius: 8px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
	transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.sidebar .ad:hover {
	transform: translateY(-2px);
	box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
}

.sidebar .ad img {
	width: 100%;
	height: 100%;
	object-fit: cover; /* ensures image fills the ad space */
	border-radius: 6px;
}

/* Banner Ads – fixed below topbar */
.banner {
    position: fixed;
    top: 60px; /* directly below topbar */
    left: 220px; /* leave space for sidebar */
    right: 0;
    margin: 0 auto;
    display: flex;
    justify-content: center;
    align-items: center;
    background: #fff;
    padding: 8px 12px;
    border-bottom: 1px solid #ddd;
    box-shadow: 0 2px 6px rgba(0,0,0,0.08);
    max-width: 468px;
    width: 100%;
    height: auto;
    z-index: 1090;
}

.banner img {
    width: 100%;
    max-height: 40px;
    object-fit: contain;
    border-radius: 6px;
}

.banner a {
	display: block;
	text-decoration: none;
	color: inherit;
	transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.banner a:hover {
	transform: translateY(-3px);
	box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
}

/* Popup Ad */
.popup-ad {
    display: none;
    position: fixed;
    top: 20%;
    left: 50%;
    transform: translateX(-50%);
    width: 40%;
    max-width: 500px;
    background: #fff;
    border: 2px solid #333;
    padding: 20px;
    z-index: 9999;
    box-shadow: 0 8px 20px rgba(0,0,0,0.4);
    border-radius: 10px;
    animation: popupFadeIn 0.5s ease forwards;
    overflow: hidden;
}

.popup-ad img {
    width: 100%;
    height: auto;
    object-fit: contain;
    border-radius: 6px;
    margin-bottom: 10px;
}
/********************************************* Ads End ************************************/

/* Timer Page inside main content */
#timerPage {
  display: none;
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: 16px;
  padding: 30px;
  margin-top: 20px;
  box-shadow: 0 6px 20px rgba(0,0,0,0.15);
}

#timerPage.active {
  display: block;
}

.mode-buttons{display:flex;justify-content:center;gap:10px;margin-bottom:15px;}
.mode-buttons button{padding:6px 12px;border-radius:20px;border:2px solid black;background:white;cursor:pointer;font-size:14px;font-weight:500;}
.mode-buttons button.active{background:#7b6ef6;color:white;border:none;}
.timer-display{text-align:center;font-size:48px;font-weight:bold;margin:15px 0;}
.control-buttons{display:flex;justify-content:center;gap:10px;margin-top:10px;}
.control-buttons button{font-size:16px;padding:8px 16px;border-radius:30px;border:none;cursor:pointer;}
.start-btn{background:black;color:white;}
.pause-btn {
    background: orange;
    color: white;
    font-weight: bold;
    border: none;
    padding: 8px 16px;
    border-radius: 30px;
    cursor: pointer;
}
.reset-btn{background:white;border:2px solid black;}
.close-btn{position:absolute;top:10px;right:15px;font-size:20px;background:transparent;border:none;cursor:pointer;}

/* Close button dark mode */
body.dark-mode #timerPage .close-btn {
  color: #ffffff;
}
body.dark-mode #timerPage .close-btn:hover {
  color: var(--color-primary);
}
/* ======================= Dark Mode for Timer & Buttons ======================= */
body.dark-mode #timerPage {
    background: var(--bg-card);
    border: 1px solid var(--border-color);
    color: var(--text-main);
}

body.dark-mode .mode-buttons button {
    background: var(--bg-card);
    color: var(--text-main);
    border: 2px solid var(--border-color);
}

body.dark-mode .mode-buttons button.active {
    background: var(--color-primary);
    color: var(--text-light);
    border: none;
}

body.dark-mode .timer-display {
    color: var(--text-main);
}

body.dark-mode .control-buttons .start-btn {
    background: var(--color-primary);
    color: var(--text-light);
}

body.dark-mode .control-buttons .pause-btn {
    background: orange; /* you can also choose var(--color-accent1) if preferred */
    color: var(--text-light);
}

body.dark-mode .control-buttons .reset-btn {
    background: var(--bg-card);
    border: 2px solid var(--border-color);
    color: var(--text-main);
}

/* Popup Ad Dark Mode */
body.dark-mode .popup-ad {
    background: var(--bg-card);
    border: 2px solid var(--border-color);
    color: var(--text-main);
}

body.dark-mode .popup-ad img {
    filter: brightness(0.9); /* slightly darker if needed */
}



</style>

</head>
<body>

	<div class="container-fluid">
        <div class="row">

            <!-- Sidebar -->
			<nav class="col-md-2 col-lg-2 d-none d-md-block sidebar">
                <div class="pt-3 overflow-auto">

                    <!-- Logo -->
                    <div class="text-center mb-4">
                        <img src="assets/images/alphaomen3.png" alt="AlphaOmen-Logo"
                             class="img-fluid" width="150">
                    </div>

                    <!-- Navigation -->
                    <ul class="nav flex-column">
                        <% if (user != null && user.isAdmin()) { %>
                        <li class="nav-item">
                            <a class="nav-link" href="admin.jsp">
                                <i class="fa-solid fa-tachometer-alt me-2"></i> Dashboard
                            </a>
                        </li>
                        <% } %>

                        <li class="nav-item">
                            <a class="nav-link" href="index.jsp">
                                <i class="fa-solid fa-house me-2"></i> Home
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="notes.jsp">
                                <i class="fa-solid fa-pen-to-square me-2"></i> Notes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="manageTags.jsp">
                                <i class="fa-solid fa-tags me-2"></i> Categories
                            </a>
                        </li>
                        <jsp:include page="calculator.jsp" />
                        <li class="nav-item">
                            <a class="nav-link active" href="timer.jsp" id="timerToggle">
                                <i class="fa-solid fa-clock me-2"></i> Timer
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="MoodServlet">
                                <i class="fa-solid fa-face-smile me-2"></i> Mood Tracker
                            </a>
                        </li>
                    </ul>

                    <% if ("free".equals(userPlan)) { %>
                        <!-- Sidebar Ads for Free Users -->
                        <div class="mt-4">
                            <% for (Ad ad : sidebarAds) { %>
                            <div class="card mb-3">
                                <a href="<%=ad.getLinkUrl()%>" target="_blank">
                                    <img src="<%=ad.getImageUrl()%>" class="card-img-top" alt="<%=ad.getTitle()%>">
                                </a>
                            </div>
                            <% } %>
                        </div>
                    <% } %>

                </div>
            </nav>
			
			<!-- Offcanvas Sidebar for Mobile -->
            <div class="offcanvas offcanvas-start" tabindex="-1" id="offcanvasSidebar" aria-labelledby="offcanvasSidebarLabel">
                <div class="offcanvas-header">
                    <h5 class="offcanvas-title" id="offcanvasSidebarLabel">Menu</h5>
                    <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                </div>
                <div class="offcanvas-body overflow-auto">
                    <div class="text-center mb-4">
	                    <img src="assets/images/alphaomen3.png" alt="AlphaOmen-Logo"
	                         class="img-fluid" width="150">
	                </div>
                    <ul class="nav flex-column">
                        <% if (user != null && user.isAdmin()) { %>
                        <li class="nav-item">
                            <a class="nav-link" href="admin.jsp">
                                <i class="fa-solid fa-tachometer-alt me-2"></i> Dashboard
                            </a>
                        </li>
                        <% } %>
                        <li class="nav-item">
                            <a class="nav-link" href="index.jsp">
                                <i class="fa-solid fa-house me-2"></i> Home
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="notes.jsp">
                                <i class="fa-solid fa-pen-to-square me-2"></i> Notes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="manageTags.jsp">
                                <i class="fa-solid fa-tags me-2"></i> Categories
                            </a>
                        </li>
                        <jsp:include page="calculator.jsp" />
                        <li class="nav-item">
                            <a class="nav-link active" href="timer.jsp" id="timerToggle">
                                <i class="fa-solid fa-clock me-2"></i> Timer
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="MoodServlet">
                                <i class="fa-solid fa-face-smile me-2"></i> Mood Tracker
                            </a>
                        </li>

                        <% if ("free".equals(userPlan)) { %>
                        <div class="mt-3">
                            <% for (Ad ad : sidebarAds) { %>
                            <div class="card mb-2">
                                <a href="<%=ad.getLinkUrl()%>" target="_blank">
                                    <img src="<%=ad.getImageUrl()%>" class="card-img-top" alt="<%=ad.getTitle()%>">
                                </a>
                            </div>
                            <% } %>
                        </div>
                        <% } %>
                    </ul>
                </div>
            </div>
			
		<!-- Main content -->
            <main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
                <!-- Topbar -->
                <nav class="navbar navbar-expand-lg shadow-sm sticky-top">
                    <div class="container-fluid">
                    	<button class="btn btn-light d-md-none me-2" type="button" data-bs-toggle="offcanvas"
                            data-bs-target="#offcanvasSidebar" aria-controls="offcanvasSidebar">
	                        <i class="fa-solid fa-bars"></i>
	                    </button>
	                    
                        <button id="darkModeToggle" class="btn btn-light me-2" title="Toggle Dark Mode">
                            <i id="darkModeIcon" class="fa-solid fa-moon"></i>
                        </button>
                        
                        <!-- Banner ads in the center -->
    <% if ("free".equals(userPlan)) { %>
      <div class="d-flex flex-wrap justify-content-center mx-auto gap-2">
        <% for (Ad ad : bannerAds) { %>
          <div style="width: 250px; height: 50px; overflow: hidden; border-radius: 6px;">
            <a href="<%=ad.getLinkUrl()%>" target="_blank">
              <img src="<%=ad.getImageUrl()%>" 
                   alt="<%=ad.getTitle()%>" 
                   style="width: 100%; height: 100%; object-fit: cover;">
            </a>
          </div>
        <% } %>
      </div>
    <% } %>


                        <div class="ms-auto d-flex align-items-center">
                            <% if (user != null) { %>
                            <div class="dropdown me-2">
                                <a class="btn btn-light dropdown-toggle" href="#" role="button" id="userDropdown"
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fa-solid fa-circle-user me-1"></i> <%=user.getUsername()%>
                                    <%=user.isAdmin() ? " (Admin)" : ""%>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                    <li><a class="dropdown-item" href="accinfo.jsp">
                                        <i class="fa-solid fa-user-pen me-2"></i> Account Info
                                    </a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="logout.jsp">
                                        <i class="fa-solid fa-right-from-bracket me-2"></i> Logout
                                    </a></li>
                                </ul>
                            </div>

                            <a href="purchasePlan.jsp" class="btn btn-warning btn-sm">
                                <i class="fa-solid fa-star me-1"></i> Premium Plan
                            </a>
                            <% } else { %>
                            <a href="login.jsp" class="btn btn-sm btn-light">Login</a>
                            <% } %>
                        </div>
                    </div>
                </nav>


		<%
		if (user != null) { // logged-in user
		%>

			<!-- Timer Page -->
			<div id="timerPage" class="active">
			  <button class="close-btn" id="fullClose">&times;</button>
			  <h2 class="text-center">Timer</h2>
			
			  <!-- Timer Tabs -->
			  <div class="mode-buttons">
			    <button id="tabPomodoro" class="active" onclick="showTimer('pomodoroSection')">Pomodoro</button>
			    <button id="tabCustom" onclick="showTimer('customSection')">Custom</button>
			  </div>
			
			  <!-- Pomodoro Timer -->
			  <div id="pomodoroSection">
			    <h3 class="text-center">Pomodoro Timer</h3>
			    <div class="mode-buttons justify-content-center mb-3">
			      <button id="pomodoroMode" class="active" onclick="setPomodoroMode('pomodoro')">Pomodoro</button>
			      <button id="shortBreakMode" onclick="setPomodoroMode('short')">Short Break</button>
			      <button id="longBreakMode" onclick="setPomodoroMode('long')">Long Break</button>
			    </div>
			    <div id="pomodoroDisplay" class="timer-display">25:00</div>
			    <div class="control-buttons">
			      <button class="start-btn" id="pomodoroStart" onclick="togglePomodoro()">Start</button>
			        <button class="pause-btn" onclick="pausePomodoro()">Pause</button>
			      <button class="reset-btn" onclick="resetPomodoro()"><i class="fa-solid fa-rotate-right"></i></button>
			    </div>
			  </div>
			
			  <!-- Custom Timer -->
			  <div id="customSection" style="display:none;">
			    <h3 class="text-center">Custom Timer</h3>
			    <div class="mb-3 text-center">
			      <input type="number" id="customMinutes" placeholder="Minutes" class="form-control mb-2" 
				       style="width:150px;display:inline-block;" min="0" max="119">
				<input type="number" id="customSeconds" placeholder="Seconds" class="form-control" 
				       style="width:150px;display:inline-block;" min="0" max="59">

			    </div>
			    <div id="customDisplay" class="timer-display">00:00</div>
			    <div class="control-buttons">
			      <button class="start-btn" id="customStart" onclick="toggleCustom()">Start</button>
			        <button class="pause-btn" id="customPause" onclick="pauseCustom()">Pause</button>
			      <button class="reset-btn" onclick="resetCustom()"><i class="fa-solid fa-rotate-right"></i></button>
			    </div>
			  </div>
			</div>

		<%
		} else { // guest user
		%>

		<p>
		 <a href="signup.jsp">Log in</a> to start your timer!
		</p>
		<%
		}
		%>
	

</main>
</div> <!-- End of row -->
</div> <!-- End of Container fluid -->

<script>
// ========== GLOBAL VARIABLES ==========
let timerInterval, timeLeft=0, running=false, currentMode='pomodoro', isCustom=false;
const durations={pomodoro:25*60,short:5*60,long:15*60};
//Open timer page
document.getElementById('timerToggle').onclick = e => {
	 e.preventDefault();
	    const timerPage = document.getElementById('timerPage');
	    timerPage.classList.add('active');
	    showTimer('pomodoroSection'); // show Pomodoro by default
	};

//Close timer page
document.getElementById('fullClose').onclick = () => {
  document.getElementById('timerPage').classList.remove('active');

};
//======== CHOOSE TIMER FIRST ========
function chooseTimer(type){
  document.getElementById('timerChoice').style.display = 'none';
  if(type === 'pomodoro'){
    document.getElementById('pomodoroSection').style.display = 'block';
    setPomodoroMode('pomodoro'); // default
  } else {
    document.getElementById('customSection').style.display = 'block';
  }
}
//===== INIT =====
window.addEventListener('load', ()=>{
    // Restore state
    if(localStorage.getItem('timeLeft')){        running = localStorage.getItem('running') === 'true';
        currentMode = localStorage.getItem('currentMode') || 'pomodoro';
        isCustom = localStorage.getItem('isCustom') === 'true';
        updateDisplay();
        if(running) startTimer();
    }
});

//===== UPDATE DISPLAY  =====
function updateDisplay(){
    let m=Math.floor(timeLeft/60), s=timeLeft%60;
    let text=(m<10?'0':'')+m+':'+(s<10?'0':'')+s;
    const pomodoroDisplay = document.getElementById('pomodoroDisplay');
    const customDisplay = document.getElementById('customDisplay');
    if(pomodoroDisplay) pomodoroDisplay.innerText = text;
    if(customDisplay) customDisplay.innerText = text;
    document.getElementById('floatingDisplay').innerText=text;
    let title=currentMode==='custom'?'Custom':(currentMode==='pomodoro'?'Pomodoro':currentMode==='short'?'Short Break':'Long Break');
    document.getElementById('floatingTitle').innerText=title;
    saveState();
}

//===== TIMER FUNCTIONS =====
function startTimer(){
    if(!running && timeLeft>0){
        running=true;
        timerInterval=setInterval(()=>{
            if(timeLeft>0){timeLeft--; updateDisplay();}
            else stopTimer();
        },1000);
        saveState();
    }
}
function pauseTimer() {
    clearInterval(timerInterval);
    running = false;
    saveState();
}

function stopTimer(isReset=false){
    clearInterval(timerInterval); 
    running = false;

    if(!isReset){ 
        // Only reset timeLeft if NOT explicitly resetting
        if(isCustom) timeLeft = 0; 
        else timeLeft = durations[currentMode];
    }

    updateDisplay();

    if(!isReset){
        // Notification & sound
        if (Notification.permission === "granted") {
            new Notification("⏰ Timer Finished!", {
                body: currentMode === 'custom' ? "Your custom timer is up!" : currentMode + " timer finished!",
                icon: "assets/images/alphaomen3.png"
            });
        }

        let audio = new Audio('assets/sounds/notification.wav');
        audio.play();
    }
}


// Request notification permission on page load
window.addEventListener('load', () => {
    const savedTime = parseInt(localStorage.getItem('timeLeft')) || 0;
    const savedRunning = localStorage.getItem('running') === 'true';
    const savedMode = localStorage.getItem('currentMode') || 'pomodoro';
    const savedIsCustom = localStorage.getItem('isCustom') === 'true';

    timeLeft = savedTime;
    running = savedRunning;
    currentMode = savedMode;
    isCustom = savedIsCustom;

    updateDisplay();

    if(running) startTimer(); // resume timer on page load
    if(Notification.permission !== "granted"){
        Notification.requestPermission();
    }
});
// ========== POMODORO MODE ==========
function setPomodoroMode(mode){
  currentMode=mode; isCustom=false;
  timeLeft=durations[mode];
  document.getElementById('pomodoroMode').classList.remove('active');
  document.getElementById('shortBreakMode').classList.remove('active');
  document.getElementById('longBreakMode').classList.remove('active');
  if(mode==='pomodoro') document.getElementById('pomodoroMode').classList.add('active');
  if(mode==='short') document.getElementById('shortBreakMode').classList.add('active');
  if(mode==='long') document.getElementById('longBreakMode').classList.add('active');
  stopTimer();
}

// ========== CUSTOM TIMER ==========
function toggleCustom(){
  if(!running){
    let min = parseInt(document.getElementById('customMinutes').value) || 0;
    let sec = parseInt(document.getElementById('customSeconds').value) || 0;

    // LIMIT: max 2 hours
    if(min > 120) min = 120;
    if(sec > 59) sec = 59;

    timeLeft = min*60 + sec;
    currentMode = 'custom'; 
    isCustom = true;
  }
  if(running){
    pauseCustom();
  } else {
    startTimer();
  }
}
function pauseCustom() {
    pauseTimer();
}
function resetCustom(){
    isCustom = false;
    timeLeft = 0;               // reset custom timer
    document.getElementById('customDisplay').innerText = '00:00';
    document.getElementById('customMinutes').value = '';
    document.getElementById('customSeconds').value = '';
    stopTimer(true);            // skip notifications
}
// ========== POMODORO BUTTON ==========
// Start button shows floating timer
function togglePomodoro(){
  if(running) {
    pauseTimer();
  } else {
    startTimer();

  }
}
function pausePomodoro() {
    pauseTimer();
}

function resetPomodoro(){
    isCustom = false;           // ensure custom flag is false
    timeLeft = durations['pomodoro']; // reset Pomodoro to default
    stopTimer(true);            // pass true to skip notifications
}
// ========== TAB SWITCH ==========
function showTimer(section){
  document.getElementById('pomodoroSection').style.display='none';
  document.getElementById('customSection').style.display='none';
  document.getElementById(section).style.display='block';
  document.getElementById('tabPomodoro').classList.remove('active');
  document.getElementById('tabCustom').classList.remove('active');
  if(section==='pomodoroSection') document.getElementById('tabPomodoro').classList.add('active');
  else document.getElementById('tabCustom').classList.add('active');
  updateDisplay();
}

//===== SAVE STATE =====
function saveState(){
    localStorage.setItem('timeLeft', timeLeft);
    localStorage.setItem('running', running);
    localStorage.setItem('currentMode', currentMode);
    localStorage.setItem('isCustom', isCustom);
}

// ========== INIT ==========
updateDisplay();
</script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
	<script src="assets/javascript/darkmode.js"></script>
	
	<jsp:include page="chatbot.jsp" />
</body>
</html>
