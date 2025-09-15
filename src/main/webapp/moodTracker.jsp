<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.alphaomen.model.*" %>
<%@ page import="com.alphaomen.dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*, com.alphaomen.db.DB" %>
<%@ page import="java.time.LocalDate, java.util.Map" %>
<%
User user = (User) session.getAttribute("user");
//Ads 
	int noteCount = 0;
	String userPlan = "guest";
	if (user!= null) {
		if(user.getPlanId() == 2) {
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
 
	if("free".equals(userPlan)) {
     AdDAO adDAO = new AdDAO();
     ads = adDAO.getActiveAds();
     for (Ad ad : ads) {
         switch(ad.getDisplayType().toLowerCase()) {
             case "banner": bannerAds.add(ad); break;
             case "sidebar": sidebarAds.add(ad); break;
             case "popup": popupAds.add(ad); break;
         }
     }
 }
	// End of Ads
	
    String selectedMonth = (String) request.getAttribute("selectedMonth");
    Map<String, String> moodHistory = (Map<String, String>) request.getAttribute("moodHistory");
    java.util.List<String> availableMonths = (java.util.List<String>) request.getAttribute("availableMonths");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Font Awesome (Optional for Icons) -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
.content { 
	margin-left: 220px; 
	padding: 20px; 
	width: 100%; 
}
.calendar-container {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.calendar-header {
    display: grid;
    grid-template-columns: repeat(7, 50px);
    gap: 5px;
    font-weight: bold;
    margin-bottom: 10px;
}

.calendar {
    display: grid;
    grid-template-columns: repeat(7, 50px);
    gap: 5px;
    justify-content: center;
}

.day {
	width: 50px; 
	height: 50px; 
	border-radius: 6px;
	display: flex; 
	align-items: center; 
	justify-content: center;
	background: #e9ecef;
}
/* Mood Selection Cards */
.mood-card {
    width: 120px;
    height: 150px;
    border-radius: 15px;
    border: none;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    font-size: 16px;
    color: #fff;
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.mood-card img.mood-icon {
    width: 60px;
    height: 60px;
    margin-bottom: 10px;
}
.mood-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 16px rgba(0,0,0,0.3);
}

/* Different mood colors */
.mood-card.happy { background: #FFD43B; }
.mood-card.sad { background: #74C0FC; }
.mood-card.angry { background: #FF6B6B; }
.mood-card.fear { background: #FF922B; }

.mood-buttons button {
margin: 5px; padding: 10px 15px; border-radius: 8px; cursor: pointer;
}

/* ===========================
   Additional Dark Mode CSS
   =========================== */
/* Dark mode for calendar */
body.dark-mode .calendar-container {
    background: var(--bg-body);
    padding: 10px;
    border-radius: 8px;
}

body.dark-mode .calendar-header div {
    color: var(--text-main);
}

body.dark-mode .calendar .day {
    background: #555; /* dark neutral */
    color: var(--text-light);
    border: 1px solid var(--border-color);
    border-radius: 6px;
}

body.dark-mode .calendar .day:hover {
    background: var(--color-primary);
    color: var(--text-dark);
}

body.dark-mode .calendar .day.selected {
    border: 3px solid var(--color-accent1);
}
/* Light mode: highlight today's date */
.calendar .day.selected-today {
    border: 3px solid #198754; /* green border */
    background: #d4edda; /* light green background */
}

/* Dark mode: highlight today's date */
body.dark-mode .calendar .day.selected-today {
    border: 3px solid #ffc107; /* amber border */
    background: #444; /* dark greenish background */
    color: #fff;
}

body.dark-mode .mood-card {
    filter: brightness(0.85); /* slightly darker mood cards */
    color: var(--text-light);
}

body.dark-mode .mood-card:hover {
    filter: brightness(1);
}

body.dark-mode .alert {
    background-color: #444;
    color: var(--text-light);
    border-color: var(--border-color);
}

body.dark-mode canvas#mooodChart {
    background: var(--bg-card);
}

body.dark-mode .mood-buttons p {
    color: var(--text-main);
}

body.dark-mode .banner,
body.dark-mode .banner a img {
    filter: brightness(0.9);
}

body.dark-mode .popup-ad {
    background: var(--bg-card);
    color: var(--text-main);
    border-color: var(--border-color);
}

/* ===========================
   Insights Section - Dark Mode
   =========================== */
body.dark-mode .insights-card {
    background: var(--bg-card);
    color: var(--text-main);
    border: 1px solid var(--border-color);
}

body.dark-mode .insights-card .card-header {
    background: var(--color-primary) !important;
    color: var(--text-light) !important;
}

body.dark-mode .insights-card .badge {
    background: var(--accent-slate-bg);
    color: var(--text-main);
}

body.dark-mode .progress {
    background: var(--accent-slate-bg);
}

body.dark-mode .progress-bar.bg-warning {
    background-color: #fbbf24 !important; 
    color: #000;
}

body.dark-mode .progress-bar.bg-secondary {
    background-color: #64748B !important; 
}

/* ===========================
   Offcanvas Sidebar - Dark Mode
   =========================== */
body.dark-mode .offcanvas {
    background-color: var(--bg-sidebar);
    color: var(--text-main);
}

body.dark-mode .offcanvas .offcanvas-header {
    background-color: var(--bg-topbar);
    border-bottom: 1px solid var(--border-color);
}

body.dark-mode .offcanvas .offcanvas-title {
    color: var(--text-main);
}

body.dark-mode .offcanvas .btn-close {
    filter: invert(1); /* makes the close button visible on dark bg */
}

body.dark-mode .offcanvas .nav-link {
    color: var(--text-main);
    transition: 0.2s;
}

body.dark-mode .offcanvas .nav-link:hover,
body.dark-mode .offcanvas .nav-link.active {
    background-color: var(--color-primary);
    color: var(--color-dark);
    border-radius: 8px;
}
/********************************************* Ads Style ************************************/
/* Sidebar Ads */
.sidebar .ad {
	width: 100%;
	max-width: 220px; 
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
                            <a class="nav-link" href="timer.jsp" id="timerToggle">
                                <i class="fa-solid fa-clock me-2"></i> Timer
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="MoodServlet">
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
                            <a class="nav-link" href="timer.jsp" id="timerToggle">
                                <i class="fa-solid fa-clock me-2"></i> Timer
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="MoodServlet">
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

            
		<h2 class="mb-4">Mood Tracker</h2>
		<!-- Mood Selection -->
		<div class="mood-buttons text-center">
		<%
		    if (user == null) {
		%>
		    <p>Please <a href="login.jsp">log in</a> to track your mood.</p>
		<%
		    } else {
		%>
			<p class="mb-3">Select mood for today:</p>
		    <form id="moodForm" method="post" action="MoodServlet" class="d-flex justify-content-center gap-3 flex-wrap">
		        <input type="hidden" name="action" value="addMood">
		        <input type="hidden" id="selectedDate" name="date" value="<%=java.time.LocalDate.now()%>">
		        <button type="submit" name="mood" value="Happy" class="mood-card happy">
					<img src="assets/images/happy.png" alt="Happy" class="mood-icon">
					<span>Happy</span>
				</button>
				<button type="submit" name="mood" value="Sad" class="mood-card sad">
		            <img src="assets/images/sad.png" alt="Sad" class="mood-icon">
		            <span>Sad</span>
		        </button>
				<button type="submit" name="mood" value="Angry" class="mood-card angry">
		            <img src="assets/images/angry.png" alt="Angry" class="mood-icon">
		            <span>Angry</span>
		        </button>
				<button type="submit" name="mood" value="Anxious" class="mood-card fear">
		            <img src="assets/images/anxious.png" alt="Anxious" class="mood-icon">
		            <span>Anxious</span>
		        </button>
		    </form>
		<%
    		}
		%>
		</div>

		<%
		// Month navigation
		    LocalDate today = LocalDate.now();
		    LocalDate start;
		    if (selectedMonth != null) {
		        start = LocalDate.parse(selectedMonth + "-01"); 
		    } else {
		        start = today.withDayOfMonth(1);
		    }
		    LocalDate prevMonth = start.minusMonths(1);
		    LocalDate nextMonth = start.plusMonths(1);
		%>
		
		<div class="calendar-container text-center mt-4">
		    <div class="d-flex justify-content-between align-items-center">
		        <form method="get" action="MoodServlet">
		            <input type="hidden" name="month" value="<%= prevMonth.getYear() + "-" + String.format("%02d", prevMonth.getMonthValue()) %>">
		            <button class="btn btn-outline-secondary">&laquo; Prev</button>
		        </form>
		        <h4><%= start.getMonth().name() %> <%= start.getYear() %></h4>
		        <form method="get" action="MoodServlet">
		            <input type="hidden" name="month" value="<%= nextMonth.getYear() + "-" + String.format("%02d", nextMonth.getMonthValue()) %>">
		            <button class="btn btn-outline-secondary">Next &raquo;</button>
		        </form>
		       </div>
		    <div class="calendar-header d-grid">
		        <div>Mon</div>
		        <div>Tue</div>
		        <div>Wed</div>
		        <div>Thu</div>
		        <div>Fri</div>
		        <div>Sat</div>
		        <div>Sun</div>
		    </div>
		    <div class="calendar">
		        <% 
		            int firstDay = start.getDayOfWeek().getValue(); // 1=Mon, 7=Sun
		            for (int i = 1; i < firstDay; i++) { 
		        %>
		            <div></div>
		        <% } %>
		        <% for (int i = 0; i < start.lengthOfMonth(); i++) {
		            LocalDate date = start.plusDays(i);
		            String mood = (moodHistory != null) ? moodHistory.getOrDefault(date.toString(), "") : "";
		            String color = "#e9ecef";
		            String icon = "";
		            if ("Happy".equals(mood)) { color = "yellow"; icon = "😊"; }
		            else if ("Sad".equals(mood)) { color = "lightblue"; icon = "😢"; }
		            else if ("Angry".equals(mood)) { color = "tomato"; icon = "😡"; }
		            else if ("Anxious".equals(mood)) { color = "orange"; icon = "😨"; }
		        	boolean isToday = date.equals(today);
		        %>
		            <button class="day <%= isToday ? "selected-today" : "" %>" type="button" data-date="<%=date%>" style="background:<%=color%>; color: #333;">
		                <%=date.getDayOfMonth()%> <%= icon %>
		            </button>
		        <% } %>
		    </div>
		</div>
		
		<%
		    String motivationQuote = (String) request.getAttribute("motivationQuote");
		    if(motivationQuote != null && !motivationQuote.isEmpty()) {
		%>
		<div class="alert alert-info mt-3">
		    <strong>Motivation for today:</strong> <%= motivationQuote %>
		</div>
		<% } %>
		
		<% if ("premium".equals(userPlan)) { %>
			<!-- Insights Section -->
			<div class="insights mt-5">
			    <h3 class="mb-4">🌟 Insights</h3>
			
			    <!-- Longest Streaks -->
			    <div class="card mb-4 shadow-sm">
			        <div class="card-header bg-primary text-white">
			            <h5 class="mb-0">Longest Streaks</h5>
			        </div>
			        <div class="card-body">
			            <div class="row">
			                <%
			                    Map<String, Integer> streaks = (Map<String, Integer>) request.getAttribute("streaks");
			                    if (streaks != null) {
			                        for (Map.Entry<String, Integer> e : streaks.entrySet()) {
			                %>
			                <div class="col-6 col-md-3 mb-3 text-center">
			                    <div class="badge rounded-pill bg-info fs-6 p-3 w-100">
			                        <strong><%= e.getKey() %></strong><br>
			                        <span class="fs-5"><%= e.getValue() %> days</span>
			                    </div>
			                </div>
			                <%      }
			                    }
			                %>
			            </div>
			        </div>
			    </div>
			
			    <!-- Monthly Stats -->
			    <div class="card shadow-sm">
			        <div class="card-header bg-success text-white">
			            <h5 class="mb-0">Monthly Stats</h5>
			        </div>
			        <div class="card-body">
			            <%
			                Map<String, Double> thisMonth = (Map<String, Double>) request.getAttribute("thisMonth");
			                Map<String, Double> lastMonth = (Map<String, Double>) request.getAttribute("lastMonth");
			                if (thisMonth != null) {
			                    for (String mood : thisMonth.keySet()) {
			                        double valThis = thisMonth.getOrDefault(mood, 0.0);
			                        double valLast = lastMonth != null ? lastMonth.getOrDefault(mood, 0.0) : 0.0;
			            %>
			            <div class="mb-3">
			                <div class="d-flex justify-content-between">
			                    <strong><%= mood %></strong>
			                    <span>This: <%= String.format("%.1f", valThis) %>%, Last: <%= String.format("%.1f", valLast) %>%</span>
			                </div>
			                <div class="progress" style="height: 20px;">
			                    <div class="progress-bar bg-warning" role="progressbar" style="width: <%= valThis %>%;" aria-valuenow="<%= valThis %>" aria-valuemin="0" aria-valuemax="100">
			                        <%= String.format("%.1f", valThis) %>%
			                    </div>
			                    <div class="progress-bar bg-secondary" role="progressbar" style="width: <%= valLast %>%;" aria-valuenow="<%= valLast %>" aria-valuemin="0" aria-valuemax="100">
			                        <%= String.format("%.1f", valLast) %>%
			                    </div>
			                </div>
			            </div>
			            <%      }
			                }
			            %>
			        </div>
			    </div>
			</div>
			<% } %>

		<!-- Mood History Chart -->
		<!--  <canvas id="moodChart" width="200" height="200"></canvas>  -->
	<!-- Recent Mood History -->
	<div class="card shadow-sm mt-4">
	    <div class="card-header bg-info text-white">
	        <h5 class="mb-0">🕒 Recent Mood History</h5>
	    </div>
	    <div class="card-body" style="max-height: 200px; overflow-y: auto;">
	        <table class="table table-striped table-hover mb-0">
	            <thead class="table-light">
	                <tr>
	                    <th>Date</th>
	                    <th>Mood</th>
	                </tr>
	            </thead>
	            <tbody>
	                <c:forEach var="entry" items="${history}">
	                    <tr>
	                        <td>${entry.date}</td>
	                        <td>
	                            <span class="badge 
	                                <c:choose>
	                                    <c:when test="${entry.mood == 'Happy'}">bg-success</c:when>
	                                    <c:when test="${entry.mood == 'Sad'}">bg-primary</c:when>
	                                    <c:when test="${entry.mood == 'Angry'}">bg-danger</c:when>
	                                    <c:when test="${entry.mood == 'Anxious'}">bg-warning text-dark</c:when>
	                                    <c:otherwise>bg-secondary</c:otherwise>
	                                </c:choose>
	                            ">
	                                ${entry.mood}
	                            </span>
	                        </td>
	                    </tr>
	                </c:forEach>
	            </tbody>
	        </table>
	    </div>
	</div>
	
	</main>
	</div> <!-- End of row -->
</div> <!-- End of container fluid -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
	<script src="assets/javascript/darkmode.js"></script>
	<script>
		const ctx = document.getElementById('moodChart').getContext('2d');
		const moodData = JSON.parse('<%= request.getAttribute("moodChartData") %>');
		new Chart(ctx, {
			type: 'bar',
			data: {
				labels: moodData.labels,
				datasets: [{
					label: 'Mood History',
					data: moodData.values,
					backgroundColor: moodData.colors
				}]
			}
		});
		const dayButtons = document.querySelectorAll('.calendar .day');
		const selectedDateInput = document.getElementById('selectedDate');

		dayButtons.forEach(btn => {
		    btn.addEventListener('click', () => {
		        selectedDateInput.value = btn.getAttribute('data-date'); 
		        // Remove highlight from all
		        dayButtons.forEach(b => b.classList.remove('selected'));
		        btn.classList.add('selected'); // highlight selected day
		    });
		});

	</script>
	<jsp:include page="chatbot.jsp" />
</body>
</html>

