<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.alphaomen.model.*" %>
<%@ page import="com.alphaomen.dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*, com.alphaomen.db.DB" %>
<%@ page import="java.time.LocalDate, java.util.Map" %>
<%
    int noteId = Integer.parseInt(request.getParameter("note_id"));
    NoteDAO noteDAO = new NoteDAO();
    Note note = noteDAO.getNoteById(noteId);

    User user = (User) session.getAttribute("user");
    int maxNotes = 15;
    int maxTags = 5; // same limit as in NoteDAO
    int userNoteCount = 0;
    int userTagCount = 0;
    if(user != null) {
    	userNoteCount = noteDAO.getNoteCountByUser(user.getId());
    	userTagCount = noteDAO.getTagCountByUser(user.getId());
    }
    
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

/********************************************* Autocorrect ************************************/
.misspelled {
  color: red;
  text-decoration: underline;
  cursor: pointer;
  position: relative;      /* 🔑 makes dropdown relative to this word */
  display: inline-block;   /* 🔑 keeps word inline without forcing line break */
}

.misspelled .suggestions {
  display: none;
  position: absolute;
  top: 100%;               /* show below the word */
  left: 0;
  background: #fff;        /* cleaner background */
  border: 1px solid #ccc;
  border-radius: 6px;
  box-shadow: 0 4px 8px rgba(0,0,0,0.15);
  z-index: 100;
  white-space: nowrap;     /* prevent wrapping of suggestions */
}

.misspelled:hover .suggestions {
  display: block;
}

.suggestions span {
  padding: 4px 8px;
  cursor: pointer;
}

.suggestions span:hover {
  background-color: #eee;
}


    button { margin-top: 10px; }


.export-importbtn {
  display: flex;                /* ensure it's a flex container */
  align-items: center;          /* vertical centering */
  justify-content: space-between; /* spread children apart */
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  padding: 10px;                /* optional for spacing */
}

.delete-form {
  margin-left: auto;  /* pushes delete form to the far right */
}

.export-importbtn .btn {
  border-radius: 8px;
  font-weight: 600;
}

/* Toolbar */
#toolbarContainer { background: var(--text-light); box-shadow: 0 6px 20px rgba(0,0,0,0.1); border-radius: 16px; padding: 25px; width: 100%; max-width: 1500px; display: flex; flex-direction: column; align-items: center; box-sizing: border-box; }

/* Title Input */
#titleInput { border-radius: 12px; border: 1px solid #ccc; padding: 12px 15px; font-size: 1.2rem; box-shadow: inset 0 2px 4px rgba(0,0,0,0.05); width: 100%; }

/* Buttons */
.button-row { display: flex; justify-content: center; gap: 15px; margin-bottom: 15px; width: 100%; }
.button-row .btn { border-radius: 12px; font-weight: 600; padding: 10px 25px; transition: all 0.3s; }

/* Form row: Pin, Color, Due, Category */
.form-row {
    display: flex;
    gap: 20px;
    align-items: center;
    flex-wrap: wrap;
    margin-top: 15px;
}

/* Each form element: label + input/select inline */
.form-row > div {
    display: flex;
    align-items: center;
    gap: 5px;
    flex: 1 1 200px;
}

/* Label inline for icon + text */
.form-row label {
    display: flex;
    align-items: center;
    gap: 5px;
    margin: 0;
    font-weight: 500;
}

/* Inputs/select same height */
.form-row input[type="color"],
.form-row input[type="date"],
.form-row select {
    height: 38px;
    padding: 5px 10px;
    box-sizing: border-box;
    border-radius: 8px;
}

/* Checkbox container */
.form-check {
    display: flex;
    align-items: center;
    gap: 5px;
}

/* Checkbox size */
.form-check-input { width: 20px; height: 20px; margin: 0; }

    .recording {
      border: 2px solid red;
      box-shadow: 0 0 10px red;
    }

/* Formatting Toolbar */
.formatToolbar { display: flex; flex-wrap: wrap; flex-direction: row; justify-content: flex-start; gap: 15px; margin-top: 15px; width: 100%; max-width: 1500px; }
.format-group { display: flex; gap: 5px; align-items: center; }
#formatToolbar button, #formatToolbar select { border-radius: 6px; border: 1px solid #ccc; background: #f1f1f1; padding: 6px 10px; transition: all 0.2s; min-width: 40px; }
#formatToolbar button:hover, #formatToolbar select:hover { background: #e0e0e0; transform: translateY(-1px); }

/* Editor */
#editorContainer { width: 100%; max-width: 1500px; margin-top: 20px; display: flex; flex-direction: column; align-items: center; }
#editor { width: 100%; 
		min-height: 200px;
    	max-height: 400px;  /* scrollable */
		border-radius: 16px; 
		border: 1px solid #ccc; 
		padding: 25px; 
		background: #fff; 
		box-shadow: 0 8px 25px rgba(0,0,0,0.08); 
		line-height: 1.6; 
		white-space: pre-wrap; /* preserve line breaks */
		overflow-y: auto; 
		transition: all 0.3s ease; }
#editor:focus { outline: none; box-shadow: 0 0 0 3px rgba(0, 74, 173, 0.2); }


.btn-primary {
    background-color: #47ab51;
    border-color: #47ab51;
    transition: all 0.3s ease;
    color: #fff;
}

.btn-primary:hover {
    background-color: white; /* slightly darker green */
    border-color: #389642;
    transform: translateY(-2px);
}

.btn-secondary {
    background-color: #f3474d;
    border-color: #f3474d;
    transition: all 0.3s ease;
    color: #fff;
}

.btn-secondary:hover {
    background-color: #d7373d; /* slightly darker red */
    border-color: #d7373d;
    transform: translateY(-2px);
}


/* Responsive */
@media(max-width: 992px){ 
	.main-content { 
		margin-left: 0; 
		width: 100%; 
	} 
	
	#editor { 
		height: 50vh; 
	} 
}
body.dark-mode {
    background: var(--bg-body);
  }
/* Toolbar Container */
body.dark-mode #toolbarContainer {
    background: var(--bg-card);
    color: var(--text-main);
    box-shadow: 0 6px 20px rgba(0,0,0,0.4);
}

/* Title Input */
body.dark-mode #titleInput {
    background: var(--bg-card);
    color: var(--text-main);
    border: 1px solid var(--border-color);
}

/* Buttons inside form rows and toolbar */
body.dark-mode .button-row .btn {
    background: var(--color-primary);
    color: var(--text-light);
    border: 1px solid var(--border-color);
}

body.dark-mode .button-row .btn:hover {
    background: var(--color-accent1);
    color: var(--text-light);
}

/* Form rows */
body.dark-mode .form-row > div input,
body.dark-mode .form-row > div select {
    background: var(--bg-card);
    color: var(--text-main);
    border: 1px solid var(--border-color);
}

/* Checkboxes */
body.dark-mode .form-check-input {
    background: var(--bg-card);
    border: 1px solid var(--border-color);
}

/* Visualizer */
body.dark-mode #visualizer {
    background: #333;
}

/* Formatting Toolbar */
body.dark-mode #formatToolbar button,
body.dark-mode #formatToolbar select {
    background: var(--bg-card);
    color: var(--text-main);
    border: 1px solid var(--border-color);
}

body.dark-mode #formatToolbar button:hover,
body.dark-mode #formatToolbar select:hover {
    background: var(--color-accent1);
    color: var(--text-light);
}

/* Export/Import Buttons */
body.dark-mode .export-importbtn .btn {
    background: var(--color-primary);
    color: var(--text-light);
    border: 1px solid var(--border-color);
}

body.dark-mode .export-importbtn .btn:hover {
    background: var(--color-accent1);
}

/* Editor */
body.dark-mode #editor {
    background: var(--bg-card);
    color: var(--text-main);
    border: 1px solid var(--border-color);
    box-shadow: 0 8px 25px rgba(0,0,0,0.4);
}

/* Media Queries for Dark Mode */
@media (max-width: 768px) {
    body.dark-mode .sidebar {
        background: var(--bg-sidebar);
    }

    body.dark-mode .sidebar a {
        color: var(--text-light);
    }
}

/* Floating Calculator (already dark-mode ready, but ensure close button visibility) */
body.dark-mode #calcCloseBtn {
    color: var(--text-light);
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
	max-width: 100%;
	height: auto;
	display: block;
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
.voice-row {
  display: flex;
  gap: 30px;
  align-items: flex-start;
  flex-wrap: nowrap; /* stay in one row */
}

.voice-option {
  flex: 1 1 50%;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.upload-box{
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 12px;
  padding: 15px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.05);
}
.record-box {
  display: flex;
  flex-direction: column; /* force vertical stacking */
  align-items: stretch;   /* make children take full width */
  gap: 12px;
}
#visualizer {
  width: 300px;
  display: block;
  height: 60px;
  background: #111;
  border-radius: 8px;
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

 
        <!-- Toolbar above editor -->
	    <div id="toolbarContainer">
	
	        <!-- LEFT: Update Form -->
	        <form action="note" method="post" id="updateForm" class="w-100" enctype="multipart/form-data">
	            <input type="hidden" name="action" value="update">
	            <input type="hidden" name="note_id" value="<%= note.getNoteId() %>">
				<input type="hidden" name="user_id" value="<%= user.getId() %>">
				
	            <!-- Update + Cancel -->
	            <div class="button-row">
	                <button type="submit" class="btn btn-primary" style="background-color: #47ab51; border-color: #47ab51;"><i class="fa-solid fa-floppy-disk"></i> Update</button>
	                <a href="notes.jsp" class="btn btn-secondary" style="background-color:  #f3474d; border-color: #f3474d;"><i class="fa-solid fa-xmark"></i> Cancel</a>
	            </div>
				
				<!-- Title placed above editor -->
		        <div class="mb-3 w-100">
		            <label for="titleInput" class="form-label" style="color: #004aad;"><h4>Title</h4></label>
		            <input type="text" name="title" id="titleInput" class="form-control" value="<%= note.getTitle() %>" required>
		        </div>
				
	            <!-- Pin, Color, Due Date, Category -->
	            <div class="form-row w-100">
	                <div class="form-check">
	                    <input type="checkbox" name="is_pinned" class="form-check-input" id="pinnedCheck" <%= note.isPinned() ? "checked" : "" %>>
	                    <label class="form-check-label" for="pinnedCheck" style="color: #004aad;"><i class="fa-solid fa-thumbtack"></i> Pin</label>
	                </div>
	                <div>
	                    <label for="colorPicker" style="color: #004aad;"><i class="fa-solid fa-palette" style="color: #004aad;"></i> Color</label>
	                    <input type="color" name="color" id="colorPicker" class="form-control form-control-color" value="<%= note.getColor() != null ? note.getColor() : "#ffffff" %>">
	                </div>
	                <div>
	                    <label for="dueDate" style="color: #004aad;"><i class="fa-solid fa-calendar" style="color: #004aad;"></i> Due</label>
	                    <input type="date" name="due_date" id="dueDate" class="form-control" value="<%= note.getDueDate() != null ? note.getDueDate() : "" %>">
	                </div>
	                <div>
	                    <label for="tagSelect" style="color: #004aad;"><i class="fa-solid fa-tags" style="color: #004aad;"></i> Category</label>
	                    <select name="tag_id" id="tagSelect" class="form-select" onchange="handleTagSelect(this)">
	                        <option value="">-- Select --</option>
	                        <%
	                        	Connection conn = DB.getConnection();
	                            PreparedStatement ps = conn.prepareStatement("SELECT tag_id, tag_name FROM tag WHERE user_id = ?");
	                            ps.setInt(1, user.getId());
	                            ResultSet rs = ps.executeQuery();
	                            while(rs.next()) {
	                        %>
						        <option value="<%= rs.getInt("tag_id") %>" <%= note.getTagId() != null && note.getTagId() == rs.getInt("tag_id") ? "selected" : "" %>>
						        <%= rs.getString("tag_name") %></option>
						    <%
						            }
						    %>
						    <option value="new">+ Add New</option>
						</select>

	                </div>
	            </div>
	
				<!-- Voice Note Section -->
				<div class="mb-3">
				    <label class="form-label" style="color:#004aad;">
				        <i class="fa-solid fa-microphone"></i> Voice Note
				    </label>
				
				    <% boolean hasVoice = note != null 
				    					&& note.getVoiceNotePath() != null
				    					&& !note.getVoiceNotePath().trim().isEmpty(); %>
				    
				    <div id="existingVoiceNoteContainer" class="mb-2" style="<%= hasVoice ? "" : "display:none;" %>">
				        <% if (hasVoice) { %>
				        <audio id="existingVoiceNote" controls>
				            <source src="voice?file=<%= note.getVoiceNotePath() %>" type="audio/webm">
				            Your browser does not support the audio element.
				        </audio>
				        <button type="button" id="removeExistingVoiceBtn" class="btn btn-secondary btn-sm mt-1">Remove</button>
				        <input type="hidden" name="existing_voice_note" value="<%= note.getVoiceNotePath() %>" />
				    <% } %>
				    </div>
					
					<!-- Toggle buttons -->
			  <div class="d-flex gap-2 mb-2">
			    <button type="button" id="toggleUpload" class="btn btn-outline-primary btn-sm">Upload File</button>
			    <button type="button" id="toggleRecord" class="btn btn-outline-success btn-sm">Record</button>
			  </div>
			
			  <!-- Upload box (hidden initially) -->
			  <div id="uploadBox" class="mb-2" style="display:none;">
			    <input type="file" name="audioFile" id="audioFileInput" accept="audio/*" class="form-control"/>
			  </div>
			
			  <!-- Record box (hidden initially) -->
			  <div id="recordBox" class="record-box" style="display:none;">
			    <div class="btn-group">
			      <button type="button" id="startBtn" class="btn btn-primary">Start</button>
			      <button type="button" id="pauseBtn" class="btn btn-warning">Pause</button>
			      <button type="button" id="stopBtn" class="btn btn-danger">Stop</button>
			      <button type="button" id="removeBtn" class="btn btn-secondary">Remove</button>
			    </div>
			    <canvas id="visualizer"></canvas>
			    <audio id="playback" controls></audio>
			    <div id="downloadLinks"></div>
			  </div>
			</div>
<script>

document.addEventListener("DOMContentLoaded", () => {
  const toggleUploadBtn = document.getElementById("toggleUpload");
  const toggleRecordBtn = document.getElementById("toggleRecord");
  const uploadBox = document.getElementById("uploadBox");
  const recordBox = document.getElementById("recordBox");

  // Toggle Upload
  toggleUploadBtn.addEventListener("click", () => {
    const isVisible = uploadBox.style.display === "block";
    uploadBox.style.display = isVisible ? "none" : "block";
    recordBox.style.display = "none"; // hide the other
  });

  // Toggle Record
  toggleRecordBtn.addEventListener("click", () => {
    const isVisible = recordBox.style.display === "block";
    recordBox.style.display = isVisible ? "none" : "block";
    uploadBox.style.display = "none"; // hide the other
  });
});
</script>				
	            <!-- Formatting Toolbar -->
	            <div class="formatToolbar">
	                <div class="format-group">
		                <!-- Bold/ Italic/ Underline -->
		                <button type="button" onclick="formatText('bold')" class="btn btn-sm btn-secondary"><b>B</b></button>
		                <button type="button" onclick="formatText('italic')" class="btn btn-sm btn-secondary"><i>I</i></button>
		                <button type="button" onclick="formatText('underline')" class="btn btn-sm btn-secondary"><u>U</u></button>
					</div>
					
					<div class="format-group">
		                <!-- Font Color -->
						<label for="fontColorPicker" class="form-label mb-0"><i class="fa-solid fa-font"></i> Font Color</label>
						<input type="color" id="fontColorPicker" class="form-control form-control-color" value="#000000"
						       onchange="formatText('foreColor', this.value)">
					</div>
					
					<div class="format-group">
						<!-- Highlight Color -->
						<label for="highlightColorPicker" class="form-label mb-0"><i class="fa-solid fa-highlighter"></i> Highlight</label>
						<input type="color" id="highlightColorPicker" class="form-control form-control-color" value="#ffff00"
						       onchange="formatText('hiliteColor', this.value)">
					</div>
					
					<div class="format-group">
						<!-- Font Size -->
						<select onchange="formatText('fontSize', this.value)"> 
							<option value="">Font Size</option> 
							<option value="1">12px</option> 
							<option value="2">14px</option> 
							<option value="3">16px</option> 
							<option value="4">18px</option> 
							<option value="5">20px</option> 
							<option value="6">22px</option> 
							<option value="7">24px</option> 
						</select>
				</div>
			</div> <!-- End of formatToolbar -->

				<!-- Hidden content textarea -->
				<textarea name="content" id="hiddenContent" style="display:none;"></textarea>
				
	        </form>

		<div class="export-importbtn d-flex align-items-center mt-4">
			<!-- Export + Import -->
			<div class="d-flex gap-2">
			<% if (note != null) { %>
				<a href="ExportServlet?noteId=<%= note.getNoteId() %>" class="btn btn-info">Export</a>
    		<% } %>
				<form action="ImportServlet" method="post" enctype="multipart/form-data" style="display:inline;">
					<% if (userNoteCount < maxNotes) { %>
				    <label class="btn btn-warning mb-0">
				      Import <input type="file" name="file" accept=".txt,.json,.csv" hidden onchange="this.form.submit()">
				    </label>
				  <% } else { %>
				    <button type="button" class="btn btn-warning mb-0" disabled>Import</button>
				  <% } %>
				</form>
			</div>
			</div>
				    
	        <!-- RIGHT: Delete -->
		        <form action="note" method="post" class="d-inline delete-form">
		            <input type="hidden" name="action" value="delete">
		            <input type="hidden" name="note_id" value="<%= note.getNoteId() %>">
		            <button type="submit" class="btn btn-danger"><i class="fa-solid fa-trash"></i> Delete</button>
		        </form>

	    </div> <!-- END Toolbar -->

		<div id="editorContainer">		
			<div id="editor" class="editor" contenteditable="true"><%= note.getContent() %>
			</div>
		</div>
			
			</main>
		</div> <!-- End of row -->				    
	</div> <!-- End of container fluid -->
	
	<!-- Modal -->
		<div class="modal fade" id="addTagModal" tabindex="-1" aria-labelledby="addTagModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<form action="note" method="post" id="addTagForm" target="hiddenFrame">
						<input type="hidden" name="action" value="createTag">
						<div class="modal-header">
							<h5 class="modal-title" id="addTagModalLabel">Add New Category</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body">
							<input type="text" name="tag_name" id="newTagName" class="form-control" placeholder="Category Name" required>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
							<button type="submit" class="btn btn-primary" <%= (userTagCount >= maxTags ? "disabled" : "") %>>Create Category</button>
						</div>
					</form>
				</div>
			</div>
		</div>			
		<!-- Hidden iframe so servlet redirect won't distrub this page -->
		<iframe name="hiddenFrame" style="display: none;"></iframe>				

		<!-- Tag Limit Reached Modal -->
		<div class="modal fade" id="tagLimitReachedModal" tabindex="-1" aria-labelledby="tagLimitReachedModalLabel" aria-hidden="true">
		  <div class="modal-dialog">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title text-danger" id="tagLimitReachedModalLabel">Limit Reached</h5>
		        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
		      </div>
		      <div class="modal-body">
		        Free plan allows only <%= maxTags %> categories. Upgrade to Premium to add more.
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
		        <a href="purchasePlan.jsp" class="btn btn-primary">Upgrade</a>
		      </div>
		    </div>
		  </div>
		</div>

<script>
//Voice recording
document.addEventListener("DOMContentLoaded", () => {
    let mediaRecorder;
    let audioChunks = [];
    let isPaused = false;

    const startBtn = document.getElementById("startBtn");
    const pauseBtn = document.getElementById("pauseBtn");
    const stopBtn = document.getElementById("stopBtn");
    const removeBtn = document.getElementById("removeBtn");
    const playback = document.getElementById("playback");
    const visualizer = document.getElementById("visualizer");
    const downloadLinks = document.getElementById("downloadLinks");

 // Existing voice note remove button
    const removeExistingBtn = document.getElementById("removeExistingVoiceBtn");
    const existingContainer = document.getElementById("existingVoiceNoteContainer");
    const fileInput = document.getElementById("audioFileInput");

    if (removeExistingBtn) {
        removeExistingBtn.addEventListener("click", () => {
            const confirmRemove = confirm("Are you sure you want to remove the existing voice note?");
            if (!confirmRemove) return;

         // Remove audio preview & hidden input
            existingContainer.style.display = "none";
            fileInput.style.display = "block"; // show file input again

         // Mark for servlet removal
            let removeInput = document.createElement("input");
            removeInput.type = "hidden";
            removeInput.name = "remove_voice_note";
            removeInput.value = "true";
            updateForm.appendChild(removeInput);
        });
    }

    
    let audioContext, analyser, dataArray, animationId;

    // 🎵 Draw waveform on canvas
    function startVisualizer(stream) {
        audioContext = new (window.AudioContext || window.webkitAudioContext)();
        analyser = audioContext.createAnalyser();
        const source = audioContext.createMediaStreamSource(stream);
        source.connect(analyser);

        analyser.fftSize = 256;
        const bufferLength = analyser.frequencyBinCount;
        dataArray = new Uint8Array(bufferLength);

        const canvasCtx = visualizer.getContext("2d");

        function draw() {
            animationId = requestAnimationFrame(draw);
            analyser.getByteFrequencyData(dataArray);

            canvasCtx.fillStyle = "#111";
            canvasCtx.fillRect(0, 0, visualizer.width, visualizer.height);

            const barWidth = (visualizer.width / bufferLength) * 2.5;
            let x = 0;

            for (let i = 0; i < bufferLength; i++) {
                const barHeight = dataArray[i] / 2;
                canvasCtx.fillStyle = "lime";
                canvasCtx.fillRect(x, visualizer.height - barHeight, barWidth, barHeight);
                x += barWidth + 1;
            }
        }

        draw();
    }

    function stopVisualizer() {
        if (animationId) cancelAnimationFrame(animationId);
        if (audioContext) audioContext.close();
    }

    // 🎤 Start recording
    startBtn.addEventListener("click", async () => {
        try {
            if (!mediaRecorder || mediaRecorder.state === "inactive") {
                const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
                mediaRecorder = new MediaRecorder(stream);

                mediaRecorder.ondataavailable = e => audioChunks.push(e.data);

                mediaRecorder.onstop = () => {
                    const audioBlob = new Blob(audioChunks, { type: "audio/webm" });
                    const audioURL = URL.createObjectURL(audioBlob);
                    playback.src = audioURL;

                    // Put into <input type="file">
                    const audioFile = new File([audioBlob], "voiceNote.webm", { type: "audio/webm" });
                    const dt = new DataTransfer();
                    dt.items.add(audioFile);
                    fileInput.files = dt.files;

                    // Download link
                    const dl = document.createElement("a");
                    dl.href = audioURL;
                    dl.download = "voiceNote.webm";
                    dl.textContent = "Download recording";
                    downloadLinks.innerHTML = "";
                    downloadLinks.appendChild(dl);

                    stopVisualizer();
                };

                audioChunks = [];
                mediaRecorder.start();
                startVisualizer(stream);
            } else if (mediaRecorder.state === "paused") {
                mediaRecorder.resume();
                isPaused = false;
            }
        } catch (err) {
            console.error("Mic access failed:", err);
            alert("Please allow microphone access.");
        }
    });

    // ⏸ Pause recording
    pauseBtn.addEventListener("click", () => {
        if (mediaRecorder && mediaRecorder.state === "recording") {
            mediaRecorder.pause();
            isPaused = true;
        }
    });

    // ⏹ Stop recording
    stopBtn.addEventListener("click", () => {
        if (mediaRecorder && (mediaRecorder.state === "recording" || mediaRecorder.state === "paused")) {
            mediaRecorder.stop();
        }
    });

    // ❌ Remove recording
    removeBtn.addEventListener("click", () => {
        playback.src = "";
        downloadLinks.innerHTML = "";
        fileInput.value = "";
        audioChunks = [];
        stopVisualizer();
    });
});
function handleTagSelect(select) {
    const maxTags = <%= maxTags %>;
    const userTagCount = <%= userTagCount %>;

    if(select.value === "new"){
        if(userTagCount >= maxTags){
        	const limitModal = new bootstrap.Modal(document.getElementById('tagLimitReachedModal'));
            limitModal.show();
            select.value = "";
            return;
        }
        // Show the Bootstrap modal
        const modal = new bootstrap.Modal(document.getElementById('addTagModal'));
        modal.show();
        select.value = ""; // reset dropdown
    }
}

function formatText(command, value = null) {
    const selection = window.getSelection();
    if (!selection || selection.isCollapsed) {
        // No text selected, do nothing
        return;
    }
    document.execCommand(command, false, value);
	
 // Clear selection so it doesn’t “stick”
    selection.removeAllRanges();
}

    const updateForm = document.getElementById('updateForm');
    updateForm.addEventListener('submit', function(e){
        const editorContent = document.getElementById('editor').innerHTML.trim();

        document.getElementById('hiddenContent').value = editorContent;

        const titleInput = document.getElementById('titleInput');
        if (!titleInput.value.trim()) { alert("Title cannot be empty!"); e.preventDefault(); }

    });

    const editor = document.getElementById('editor');

    editor.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault(); // prevent default behavior
            const range = window.getSelection().getRangeAt(0);
            const br = document.createElement('br');

            // Insert the <br> at the cursor position
            range.deleteContents();
            range.insertNode(br);

            // Move cursor after the <br>
            range.setStartAfter(br);
            range.setEndAfter(br);

            const sel = window.getSelection();
            sel.removeAllRanges();
            sel.addRange(range);

            return false; // just in case
        }
    });
    
    document.getElementById("addTagForm").addEventListener("submit", function(e){
        e.preventDefault(); // prevent default form submission
        const form = this;

        const newTagName = document.getElementById('newTagName').value.trim();

        if(!newTagName) return;
        
        // Create hidden iframe to submit the form
        const iframe = document.createElement('iframe');
        iframe.name = 'tempFrame';
        iframe.style.display = 'none';
        document.body.appendChild(iframe);

        form.target = 'tempFrame';
        form.submit();

        // Poll the iframe for load event
        iframe.onload = function() {
            // Reload the tag dropdown
            fetch('manageTags.jsp?optionsOnly=true')
                .then(response => response.text())
                .then(html => {
                	const tagSelect = document.getElementById('tagSelect');
                    tagSelect.innerHTML = html;

                    // Automatically select the newly added tag
                    const options = tagSelect.options;
                    for(let i = 0; i < options.length; i++) {
                        if(options[i].text === newTagName) {
                            tagSelect.selectedIndex = i;
                            break;
                        }
                    }
                });

            // Close the modal
            const modalEl = document.getElementById('addTagModal');
            const modal = bootstrap.Modal.getInstance(modalEl);
            modal.hide();

         // Clear the input for next time
            document.getElementById('newTagName').value = "";
            
            // Clean up iframe
            iframe.remove();
        }
    });


    </script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
	<script src="assets/javascript/darkmode.js"></script>
</body>
</html>
