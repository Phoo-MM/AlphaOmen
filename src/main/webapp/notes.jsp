<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.alphaomen.model.*" %>
<%@ page import="com.alphaomen.dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*, com.alphaomen.db.DB" %>
<%@ page import="java.time.LocalDate, java.util.Map" %>
<%
	User user = (User) session.getAttribute("user");

	// Ads 
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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Font Awesome (Optional for Icons) -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

<link rel="stylesheet" href="assets/css/style.css">

<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
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


.sortable-ghost {
	opacity: 0.5;
	border: 2px dashed #000;
}

.draggable-note {
	display: flex;
	cursor: grab;
}

.draggable-note:active {
	cursor: grabbing;
}

/* ===========================
   Filter Section
   =========================== */
.filter-section {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  background-color: #90d6ff;
  padding: 16px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  margin-bottom: 30px;
}

.filter-section form {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
}

.filter-section input,
.filter-section select {
  min-width: 140px;
  border-radius: 8px;
  padding: 8px;
}

.filter-section button {
  min-width: 140px;
  background-color: #004aad;
  padding: 8px;
  margin-top: 10px;
  color: white;
  border-radius: 30px;
  transition: 0.3s;
}

.filter-section button:hover {
  background-color: #ffc107;
  color: black;
}

body.dark-mode .filter-section {
  background: #03346E;
}

/* ===========================
   Notes Section
   =========================== */
.note-section {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
}
.note-actions {
    display: flex;
    flex-direction: column; 
    align-items: center;   
    margin-bottom: 20px;   
}
.create-box {
    flex: 0 0 220px;
}
.create-note {
    width: 290px;
    height: 220px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 3rem;
    cursor: pointer;
    transition: 0.3s;
}
.note-label {
    margin-top: 8px;
    font-weight: 600;
    text-align: center;
}
/* Category label at bottom-right of note */
.note-category {
    position: absolute;
    bottom: 8px;
    right: 8px;
    background-color: #0d6efd;
    color: white;
    padding: 2px 8px;
    border-radius: 12px;
    font-size: 0.75rem;
    font-weight: 600;
}
body.dark-mode .note-category {
  background: #555;
  color: #f0f0f0;
}
/* Voice icon styling */
.voice-icon {
    display: inline-block;
    margin-left: 5px;
    color: #f39c12;
    cursor: pointer;
    font-size: 1rem;
    vertical-align: middle;
}
.voice-icon:hover {
    color: #e67e22;
}

/* ---------- Sticky Note Style ---------- */
.sticky .create-note {
    background: #fff9b1;
    border: 2px dashed #f1e38d;
}
.sticky .create-note:hover {
    background: #fff6a0;
}
.sticky .mynotes {
    width: 290px;
    height: 220px;
    overflow: hidden;
    background: #fff9b1;
    border-radius: 12px;
    padding: 15px;
    box-shadow: 4px 4px 12px rgba(0,0,0,0.15);
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    font-family: 'Comic Sans MS', cursive, sans-serif;
    position: relative;
    cursor: grab;
    transition: transform 0.5s ease, box-shadow 0.5s ease, background 0.5s ease;
}
.sticky .mynotes:hover {
    transform: translateY(-5px) rotate(-1deg);
    box-shadow: 6px 6px 18px rgba(0,0,0,0.2);
}
body.dark-mode .sticky .mynotes {
  background: #E6D27A;
  color: #1E293B; 
}

/* ---------- Modern Card Style ---------- */
.modern .create-note {
    background: #f9f9f9;
    border: 2px dashed #bbb;
}
.modern .create-note:hover {
    background: #eef6ff;
    border-color: #0d6efd;
    color: #0d6efd;
}
.modern .mynotes {
    width: 290px;
    height: 220px;
    background: var(--bg-card);
    color: var(--text-main);
    position: relative;
    overflow: hidden;
    background: #ffffff;
    border-radius: 16px;
    padding: 15px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    transition: transform 0.5s ease, box-shadow 0.5s ease, background 0.5s ease;
    cursor: grab;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}
.modern .mynotes:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 18px rgba(0,0,0,0.12);
}
.modern .note-label {
    color: #5C6BC0; 
}
body.dark-mode .modern .mynotes {
  background: #2c2c2c;
  color: #f0f0f0;
}
body.dark-mode .sticky .mynotes .note-content,
body.dark-mode .sticky .mynotes .note-text {
    color: #1E293B;
}

body.dark-mode .modern .mynotes .note-content,
body.dark-mode .modern .mynotes .note-text {
    color: #1E293B;
}

/* ---------- Common Note Styles ---------- */
.note-content {
	overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 7; /* number of lines to show */
    -webkit-box-orient: vertical;
    word-wrap: break-word;
    cursor: pointer;
    color: black;
}
.note-content i {
    color: #f39c12;
    margin-right: 5px;
}
.note-text {
    margin: 6px 0;
    font-size: 0.9rem;
    word-wrap: break-word;
    color: black;
}
.mynotes button {
    display: none;
}
.note-due {
    position: absolute;
    top: 0;
    right: 0;
    background-color: #ffecb3; /* soft yellow for sticky */
    color: #333;
    padding: 2px 3px;
    border-radius: 8px;
    font-size: 0.7rem;
    font-weight: 600;
    z-index: 10;
}

/* Highlight warning for near due date */
.note-due .due-warning {
    color: red;
    font-weight: bold;
    margin-left: 4px;
}

/* Dark mode version */
body.dark-mode .note-due {
    background-color: #7a6a5f; 
    color: #f0f0f0;
}

body.dark-mode .note-due .due-warning {
    color: #ff6b6b;
}

/* ==================== Notes Section Dark Mode ==================== */

body.dark-mode .sticky .create-note {
    background: #E6D27A;          
    border: 2px dashed #C9B86E;   
    color: var(--text-dark);      
}
body.dark-mode .sticky .create-note:hover {
    background: #EAD97F;           
}


body.dark-mode .sticky .mynotes:hover {
    transform: translateY(-5px) rotate(-1deg);
    box-shadow: 6px 6px 18px rgba(0,0,0,0.5);
}
body.dark-mode .sticky .note-content i {
    color: #f1c40f; 
}


body.dark-mode .modern .create-note {
    background: #2c2c2c;
    border: 2px dashed #555;
    color: var(--text-main);
}
body.dark-mode .modern .create-note:hover {
    background: #3a3a3a;
    border-color: #0d6efd;
    color: #0d6efd;
}

body.dark-mode .modern .mynotes:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 18px rgba(0,0,0,0.4);
}
body.dark-mode .modern .note-label {
    color: #a3c4ff;
}
body.dark-mode .modern .note-content i {
    color: #f39c12;
}

/* Ensure note buttons visible if needed */
body.dark-mode .mynotes button {
    color: var(--text-main);
    background: var(--bg-card);
    border: 1px solid var(--border-color);
}


body.dark-mode .create-note {
    color: var(--text-main);
}

/* ==================== Filter Section ==================== */

body.dark-mode .filter-section {
    background: #03346E; 
    box-shadow: 0 4px 12px rgba(0,0,0,0.15), 0 6px 20px rgba(0,0,0,0.1);
}


#styleToggle{
	 
	background-color:#ffc107;
	border-radius: 15px; 
	padding: 10px;
	color: black;
	font-weight: bold;
	
}

#styleToggle:hover{
	background-color:  #004aad; 
	border-radius: 15px; 
	color: white;
	padding: 10px;
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
body.dark-mode .popup-ad {
  background: #2c2c2c;
  color: #f0f0f0;
  border: 2px solid #888;
}

/********************************************* Ads End ************************************/
body.dark-mode .form-control,
body.dark-mode .form-select {
  background-color: #1e293b;
  color: #f0f0f0;
  border: 1px solid #555;
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
                            <a class="nav-link active" href="notes.jsp">
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
                            <a class="nav-link active" href="notes.jsp">
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
        // Logged-in user: fetch notes
        NoteDAO noteDAO = new NoteDAO();
		List<Note> notes = new ArrayList<>();
		List<Tag> tags = new ArrayList<>();
		if (user != null) {
		    tags = noteDAO.getTagsByUser(user.getId());
		}
		
        if (user != null) {
        	int userId = user.getId();
	        String searchText = request.getParameter("searchText");
	        String category = request.getParameter("category");
	        String pinned = request.getParameter("pinned");
	        String sortBy = request.getParameter("sortBy");

            if ((searchText == null || searchText.isEmpty()) &&
                (category == null || category.isEmpty()) &&
                (pinned == null || pinned.isEmpty()) &&
                (sortBy == null || sortBy.isEmpty())) {
                notes = noteDAO.getNotesByUser(userId);
            } else {
                notes = noteDAO.getNotesByUserFiltered(userId, searchText, category, pinned, sortBy);
            }
        }

%>

		<div class="filter-section mb-3">
		    <form action="notes.jsp" method="get" class="row g-2 align-items-center">
		    <div class="col-md-3 col-12">
		    	<input type="text" class="form-control form-control-sm" name="searchText" placeholder="Search notes"
		                value="<%= request.getParameter("searchText") != null ? request.getParameter("searchText") : "" %>">
			</div>
			<div class="col-md-2 col-6">
		        <select class="form-select form-select-sm" name="category">
		        <option value="">All Categories</option>
		        <%
		        	String selectedTag = request.getParameter("category");
		            for(Tag tag : tags) {
		        %>
		            <option value="<%=tag.getName()%>" <%= selectedTag != null && tag.getName().equals(selectedTag) ? "selected" : "" %>>
		            <%=tag.getName()%></option>
		         <% } %>
		        </select>
		    </div>
				 <div class="col-md-2 col-6">
		            <select class="form-select form-select-sm" name="pinned">
		                <option value="">All</option>
		                <option value="1" <%= "1".equals(request.getParameter("pinned")) ? "selected" : "" %>>Pinned</option>
		                <option value="0" <%= "0".equals(request.getParameter("pinned")) ? "selected" : "" %>>Not Pinned</option>
		            </select>
		         </div>

		         <div class="col-md-2 col-6">
            		<select class="form-select form-select-sm" name="sortBy">
		                <option value="">Sort By</option>
		                <option value="title" <%= "title".equals(request.getParameter("sortBy")) ? "selected" : "" %>>Title</option>
		                <option value="duedate" <%= "duedate".equals(request.getParameter("sortBy")) ? "selected" : "" %>>Due Date</option>
		                <option value="category" <%= "category".equals(request.getParameter("sortBy")) ? "selected" : "" %>>Category</option>		            	
		            </select>
		         </div>

		         <div class="col-md-2 col-6">
		            <button type="submit" class="btn btn-primary btn-sm w-100">Apply</button>
		        </div>
		    </form>
		</div>
			

		<!-- Section Heading -->
		<div class="d-flex justify-content-between align-items-center mb-3">
		    <h2 class="text-primary m-0">Your Notes</h2>
		    <button id="styleToggle" class="btn btn-sm btn-outline-secondary">
		        Switch to Modern Card
		    </button>
		</div>
		
		<div class="note-section" id="note-section">
		    <!-- Create new note box -->
		    <div class="note-actions create-box">
			    <div class="create-note">
			        <%
			            if (user != null) {
			                int currentNoteCount = noteDAO.getNoteCountByUser(user.getId());
			                int maxNotes = "premium".equals(userPlan) ? Integer.MAX_VALUE : 15; // same as NoteDAO limit
			                Integer noteLimitReached = (Integer) session.getAttribute("noteLimitReached");

			                if (currentNoteCount >= maxNotes) {
			                    session.setAttribute("noteLimitReached", 1);
			            %>
			                <script>
			                    document.querySelector('.create-note').onclick = function() {
			                        var limitModal = new bootstrap.Modal(document.getElementById('noteLimitReachedModal'));
			                        limitModal.show();
			                    };
			                </script>
			            <%
			                } else {
			                    session.setAttribute("noteLimitReached", 0);
			            %>
			                <script>
			                    document.querySelector('.create-note').onclick = function() {
			                        window.location.href = 'newNote.jsp';
			                    };
			                </script>
			            <%
			                }
			            } else {
			        %>
			                <script>
			                    document.querySelector('.create-note').onclick = function() {
			                        alert('Please log in first.');
			                        window.location.href = 'login.jsp';
			                    };
			                </script>
			        <%
			            }
			        %>
			        <span>+</span>
			    </div>
			    <p class="note-label">Create new note</p>
			</div>

			
			<!-- User notes -->
        <%
            if (user != null) {
                if (notes.isEmpty()) {
        %>
                    <p>No notes found.</p>
        <%
                } else {
                    notes.sort((a, b) -> Boolean.compare(b.isPinned(), a.isPinned()));
                    java.util.Date today = new java.util.Date();
                    for (Note notee : notes) {
                        String dueDateWarning = "";
                        if (notee.getDueDate() != null) {
                            long diff = notee.getDueDate().getTime() - today.getTime();
                            long daysLeft = diff / (1000 * 60 * 60 * 24);
                            if (daysLeft < 0) dueDateWarning = "⚠️ Overdue!";
                            else if (daysLeft == 0) dueDateWarning = "⏰ Today is Due Date!";
                            else if (daysLeft <= 2) dueDateWarning = "⏰ Only " + daysLeft + " day" + (daysLeft == 1 ? "" : "s") + " left!";
                        }
        %>
                        <div class="note-actions draggable-note">
                            <div class="mynotes" style="border: 5px solid <%= notee.getColor() != null ? notee.getColor() : "#000000" %>;" onclick="window.location.href='editNote.jsp?note_id=<%= notee.getNoteId() %>';">
                                
                                 <!-- Category badge at top-right -->
							        <% if (notee.getTagName() != null) { %>
							            <div class="note-category"><%= notee.getTagName() %></div>
							        <% } %>
                                
                                <div class="note-content">
                                    <% if (notee.isPinned()) { %>
                                        <i class="fa-solid fa-thumbtack"></i>
                                    <% } %>
                                    <p class="note-text"><%= notee.getContent() %></p>
                                    
                                    
                                    <!-- Voice icon if voice file exists -->
						            <% if (notee.getVoiceNotePath() != null && !notee.getVoiceNotePath().isEmpty()) { %>
						                <i class="fa-solid fa-microphone voice-icon" title="Voice Note" style="position:absolute; bottom:8px; left:8px;"></i>
						            <% } %>
						
						            <% if (notee.getDueDate() != null) { %>
									    <div class="note-due" title="Due Date: <%= notee.getDueDate() %>">
									        <%= notee.getDueDate() %>
									        <% if (!dueDateWarning.isEmpty()) { %>
									            <span class="due-warning"><%= dueDateWarning %></span>
									        <% } %>
									    </div>
									<% } %>

						        </div>
                                <form action="note" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="note_id" value="<%= notee.getNoteId() %>">
                                    <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                </form>
                            </div>
                            <p class="note-label"><%= notee.getTitle() %></p>
                        </div>
        <%
                    } // end for
                } // end else
        %>

        <%
        	} else { // guest user
        %>
            <p>Please <a href="login.jsp">log in</a> to see your notes.</p>
        <%
            }
        %>
    </div> <!-- note-section -->
    
            <%-- Popup Ads (after 5 notes) --%>
    <% if("free".equals(userPlan) && !popupAds.isEmpty()) {
    	Integer lastPopupCount = (Integer) session.getAttribute("lastPopupCount");
    	if(lastPopupCount == null) lastPopupCount = 0;
    	
    	// actual note count from the loaded notes
    	noteCount = notes.size();
    	if (noteCount >= lastPopupCount+  5) {
    		session.setAttribute("lastPopupCount", noteCount);
    		Ad ad = popupAds.get(0);
    %>
		<div class="popup-ad" id="popupAd">
		    <% if(ad.getImageUrl() != null && !ad.getImageUrl().isEmpty()) { %>
			    <img src="<%= ad.getImageUrl() %>" alt="<%= ad.getTitle() %>">
			<% } else { %>
			    <p><%= ad.getTitle() %></p>
			<% } %>
		    <p><%= ad.getContent() %></p>
		    <% if(ad.getLinkUrl() != null && !ad.getLinkUrl().isEmpty()) { %>
		        <a href="<%= ad.getLinkUrl() %>" target="_blank">Learn more</a>
		    <% } %>
		    <button onclick="document.getElementById('popupAd').style.display='none'" class="btn btn-sm btn-primary mt-2">Close</button>
		</div>
		<script>
		    document.getElementById("popupAd").style.display = "block";
		    </script>
		    <%  } // end noteCount check   
    	} %>
		   <%--End of Popup Ads --%>
    
    </main>
    </div> <!-- End of row -->
</div> <!-- End of container fluid -->

	<!-- Limit Reached Modal -->
	<div class="modal fade" id="noteLimitReachedModal" tabindex="-1" aria-labelledby="noteLimitReachedModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title text-danger" id="noteLimitReachedModalLabel">Limit Reached</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	      </div>
	      <div class="modal-body">
	        Free plan allows only 15 notes. Upgrade to Premium to add more.
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
	        <a href="purchasePlan.jsp" class="btn btn-primary">Upgrade</a>
	      </div>
	    </div>
	  </div>
	</div>
<script>
var noteSection = document.getElementById('note-section');

// Load saved style from localStorage
var savedStyle = localStorage.getItem('noteStyle');
if (savedStyle) {
    document.body.classList.remove('sticky', 'modern');
    document.body.classList.add(savedStyle);
    document.getElementById('styleToggle').textContent =
        savedStyle === 'sticky' ? "Switch to Modern Card" : "Switch to Sticky Note";
}

// Load saved note order from localStorage
var savedOrder = JSON.parse(localStorage.getItem('noteOrder'));
if (savedOrder) {
    savedOrder.forEach(id => {
        var note = document.getElementById(id);
        if (note) noteSection.appendChild(note);
    });
}

// Initialize Sortable
Sortable.create(noteSection, {
    animation: 150,
    handle: '.mynotes',
    ghostClass: 'sortable-ghost',
    draggable: '.draggable-note',
    filter: '.create-box',
    onEnd: function(evt) {
        console.log('Note moved from index', evt.oldIndex, 'to', evt.newIndex);

        // Save new order
        var order = Array.from(noteSection.children)
                         .filter(el => el.classList.contains('draggable-note'))
                         .map(el => el.id);
        localStorage.setItem('noteOrder', JSON.stringify(order));
    }
});

// Style Toggle with smooth fade animation
var styleToggleBtn = document.getElementById('styleToggle');
styleToggleBtn.addEventListener('click', function() {
    noteSection.style.opacity = 0; // fade out
    setTimeout(function() {
        if (document.body.classList.contains('sticky')) {
            document.body.classList.remove('sticky');
            document.body.classList.add('modern');
            styleToggleBtn.textContent = "Switch to Sticky Note";
            localStorage.setItem('noteStyle', 'modern');
        } else {
            document.body.classList.remove('modern');
            document.body.classList.add('sticky');
            styleToggleBtn.textContent = "Switch to Modern Card";
            localStorage.setItem('noteStyle', 'sticky');
        }
        noteSection.style.opacity = 1; // fade in
    }, 300);
});
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="assets/javascript/darkmode.js"></script>
<jsp:include page="chatbot.jsp" />
</body>
</html>
