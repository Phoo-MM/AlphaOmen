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
/* ===========================
   Hero Box & Stats
   =========================== */
.hero-box {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  margin-bottom: 20px;
  border-radius: 16px;
  background: var(--color-primary);
  color: var(--color-dark);
}

body.dark-mode .hero-box {
  background: var(--accent-slate); 
  color: var(--text-light);
}

.stat-box {
  background: var(--bg-card);
  color: var(--text-main);
  border-radius: 20px;
  padding: 20px 15px;
  text-align: center;
  box-shadow: 0 6px 15px rgba(0,0,0,0.08);
}

.stat-box .icon-circle {
  width: 70px;
  height: 70px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 12px;
}
.stat-notes   .icon-circle { background: var(--accent-blue-bg);   color: var(--accent-blue); }
.stat-cats    .icon-circle { background: var(--accent-slate-bg);  color: var(--accent-slate); }
.stat-plan    .icon-circle { background: var(--accent-amber-bg);  color: var(--accent-amber); }
.stat-overdue .icon-circle { background: var(--accent-pink-bg);   color: var(--accent-pink); }
/* ===========================
   Notes Section
   =========================== */
.note-section {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 20px;
}

.mynotes {
  width: 100%;
  height: 220px;
  background: var(--bg-card);
  color: var(--text-main);
  border-radius: 16px;
  padding: 15px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  cursor: grab;
  position: relative;
  overflow: hidden;
}

.mynotes:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 18px rgba(0,0,0,0.12);
}

.mynotes.pinned {
  border: 3px solid var(--color-primary);
}


.mynotes.upcoming {
  border: 2px dashed var(--text-muted);
}
.note-content {
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 7;
  -webkit-box-orient: vertical;
  word-wrap: break-word;
  cursor: pointer;
}

.note-category {
  position: absolute;
  bottom: 8px;
  right: 8px;
  background-color: var(--color-primary);
  color: var(--text-dark);
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 600;
}

.note-due {
  position: absolute;
  top: 15px;
  right: 8px;
  background-color: var(--accent-amber-bg);
  color: var(--accent-amber);
  padding: 2px 6px;
  border-radius: 8px;
  font-size: 0.8rem;
  font-weight: 600;
  z-index: 10;
}

.voice-icon {
  color: #f39c12;
  cursor: pointer;
}

body.dark-mode .mynotes {
  background: var(--bg-card);
  color: var(--text-main);
  box-shadow: 2px 2px 10px rgba(0,0,0,0.4);
}

/* ===========================
   Hero Section (for guest users)
   =========================== */
.hero {
  background: linear-gradient(135deg, #54a0ff 0%, #74b9ff 100%);
  color: #fff;
  border-radius: 20px;
  margin-top: 60px;
  padding: 50px 40px;
  text-align: center;
  box-shadow: 0 10px 30px rgba(0,0,0,0.1);
}

.hero h1 {
  font-size: 2.5rem;
  font-weight: 700;
}

.hero p {
  font-size: 1.1rem;
  margin-bottom: 25px;
}

.hero .btn {
  margin: 5px;
  padding: 12px 28px;
  border-radius: 50px;
  font-weight: 600;
}

/* ===========================
   Feature Cards
   =========================== */
.feature-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 25px;
  border-radius: 20px;
  box-shadow: 0 8px 20px rgba(0,0,0,0.05);
  transition: transform 0.3s, box-shadow 0.3s;
}

.feature-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 25px rgba(0,0,0,0.15);
}

.feature-card i {
  font-size: 2rem;
  color: #54a0ff;
  margin-bottom: 15px;
}

.feature-card p {
	color: var(--text-main);
	}
/* ===========================
   Responsive Adjustments
   =========================== */
@media (max-width: 768px) {
  .note-section {
    grid-template-columns: 1fr;
  }

  .mynotes {
    min-height: 150px;
  }

  .hero-box {
    flex-direction: column;
    text-align: center;
  }

  .hero-box .hero-img img {
    max-width: 100px;
    margin-top: 10px;
  }
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

/* Default: show light logo, hide dark */
.logo-light {
  display: block;
}
.logo-dark {
  display: none;
}

/* When dark mode is active */
body.dark-mode .logo-light {
  display: none;
}
body.dark-mode .logo-dark {
  display: block;
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
                    	<!-- Light logo -->
                        <img src="assets/images/alphaomen3.png" alt="AlphaOmen-Logo"
                             class="logo-light img-fluid" width="150">
                             
                        <!-- Dark logo -->
                        <img src="assets/images/alphaomen_dark.png" alt="AlphaOmen-Logo"
                             class="logo-dark img-fluid" width="150">
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
                            <a class="nav-link active" href="index.jsp">
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
                    <!-- Logo -->
                    <div class="text-center mb-4">
                    	<!-- Light logo -->
                        <img src="assets/images/alphaomen3.png" alt="AlphaOmen-Logo"
                             class="logo-light img-fluid" width="150">
                             
                        <!-- Dark logo -->
                        <img src="assets/images/alphaomen_dark.png" alt="AlphaOmen-Logo"
                             class="logo-dark img-fluid" width="150">
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
                            <a class="nav-link active" href="index.jsp">
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
		if (user == null) {
		%>
		<!-- Add Hero + Features from second snippet -->
		<div class="hero">
			<h1>Welcome to AlphaOmen 🎉</h1>
			<p>Boost your productivity, organize tasks, track your mood, and
				stay focused—all in one place.</p>
			<a href="signup.jsp" class="btn btn-light text-primary">Get
				Started</a> <a href="login.jsp" class="btn btn-outline-light">Login</a>
		</div>

		<section class="what-you-can-do mt-5">
			<h2>What You Can Do</h2>
			<div class="row g-4 justify-content-center">
				<div class="col-md-4">
					<a href="javascript:void(0)" data-bs-toggle="modal"
						data-bs-target="#loginRequiredModal" class="text-decoration-none">
						<div class="feature-card">
							<i class="fa-solid fa-pen-to-square"></i>
							<h5>Organize Notes</h5>
							<p>Create, edit, and organize your notes efficiently with
								tags and categories.</p>
						</div>
					</a>
				</div>
				<div class="col-md-4">
					<a href="javascript:void(0)" data-bs-toggle="modal"
						data-bs-target="#loginRequiredModal" class="text-decoration-none">
						<div class="feature-card">
							<i class="fa-solid fa-tags"></i>
							<h5>Manage Categories</h5>
							<p>Keep your tasks and notes neatly categorized for better
								organization.</p>
						</div>
					</a>
				</div>
				<div class="col-md-4">
					<a href="javascript:void(0)" data-bs-toggle="modal"
						data-bs-target="#loginRequiredModal" class="text-decoration-none">
						<div class="feature-card">
							<i class="fa-solid fa-clock"></i>
							<h5>Timers & Focus</h5>
							<p>Stay on track with focus timers and reminders for every
								task.</p>
						</div>
					</a>
				</div>
				<div class="col-md-4">
					<a href="javascript:void(0)" data-bs-toggle="modal"
						data-bs-target="#loginRequiredModal" class="text-decoration-none">
						<div class="feature-card">
							<i class="fa-solid fa-face-smile"></i>
							<h5>Mood Tracker</h5>
							<p>Track your emotions and daily well-being to stay balanced.</p>
						</div>
					</a>
				</div>
				<div class="col-md-4">
					<a href="javascript:void(0)" data-bs-toggle="modal"
						data-bs-target="#loginRequiredModal" class="text-decoration-none">
						<div class="feature-card">
							<i class="fa-solid fa-robot"></i>
							<h5>Smart Assistant</h5>
							<p>Ask questions and get help from our AI-powered assistant
								anytime.</p>
						</div>
					</a>
				</div>
			</div>
		</section>

		<footer class="mt-5">
			<p>
				© 2025 AlphaOmen. All rights reserved. | <a
					href="javascript:void(0)" data-bs-toggle="modal"
					data-bs-target="#loginRequiredModal">Access Features</a>
			</p>
		</footer>

		<%
		}
		%>

				<%
		if (user != null) { // logged-in user
			int userTagCount = noteDAO.getTagCountByUser(user.getId());
			int userNoteCount = noteDAO.getNoteCountByUser(user.getId());
		%>
		
		<!-- Dashboard Section -->
		<div class="hero-box p-4 mb-4 rounded" style=" border-radius:16px;">
		   <!-- Left content -->
		  <div>
		    <h2>Hi, <%= user != null ? user.getUsername() : "User" %> 👋</h2>
		    <p class="mb-0">Ready to start your day with some notes?</p>
		  </div>
		
		  <!-- Right image -->
		  <div class="hero-img">
		    <img src="assets/images/home.png" alt="Welcome" style="width:120px; height:auto; border-radius:12px;">
		  </div>
		
		</div>
		<!-- Stats Boxes -->
<div class="row mb-4 g-3">
  <!-- Total Notes -->
  <div class="col-md-3 col-6">
    <div class="stat-box text-center p-3 rounded">
      <div class="icon-circle" style="background:#ffecb3; color:#ff9800;">
        <i class="fa-solid fa-note-sticky"></i>
      </div>
      <h3><%= userNoteCount %></h3>
      <p>Total Notes</p>
    </div>
  </div>

  <!-- Total Categories -->
  <div class="col-md-3 col-6">
    <div class="stat-box text-center p-3 rounded">
      <div class="icon-circle" style="background:#bbdefb; color:#42a5f5;">
        <i class="fa-solid fa-tags"></i>
      </div>
      <h3><%= userTagCount %></h3>
      <p>Total Categories</p>
    </div>
  </div>

  <!-- Account Type -->
  <div class="col-md-3 col-6">
    <div class="stat-box text-center p-3 rounded">
      <div class="icon-circle" style="background:#ffcdd2; color:#ef5350;">
        <i class="fa-solid fa-crown"></i>
      </div>
      <h3><%= userPlan.equals("premium") ? "Premium" : "Free" %></h3>
      <p>Account Type</p>
    </div>
  </div>

  <!-- Overdue Notes -->
  <div class="col-md-3 col-6">
    <div class="stat-box text-center p-3 rounded">
      <div class="icon-circle" style="background:#e1bee7; color:#ab47bc;">
        <i class="fa-solid fa-clock"></i>
      </div>
      <h3>
        <%= notes.stream().filter(n -> n.getDueDate() != null && n.getDueDate().before(new java.util.Date())).count() %>
      </h3>
      <p>Overdue Notes</p>
    </div>
  </div>
</div>


		<!-- Notes Display Section in Two Columns (Pinned + Upcoming) -->
		<div class="notes-row-section row">
			<!-- Pinned Notes Column -->
			<div class="col-md-6">
				<h3>Pinned Notes</h3>
				<div class="note-section">
				<%
				for (Note n : pinnedNotes) {
				%>
				<div class="note-actions draggable-note mb-3">
					<div class="mynotes" style="border: 5px solid <%= n.getColor() != null ? n.getColor() : "#000000" %>;">
						<!-- Category badge top-right -->
					        <% if (n.getTagName() != null) { %>
					            <div class="note-category"><%= n.getTagName() %></div>
					        <% } %>
						
						<!-- Note content -->
				        <div class="note-content" onclick="window.location.href='editNote.jsp?note_id=<%= n.getNoteId() %>';">
				            <% if (n.isPinned()) { %>
				                <i class="fa-solid fa-thumbtack"></i>
				            <% } %>
				            <p class="note-text"><%= n.getContent() %></p>
				
				            <!-- Voice icon -->
				            <% if (n.getVoiceNotePath() != null && !n.getVoiceNotePath().isEmpty()) { %>
				                <i class="fa-solid fa-microphone voice-icon" title="Voice Note" style="position:absolute; bottom:8px; left:8px;"></i>
				            <% } %>
				
				            <!-- Due date badge -->
				            <% if (n.getDueDate() != null) { %>
				                <div class="note-due" title="Due Date: <%= n.getDueDate() %>">
				                    <%= n.getDueDate() %>
				                </div>
				            <% } %>
				        </div>
				</div>
                <p class="note-label mt-1"><%= n.getTitle() %></p>
            </div>
        <%
        }
        %>
        </div>
    </div>

			<!-- Upcoming Notes Column -->
			<div class="col-md-6">
				<h3>Upcoming Due Dates</h3>
        <div class="note-section">
        <%
        for (Note n : upcomingNotes) {
        %>
            <div class="note-actions draggable-note mb-3">
                <div class="mynotes" style="border: 2px dashed orange;">
                    <!-- Category badge top-right -->
					        <% if (n.getTagName() != null) { %>
					            <div class="note-category"><%= n.getTagName() %></div>
					        <% } %>
						
						<!-- Note content -->
				        <div class="note-content" onclick="window.location.href='editNote.jsp?note_id=<%= n.getNoteId() %>';">
				            <% if (n.isPinned()) { %>
				                <i class="fa-solid fa-thumbtack"></i>
				            <% } %>
				            <p class="note-text"><%= n.getContent() %></p>
				
				            <!-- Voice icon -->
				            <% if (n.getVoiceNotePath() != null && !n.getVoiceNotePath().isEmpty()) { %>
				                <i class="fa-solid fa-microphone voice-icon" title="Voice Note" style="position:absolute; bottom:8px; left:8px;"></i>
				            <% } %>
				
				            <!-- Due date badge -->
				            <% if (n.getDueDate() != null) { %>
				                <div class="note-due" title="Due Date: <%= n.getDueDate() %>">
				                    <%= n.getDueDate() %>
				                </div>
				            <% } %>
				        </div>    
                </div>
                <p class="note-label mt-1"><%= n.getTitle() %></p>
            </div>
        <%
        }
        %>
        </div>
    </div>

</div>

		<%
		} else { // guest user
		%>
		<p>
			Please <a href="login.jsp">login</a> to view your notes, track your
			mood, and manage your tasks.
		</p>
		<p>
			Or <a href="signup.jsp">sign up</a> to start organizing your notes!
		</p>
		<%
		}
		%>

		</main> 
		</div> <!-- End of row -->
		</div> <!-- End of container fluid -->


	<!-- Login Required Modal -->
	<div class="modal fade" id="loginRequiredModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content border-0">
				<div class="modal-header bg-warning-subtle">
					<h5 class="modal-title">Login Required</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					You need to <strong>log in</strong> or <strong>sign up</strong> to
					use this feature.
				</div>
				<div class="modal-footer">
					<a href="login.jsp" class="btn btn-outline-primary btn-pill">Login</a>
					<a href="signup.jsp" class="btn btn-primary btn-pill">Sign Up</a>
				</div>
			</div>
		</div>
	</div>


	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
	<script src="assets/javascript/darkmode.js"></script>
	<jsp:include page="chatbot.jsp" />
</body>
</html>
