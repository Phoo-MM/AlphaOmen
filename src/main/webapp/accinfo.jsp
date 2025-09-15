<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.alphaomen.model.User"%>
<%@ page import="com.alphaomen.dao.UserDAO"%>
<%@ page import="com.alphaomen.model.Plan"%>
<%@ page import="com.alphaomen.dao.PlanDAO"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Fetch latest subscription info
    UserDAO userDAO = new UserDAO();
    user = userDAO.getUserWithSubscriptionDates(user.getId());
    session.setAttribute("user", user); // update session

    PlanDAO planDAO = new PlanDAO();
    Plan plan = planDAO.getPlanById(user.getPlanId()); // fetch user plan if exists
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Account Info - AlphaOmen</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
<style>
    body {
        background-color: #f0f2f8;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .card {
        border-radius: 16px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        margin-top: 40px;
    }

    .card-header {
        border-radius: 16px 16px 0 0;
        background: linear-gradient(135deg, #4e73df, #1cc88a);
        color: #fff;
        font-weight: 600;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .card-body {
        padding: 25px;
    }

    .info-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.2rem;
    }

    .info-label {
        font-weight: 600;
        color: #555;
    }

    .edit-btn {
        font-size: 0.9rem;
    }

    /* Plan info badge */
    .plan-badge {
        background-color: #ffc107;
        color: #222;
        padding: 4px 12px;
        border-radius: 50px;
        font-weight: 600;
        font-size: 0.9rem;
    }

    /* Alerts */
    .alert {
        max-width: 600px;
        margin: 20px auto 0;
        border-radius: 12px;
        font-weight: 500;
    }

    /* Buttons */
    .btn-outline-primary, .btn-outline-success {
        border-radius: 8px;
        font-weight: 500;
    }

    /* Modal inputs */
    .modal .form-control {
        border-radius: 8px;
        padding: 10px 12px;
    }
</style>
</head>
<body>
<% 
   String message = (String) session.getAttribute("message");
   String messageType = (String) session.getAttribute("messageType");
   if (message != null) { %>
   <div class="alert alert-<%= messageType.equals("success") ? "success" : "danger" %> alert-dismissible fade show" role="alert">
       <%= message %>
       <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
   </div>
<% 
   session.removeAttribute("message");
   session.removeAttribute("messageType");
} %>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-7">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fa-solid fa-user"></i> Account Information</h5>
                    <a href="index.jsp" class="btn btn-outline-light btn-sm"><i class="fa-solid fa-arrow-left"></i> Home</a>
                </div>
                <div class="card-body">

                    <!-- Username -->
                    <div class="info-row">
                        <span class="info-label">Username:</span>
                        <span>
                            <span id="usernameText"><%= user.getUsername() %></span>
                            <button class="btn btn-sm btn-outline-primary edit-btn" data-bs-toggle="modal" data-bs-target="#editUsernameModal">
                                <i class="fa-solid fa-pen"></i> Edit
                            </button>
                        </span>
                    </div>

                    <!-- Email -->
                    <div class="info-row">
                        <span class="info-label">Email:</span>
                        <span><%= user.getEmail() %></span>
                    </div>

                    <!-- Plan Info -->
                    <div class="info-row">
                        <span class="info-label">Plan:</span>
                        <span>
                            <% if(plan != null) { %>
                                <span class="plan-badge"><%= plan.getName() %></span>
                            <% } else { %>
                                Free
                            <% } %>
                        </span>
                    </div>

                    <!-- Purchase Date -->
                    <div class="info-row">
                        <span class="info-label">Purchase Date:</span>
                        <span><%= user.getPremiumStart() != null ? user.getPremiumStart() : "-" %></span>
                    </div>

                    <!-- Expiry Date -->
                    <div class="info-row">
                        <span class="info-label">Expiry Date:</span>
                        <span><%= user.getPremiumExpiry() != null ? user.getPremiumExpiry() : "-" %></span>
                    </div>

                    <hr>

                    <!-- Password Update -->
                    <div class="info-row">
                        <span class="info-label">Password:</span>
                        <button class="btn btn-sm btn-outline-success edit-btn" data-bs-toggle="modal" data-bs-target="#editPasswordModal">
                            <i class="fa-solid fa-lock"></i> Change
                        </button>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Username Modal -->
<div class="modal fade" id="editUsernameModal" tabindex="-1" aria-labelledby="editUsernameModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form action="account" method="post" class="modal-content">
      <input type="hidden" name="action" value="updateInfo">
      <div class="modal-header">
        <h5 class="modal-title" id="editUsernameModalLabel">Edit Username</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
          <div class="mb-3">
              <label for="username" class="form-label">New Username</label>
              <input type="text" class="form-control" id="username" name="username" value="<%= user.getUsername() %>" required>
          </div>
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-primary">Save Changes</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
      </div>
    </form>
  </div>
</div>

<!-- Edit Password Modal -->
<div class="modal fade" id="editPasswordModal" tabindex="-1" aria-labelledby="editPasswordModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form action="account" method="post" class="modal-content">
      <input type="hidden" name="action" value="changePassword">
      <div class="modal-header">
        <h5 class="modal-title" id="editPasswordModalLabel">Change Password</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
          <div class="mb-3">
              <label for="currentPassword" class="form-label">Current Password</label>
              <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
          </div>
          <div class="mb-3">
              <label for="newPassword" class="form-label">New Password</label>
              <input type="password" class="form-control" id="newPassword" name="newPassword" required>
          </div>
          <div class="mb-3">
              <label for="confirmPassword" class="form-label">Confirm New Password</label>
              <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
          </div>
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-success">Update Password</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
