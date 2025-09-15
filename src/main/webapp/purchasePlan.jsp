<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.alphaomen.dao.*" %>
<%@ page import="com.alphaomen.model.*" %>
<%@ page import="com.alphaomen.db.DB" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    
    if(user != null){
    	if(!user.isAdmin()) { // Only refresh non-admin users
            UserDAO userDAO = new UserDAO();
            user = userDAO.getUserById(user.getId());
            session.setAttribute("user", user);
        }
    }
    
    String transactionStatus = null;
    boolean hasPendingRequest = false;
    if(user != null) {
        TransactionDAO txDAO = new TransactionDAO();
        Transaction tx = txDAO.getLatestTransactionByUserId(user.getId());
        if(tx != null){
            transactionStatus = tx.getStatus();
            if(transactionStatus != null){
                transactionStatus = transactionStatus.trim().toLowerCase(); // normalize
                if("pending".equals(transactionStatus)){
                    hasPendingRequest = true;
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Purchase Premium Plan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f0f2f8;
        margin: 0;
        padding: 0;
    }

    h2, h3, h4 {
        color: #222;
    }

    a.btn-secondary {
        margin-bottom: 30px;
        border-radius: 8px;
        transition: 0.2s;
    }

    a.btn-secondary:hover {
        background-color: #555;
        color: #fff;
    }

    /* Premium Card */
    .premium-card {
        border-radius: 16px;
        border: 2px solid #ffc107;
        background: linear-gradient(135deg, #fff9e6 0%, #fffbe6 100%);
        padding: 25px;
        position: relative;
        box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        transition: transform 0.3s, box-shadow 0.3s;
    }

    .premium-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 30px rgba(0,0,0,0.15);
    }

    /* Badge */
    .badge-popular {
        position: absolute;
        top: 15px;
        right: 15px;
        background-color: #ff5722;
        color: #fff;
        padding: 6px 12px;
        font-size: 0.85rem;
        font-weight: 600;
        border-radius: 50px;
        text-transform: uppercase;
        box-shadow: 0 3px 8px rgba(0,0,0,0.1);
    }

    /* Features List */
    .list-group-item {
        font-size: 1rem;
        padding: 12px 15px;
        border: none;
        border-bottom: 1px solid #eee;
        background-color: transparent;
        display: flex;
        align-items: center;
    }

    .list-group-item:last-child {
        border-bottom: none;
    }

    .feature-icon {
        color: #28a745;
        margin-right: 12px;
        font-size: 1.1rem;
    }

    /* Form Inputs */
    input.form-control {
        border-radius: 8px;
        padding: 10px 12px;
        border: 1px solid #ddd;
        transition: border-color 0.3s, box-shadow 0.3s;
    }

    input.form-control:focus {
        border-color: #ffc107;
        box-shadow: 0 0 6px rgba(255, 193, 7, 0.3);
        outline: none;
    }

    button.btn-success {
        border-radius: 8px;
        padding: 10px 15px;
        font-weight: 600;
        transition: all 0.3s;
    }

    button.btn-success:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(0,0,0,0.12);
    }

    /* QR Code */
    img[src$="kbzpay_qr.png"] {
        border: 4px solid #ffc107;
        border-radius: 16px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        transition: transform 0.3s;
    }

    img[src$="kbzpay_qr.png"]:hover {
        transform: scale(1.05);
    }

    /* Alerts */
    .alert-info {
        border-radius: 12px;
        background-color: #e0f7fa;
        color: #006064;
        font-weight: 500;
        text-align: center;
    }

    .container {
        max-width: 800px;
    }

    @media (max-width: 768px) {
        .premium-card {
            padding: 20px;
        }
        .badge-popular {
            top: 10px;
            right: 10px;
            padding: 4px 10px;
        }
    }
</style>

</head>
<body class="p-5">

<div class="container">
    <!-- Back Button -->
    <a href="index.jsp" class="btn btn-secondary mb-4"><i class="fa-solid fa-arrow-left"></i> Back</a>

    <h2 class="mb-4">Purchase Premium Plan</h2>

    <!-- Pro Features Section -->
    <div class="mb-5">
        <h3>Why Upgrade to Premium?</h3>
        <ul class="list-group list-group-flush">
            <li class="list-group-item"><i class="fa-solid fa-check feature-icon"></i>Ad-free experience</li>
            <li class="list-group-item"><i class="fa-solid fa-check feature-icon"></i>Unlimited notes and categories</li>
            <li class="list-group-item"><i class="fa-solid fa-check feature-icon"></i>Advanced mood tracking insights</li>
            <li class="list-group-item"><i class="fa-solid fa-check feature-icon"></i>Access to exclusive themes</li>
        </ul>
    </div>

    <%
        PlanDAO planDAO = new PlanDAO();
        Plan premiumPlan = planDAO.getPlanByName("Premium Plan"); // Fetch only the Premium plan
        if (premiumPlan != null) {
    %>
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card p-3 premium-card">
                    <div class="badge-popular">Most Popular</div>

                    <h4 class="card-title"><%= premiumPlan.getName() %></h4>
                    <p class="card-text">Price: $<%= premiumPlan.getPrice() %> / <%= premiumPlan.getDurationMonths() %> months</p>
                    <p class="card-text">Ads: <%= premiumPlan.isAdsEnabled() ? "Enabled" : "Disabled" %></p>

					<!-- Show QR and form only if user has no pending or approved transaction -->
					<% if(transactionStatus == null || "pending".equals(transactionStatus) == false && "success".equals(transactionStatus) == false) { %>

                    <div class="mb-3 text-center">
                        <img src="assets/images/kbzpay_qr.jpg" alt="KBZPay QR" style="width:150px;height:150px;">
                    </div>
                    <form action="PurchaseServlet" method="post">
                        <input type="hidden" name="planId" value="<%= premiumPlan.getPlanId() %>">
                        <input type="hidden" name="amount" value="<%= premiumPlan.getPrice() %>">
                        <div class="mb-2">
                            <label>Transaction Reference from KBZPay</label>
                            <input type="text" name="userReference" class="form-control" required pattern="\d{20}" title="Transaction reference must be exactly 20 digits" maxlength="20" minlength="20">
                        </div>
                        <button type="submit" class="btn btn-success w-100">Submit Payment</button>
                    </form>
                    <% } else { %>
                    	<div class="alert alert-info text-center mt-3">
                    		<% if("pending".equals(transactionStatus)) { %>
                    			Pending...
                    		<% } else if("success".equals(transactionStatus)) { %>
                    			You are already a Premium user!
                    		<% } %>
                		</div>
                    <% } %>
                </div>
            </div>
        </div>
    <%
        } else {
    %>
        <div class="alert alert-warning">Premium plan is not available at the moment.</div>
    <%
        }
    %>
</div>
<script>
<%
UserDAO dao = new UserDAO();
User currentUser = dao.getUserWithSubscriptionDates(user.getId());
TransactionDAO txDAO = new TransactionDAO();
Transaction tx = txDAO.getLatestTransactionByUserId(user.getId());

if(tx != null && "success".equalsIgnoreCase(tx.getStatus())) {
%>
    window.addEventListener("DOMContentLoaded", function() {
        alert("🎉 Congratulations! You are now a Pro user.\n" +
              "Purchase Date: <%= currentUser.getPremiumStart() %>\n" +
              "Expiry Date: <%= currentUser.getPremiumExpiry() %>\n" +
              "Check them in your account info.");
    });
<%

}

if(transactionStatus != null) {
    if("pending".equals(transactionStatus)) {
%>
        alert("Your purchasing request is sent! Please wait for admin approval.");
<%
    } else if("failed".equals(transactionStatus)) {
%>
        alert("Your transaction was rejected. Please try again or contact support.");
<%
    }
}
%>
</script>


<!-- Bootstrap JS & FontAwesome -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/js/all.min.js"></script>

</body>
</html>
