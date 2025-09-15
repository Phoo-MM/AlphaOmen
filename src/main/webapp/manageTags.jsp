<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.alphaomen.dao.*" %>
<%@ page import="com.alphaomen.model.*" %>
<%@ page import="com.alphaomen.db.DB" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>


<%

	boolean justOptions = "true".equals(request.getParameter("optionsOnly"));
	User user = (User) session.getAttribute("user");
	if (justOptions && user != null) {
	    Connection conn = DB.getConnection();
	    PreparedStatement ps = conn.prepareStatement("SELECT tag_id, tag_name FROM tag WHERE user_id = ?");
	    ps.setInt(1, user.getId());
	    ResultSet rs = ps.executeQuery(); 
	    while(rs.next()) {
	%>
	<option value="<%= rs.getInt("tag_id") %>"><%= rs.getString("tag_name") %></option>
	<%
	    }
	%>
	<option value="new">+ Add New</option>
	<%
	    return; // stop rendering the full page
	}


    NoteDAO noteDAO = new NoteDAO();    
    List<Tag> tags = new ArrayList<>();
    int userTagCount = 0;
    int tagLimit = 5;

	// Ads 
  	int noteCount = 0;
  	String userPlan = "guest";
  	if (user!= null) {
  		tags = noteDAO.getTagsByUser(user.getId());
        userTagCount = noteDAO.getTagCountByUser(user.getId());
        
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
/* Headings */
.main-content h2 {
    color: #004aad;
    margin-bottom: 20px;
}

/* Forms */
form input[type="text"] {
    padding: 8px 12px;
    border: 1px solid #ccc;
    border-radius: 5px;
    margin-right: 10px;
    width: 200px;
}

form button {
    padding: 8px 12px;
    border: none;
    border-radius: 5px;
    background-color: #004aad;
    color: white;
    cursor: pointer;
    transition: 0.3s;
}

form button:hover {
    background-color: #ffc107;
    color: black;
}

/* Tables */
table {
    width: 100%;
    border-collapse: collapse;
    background-color: #fff;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

table th {
    background-color: #0d6efd;
    color: black;
    padding: 10px;
}

table td {
    padding: 10px;
    border-bottom: 1px solid #ddd;
}

table thead tr {
    background-color:#90d6ff;
    color: white;
}

table tbody tr:hover {
    background-color: #f1f1f1;
}
/* Main Content Background */
body.dark-mode .main-content {
    background: #1E1E1E url('assets/images/background-pattern.png') repeat;
    color: var(--text-main);
}

/* Headings in Main Content */
body.dark-mode .main-content h2 {
    color: #a3c4ff; /* softer accent for dark mode */
}

/* Forms */
body.dark-mode form input[type="text"] {
    background-color: var(--bg-card);
    color: var(--text-main);
    border: 1px solid var(--border-color);
}

body.dark-mode form button {
    background-color: var(--color-primary);
    color: var(--text-light);
}

body.dark-mode form button:hover {
    background-color: var(--color-accent1);
    color: var(--text-dark);
}

/* Tables */
body.dark-mode table {
    background-color: var(--bg-card);
    color: var(--text-main);
    border-collapse: collapse;
    box-shadow: 0 2px 5px rgba(0,0,0,0.2);
}

body.dark-mode table th {
    background-color: #0d6efd; /* keep accent, or change to softer if needed */
    color: white;
}

body.dark-mode table td {
    border-bottom: 1px solid var(--border-color);
    color: var(--text-main);
}

body.dark-mode table thead tr {
    background-color: #0d6efd; /* accent */
    color: white;
}

body.dark-mode table tbody tr:hover {
    background-color: rgba(255,255,255,0.05); /* subtle hover in dark mode */
}

/* Forms / Inputs Placeholder */
body.dark-mode form input::placeholder {
    color: var(--text-muted);
}

/* Optional: table borders */
body.dark-mode table,
body.dark-mode table th,
body.dark-mode table td {
    border-color: var(--border-color);
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
@media (max-width: 768px) {
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
                            <a class="nav-link active" href="manageTags.jsp">
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
                            <a class="nav-link" href="notes.jsp">
                                <i class="fa-solid fa-pen-to-square me-2"></i> Notes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="manageTags.jsp">
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
            
		<h2>Manage Categories</h2>
		
		<% if (user != null) { %>
        <!-- Add Tag Button -->
        <button type="button" class="btn btn-primary mb-3" id="addTagBtn">+ Add New Category</button>
		
		<!-- Limit Reached Modal -->
        <div class="modal fade" id="limitReachedModal" tabindex="-1" aria-labelledby="limitReachedModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title text-danger" id="limitReachedModalLabel">Limit Reached</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
              </div>
              <div class="modal-body">
                Free plan allows only 5 categories. Upgrade to Premium to add more.
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <a href="purchasePlan.jsp" class="btn btn-primary">Upgrade</a>
              </div>
            </div>
          </div>
        </div>

        <!-- Add Tag Modal -->
        <div class="modal fade" id="addTagModal" tabindex="-1" aria-labelledby="addTagModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <form action="note" method="post" id="addTagForm">
                <input type="hidden" name="action" value="createTag">
                <div class="modal-header">
                  <h5 class="modal-title" id="addTagModalLabel">Add New Category</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                  <input type="text" name="tag_name" class="form-control" placeholder="Category Name" required>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                  <button type="submit" class="btn btn-primary">Create Category</button>
                </div>
              </form>
            </div>
          </div>
        </div>
		
		
		<!-- List all tags -->
		<hr>
		<table class="table table-bordered">
			<thead>
		    	<tr>	
		    		<th>No</th>
		    		<th>Name</th>
		    		<th>Actions</th>
		    	</tr>
		    </thead>
		    <% int count = 1; %>
		    <% for (Tag tag : tags) { %>
		        <tr>
		            <td><%= count++ %></td>
		            <td>
		                <form action="note" method="post" style="display:inline;">
		                    <input type="hidden" name="action" value="updateTag">
		                    <input type="hidden" name="tag_id" value="<%= tag.getId() %>">
		                    <input type="text" name="tag_name" value="<%= tag.getName() %>">
		                    <button type="submit">Update</button>
		                </form>
		            </td>
		            <td>
		                <form action="note" method="post" style="display:inline;">
		                    <input type="hidden" name="action" value="deleteTag">
		                    <input type="hidden" name="tag_id" value="<%= tag.getId() %>">
		                    <button type="submit" onclick="return confirm('Delete this tag?')">Delete</button>
		                </form>
		            </td>
		        </tr>
		    <% } %>
		</table>
		
		<% } else { %>
        <p>Please <a href="login.jsp">log in</a> to manage categories.</p>
    <% } %>
    
    </main>
    </div> <!-- End of row -->
</div> <!-- End of container fluid -->
<script>
  const userTagCount = <%= userTagCount %>;
  const tagLimit = <%= tagLimit %>;
  const userPlan = "<%= userPlan %>";

  document.getElementById("addTagBtn").addEventListener("click", function(e) {
      if (userPlan === "free" && userTagCount >= tagLimit) {
          e.preventDefault(); // Prevent opening addTagModal
          const limitModal = new bootstrap.Modal(document.getElementById('limitReachedModal'));
          limitModal.show();
      } else {
          const addModal = new bootstrap.Modal(document.getElementById('addTagModal'));
          addModal.show();
      }
  });

</script>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
	<script src="assets/javascript/darkmode.js"></script>
	<jsp:include page="chatbot.jsp" />
</body>
</html>