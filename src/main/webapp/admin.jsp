<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.alphaomen.model.User" %>
<%@ page import="com.alphaomen.dao.UserDAO" %>
<%@ page import="com.alphaomen.dao.NoteDAO" %>
<%@ page import="com.alphaomen.db.DB" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.lineicons.com/5.0/lineicons.css" />
<style>
  /* General Reset */
  body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f0f2f5;
    margin: 0;
    padding: 0;
  }

  /* Sidebar */
  .sidebar {
    width: 260px;
    position: fixed;
    top: 0;
    left: 0;
    height: 100%;
    background: #1e2a38;
    color: #fff;
    padding-top: 30px;
    transition: 0.3s;
    box-shadow: 2px 0 10px rgba(0,0,0,0.1);
  }

  .sidebar h4 {
    font-weight: 600;
    margin-bottom: 30px;
    color: #fff;
  }

  .sidebar a {
    display: block;
    padding: 14px 25px;
    color: #cfd8dc;
    text-decoration: none;
    font-weight: 500;
    border-radius: 8px;
    margin: 5px 10px;
    transition: all 0.2s ease;
  }

  .sidebar a:hover {
    background: #34495e;
    color: #fff;
    padding-left: 30px;
  }

  /* Main Content */
  .main-content {
    margin-left: 260px;
    padding: 30px;
    transition: margin-left 0.3s;
  }

  h2, h4 {
    color: #333;
  }

  /* Cards */
  .card {
    border-radius: 12px;
    box-shadow: 0 3px 10px rgba(0,0,0,0.05);
    transition: all 0.3s ease;
  }

  .card:hover {
    box-shadow: 0 6px 20px rgba(0,0,0,0.1);
  }

  .card img {
    width: 100%;
    object-fit: cover;
    border-radius: 8px;
  }

  .card-body {
    display: flex;
    flex-direction: column;
  }

  /* Tables */
  table.table {
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 3px 10px rgba(0,0,0,0.05);
    background-color: #fff;
  }

  table.table th {
    background-color: #1e2a38;
    color: #fff;
    font-weight: 600;
  }

  table.table td, table.table th {
    padding: 12px 15px;
    vertical-align: middle;
  }

  /* Buttons */
  .btn-sm {
    border-radius: 6px;
    font-size: 0.85rem;
    padding: 4px 10px;
    transition: all 0.2s;
  }

  .btn-sm:hover {
    transform: translateY(-2px);
    box-shadow: 0 3px 10px rgba(0,0,0,0.1);
  }

  /* Ads Cards */
  .ad-card-banner, .ad-card-sidebar, .ad-card-popup {
    border-radius: 12px;
    transition: transform 0.2s, box-shadow 0.2s;
  }

  .ad-card-banner:hover, .ad-card-sidebar:hover, .ad-card-popup:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.15);
  }

  /* Modals */
  .modal-content {
    border-radius: 12px;
  }

  /* Responsive adjustments */
  @media (max-width: 992px) {
    .sidebar {
      width: 200px;
    }
    .main-content {
      margin-left: 200px;
      padding: 20px;
    }
  }

  @media (max-width: 768px) {
    .sidebar {
      position: relative;
      width: 100%;
      height: auto;
      box-shadow: none;
    }
    .main-content {
      margin-left: 0;
      padding: 20px;
    }
  }

</style>

</head>
<body>
  <!-- Sidebar -->
  <div class="sidebar">
    <h4 class="text-center mb-4">Admin Dashboard</h4>
    <a href="#users"><i class="lni lni-users"></i> User Management</a>
    <a href="#transactions"><i class="lni lni-briefcase"></i> Transactions</a>
    <a href="#business"><i class="lni lni-briefcase"></i> Business</a>
    <a href="#ads"><i class="lni lni-ads"></i> Ads</a>
    <a href="index.jsp" class="text-danger"><i class="lni lni-exit"></i> Back to home</a>
  </div>

  <!-- Main content -->
  <div class="main-content">
    <div class="container-fluid">
      <h2>Welcome, Admin</h2>
      <p>Manage users, subscriptions, ads, and notes here.</p>

      <!-- User Management -->
      <div id="users" class="mt-5">
        <h4>Manage Users</h4>
        <div class="card p-3">
  <table class="table table-striped">
    <thead>
      <tr>
        <th>Username</th>
        <th>Notes Count</th>
        <th>Plan</th>
        <th>Purchase Date</th>
        <th>Expiry Date</th>
        <th>Actions</th>
      </tr>
    </thead>
    	<tbody>
        	<%
                UserDAO userDAO = new UserDAO();
                List<User> users = userDAO.getAllUsersForAdmin();
                for (User u : users) {
            %>
                <tr>
                  <td><%= u.getUsername() %></td>
                  <td><%= u.getNoteCount() %></td>
                  <td><%= u.getPremiumPlan() != null ? u.getPremiumPlan() : "Free Plan" %></td>
                  <td><%= u.getPremiumStart() != null ? new java.text.SimpleDateFormat("dd MMM yyyy").format(u.getPremiumStart()) : "N/A" %></td>
                  <td><%= u.getPremiumExpiry() != null ? new java.text.SimpleDateFormat("dd MMM yyyy").format(u.getPremiumExpiry()) : "N/A" %></td>
                  <td>
                    <a href="UserAccServlet?action=delete&id=<%= u.getId() %>" class="btn btn-sm btn-danger"
                       onclick="return confirm('Are you sure?')">Delete</a>
                  </td>
                </tr>
              <% } %>
           </tbody>
  	</table>
	</div>
   </div>

		<!-- Transaction History -->
		<div id="transactions" class="mt-5">
		    <h4>Transaction History</h4>
		    <table class="table table-striped">
		        <thead>
		            <tr>
		                <th>User</th>
		                <th>Plan</th>
		                <th>Amount</th>
		                <th>Payment Method</th>
		                <th>User Reference</th>
		                <th>Reference Number</th>
		                <th>Status</th>
		                <th>Verification</th>
		                <th>Actions</th>
		            </tr>
		        </thead>
		        <tbody>
		        <%
		            Connection conn = null;
		            PreparedStatement ps = null;
		            ResultSet rs = null;
		            try {
		                conn = DB.getConnection();
		                ps = conn.prepareStatement(
		                		"SELECT t.transaction_id, u.username, p.name, t.amount, t.payment_method, t.user_reference, t.reference_number, t.status, t.verified " +
		                			    "FROM transactions t " +
		                			    "JOIN users u ON t.user_id = u.user_id " +
		                			    "JOIN plan p ON t.plan_id = p.plan_id " +
		                			    "ORDER BY t.transaction_id DESC"
		                );
		                rs = ps.executeQuery();
		                while(rs.next()) {
		                    int tid = rs.getInt("transaction_id");
		                    String username = rs.getString("username");
		                    String planName = rs.getString("name");
		                    double amount = rs.getDouble("amount");
		                    String method = rs.getString("payment_method");
		                    String userRef = rs.getString("user_reference");
		                    String refNum = rs.getString("reference_number");
		                    String status = rs.getString("status");
		                    boolean verified = rs.getInt("verified")==1;
		        %>
		            <tr>
		                <td><%= username %></td>
		                <td><%= planName %></td>
		                <td>$<%= amount %></td>
		                <td><%= method %></td>
		                <td><%= userRef %></td>
		                <td><%= refNum != null ? refNum : "N/A" %></td>
		                <td><%= status %></td>
		                <td><%= verified ? "<span class='text-success'>Verified</span>" : "<span class='text-danger'>Not Verified</span>" %>
		                </td>
		                <td>
					  <% if(status.equals("PENDING")) { %>
					      <% if(!verified) { %>
					          <form action="TransactionServlet" method="get" style="display:inline;">
					              <input type="hidden" name="action" value="verify">
					              <input type="hidden" name="transaction_id" value="<%= tid %>">
					              <input type="text" name="kbzpay_id" placeholder="KBZPay ID" required pattern="\d{20}" title="Transaction reference must be exactly 20 digits" maxlength="20" minlength="20">
					              <button type="submit" class="btn btn-sm btn-warning">Verify</button>
					          </form>
					          <button class="btn btn-sm btn-success" disabled>Approve</button>
					          <button class="btn btn-sm btn-danger">Reject</button>
					      <% } else { %>
					          <a href="TransactionServlet?action=approve&transaction_id=<%= tid %>" class="btn btn-sm btn-success">Approve</a>
          					  <a href="TransactionServlet?action=reject&transaction_id=<%= tid %>" class="btn btn-sm btn-danger">Reject</a>
					      <% } %>
					  <% } else { %>
					      -
					  <% } %>
					</td>

		            </tr>
		        <%
		                }
		            } catch(Exception e) {
		                out.println("<tr><td colspan='8'>Error: "+e.getMessage()+"</td></tr>");
		            } finally {
		                if(rs != null) try{rs.close();}catch(Exception ignore){}
		                if(ps != null) try{ps.close();}catch(Exception ignore){}
		                if(conn != null) try{conn.close();}catch(Exception ignore){}
		            }
		        %>
		        </tbody>
		    </table>
		</div>
	
      <!-- Business -->
      <div id="business" class="mt-5">
        <h4>Business & Subscription</h4>
        <div class="row">
        <%
        	try {
        		conn = DB.getConnection();
        		ps = conn.prepareStatement("SELECT plan_id, name, ads_enabled, price, duration_months FROM plan");
        		rs = ps.executeQuery();
        		while (rs.next()) {
        			int planId = rs.getInt("plan_id");
        			String name = rs.getString("name");
        			boolean adsEnabled = rs.getBoolean("ads_enabled");
        			double price = rs.getDouble("price");
        			int duration = rs.getInt("duration_months");
        %>
          <div class="col-md-6">
            <div class="card p-3">
              <h6><%= name %></h6>
              <p><strong>Price:</strong> $<%= price %> / <%= duration %> months</p>
              <p><strong>Ads:</strong>
              	<%= adsEnabled ? "Enabled" : "Disabled" %>
              </p>
              <div class="d-flex gap-2">
              	<!-- Toggle Ads -->
              	<form action="PlanServlet" method="post" style="display: inline;">
              		<input type="hidden" name="action" value="toggle">
				    <input type="hidden" name="planId" value="<%= planId %>">
				    <button type="submit" class="btn btn-sm <%= adsEnabled ? "btn-danger" : "btn-success" %>" <%= "Free Plan".equals(name) ? "disabled" : "" %>>
				      <%= adsEnabled ? "Disable Ads" : "Enable Ads" %>
				    </button>
				  </form>
				
				  <!-- Edit Plan -->
				  <form action="PlanServlet" method="post" style="display:inline;">
				    <input type="hidden" name="action" value="edit">
				    <input type="hidden" name="planId" value="<%= planId %>">
				    <!-- keep it simple, just price + duration -->
				    <input type="text" name="price" value="<%= price %>" size="4" <%= "Free Plan".equals(name) ? "readonly" : "" %>>
				    <input type="text" name="duration" value="<%= duration %>" size="2" <%= "Free Plan".equals(name) ? "readonly" : "" %>>
				    <button type="submit" class="btn btn-sm btn-primary" <%= "Free Plan".equals(name) ? "disabled" : "" %>>Update</button>
				  </form>
				</div>
				              
			</div>
		</div>
		<%
			}
		} catch (Exception e) {
			out.println("<div class='alert alert-danger'>Error loading plans: " + e.getMessage() + "</div>");
		} finally {
			if (rs != null) try { rs.close(); } catch (Exception ignore) {}
	        if (ps != null) try { ps.close(); } catch (Exception ignore) {}
	        if (conn != null) try { conn.close(); } catch (Exception ignore) {}
	      }
	    %>
        </div>
      </div>
      
		<!-- Ads Management -->
		<div id="ads" class="mt-5">
		  <h4>Ads Management</h4>
		
		  <!-- Button to toggle Add New Ad form -->
		  <div class="d-flex justify-content-between align-items-center mb-3">
		    <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addAdModal">+ Add Ad</button>
		  </div>
		
		  <!-- Add New Ad Form (collapsed by default) -->
		  <div class="collapse" id="addAdForm">
		    <div class="card card-body mb-4">
		      <h5>Add New Ad</h5>
		      <form action="AdServlet" method="post">
		        <input type="hidden" name="action" value="add">
		        <div class="mb-2">
		          <label class="form-label">Title</label>
		          <input type="text" name="title" class="form-control" required>
		        </div>
		        <div class="mb-2">
		          <label class="form-label">Content</label>
		          <textarea name="content" class="form-control" rows="3"></textarea>
		        </div>
		        <div class="mb-2">
		          <label class="form-label">Image URL</label>
		          <input type="text" name="imageUrl" class="form-control">
		        </div>
		        <div class="mb-2">
		          <label class="form-label">Link URL</label>
		          <input type="text" name="linkUrl" class="form-control">
		        </div>
		        <div class="mb-2">
		          <label class="form-label">Display Type</label>
		          <select name="displayType" class="form-select">
		            <option value="popup">Popup</option>
		            <option value="banner">Banner</option>
		            <option value="sidebar">Sidebar</option>
		          </select>
		        </div>
		        <button type="submit" class="btn btn-success">Add Ad</button>
		      </form>
		    </div>
		  </div>
		
		  <!-- Ads Gallery Grouped by Type -->
		  <div class="row">
		  
		  <!-- Banner Ads Column -->
        <div class="col-lg-4 mb-4">
            <h4>Banner Ads</h4>
            <div class="row g-3">
                <%
                    try {
                        conn = DB.getConnection();
                        ps = conn.prepareStatement("SELECT * FROM ads WHERE display_type='banner' ORDER BY ad_id DESC");
                        rs = ps.executeQuery();
                        while(rs.next()){
                            int adId = rs.getInt("ad_id");
                            String title = rs.getString("title");
                            String content = rs.getString("content");
                            String imageUrl = rs.getString("image_url");
                            String linkUrl = rs.getString("link_url");
                            boolean isActive = rs.getBoolean("is_active");
                %>
                <div class="col-12">
                    <div class="card ad-card-banner shadow-sm">
                        <% if(imageUrl!=null && !imageUrl.isEmpty()){ %>
                        <img src="<%= imageUrl %>" alt="<%= title %>">
                        <% } else { %>
                        <div class="bg-secondary text-white d-flex justify-content-center align-items-center" style="height:120px;">No Image</div>
                        <% } %>
                        <div class="card-body p-2">
                            <h5 class="card-title"><%= title %></h5>
                            <div class="d-flex justify-content-between">
                                <a href="AdServlet?action=toggle&adId=<%= adId %>" class="btn btn-sm <%= isActive?"btn-danger":"btn-success" %>"><%= isActive?"Deactivate":"Activate" %></a>
                                <a href="#" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#editAdModal<%= adId %>">Edit</a>
                                <a href="AdServlet?action=delete&adId=<%= adId %>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Edit Modal -->
                    <div class="modal fade" id="editAdModal<%= adId %>" tabindex="-1" aria-hidden="true">
                      <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                          <form action="AdServlet" method="post">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="adId" value="<%= adId %>">
                            <div class="modal-header">
                                <h5 class="modal-title">Edit Ad</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label>Title</label>
                                    <input type="text" name="title" class="form-control" value="<%= title %>" required>
                                </div>
                                <div class="mb-3">
                                    <label>Content</label>
                                    <textarea name="content" class="form-control" rows="3" required><%= content %></textarea>
                                </div>
                                <div class="mb-3">
                                    <label>Image URL</label>
                                    <input type="text" name="imageUrl" class="form-control" value="<%= imageUrl %>">
                                </div>
                                <div class="mb-3">
                                    <label>Link URL</label>
                                    <input type="text" name="linkUrl" class="form-control" value="<%= linkUrl %>">
                                </div>
                                <div class="mb-3">
                                    <label>Display Type</label>
                                    <select name="displayType" class="form-select" required>
                                        <option value="sidebar" <%= "sidebar".equals(rs.getString("display_type"))?"selected":"" %>>Sidebar</option>
                                        <option value="banner" <%= "banner".equals(rs.getString("display_type"))?"selected":"" %>>Banner</option>
                                        <option value="popup" <%= "popup".equals(rs.getString("display_type"))?"selected":"" %>>Popup</option>
                                    </select>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="isActive" id="isActive<%= adId %>" <%= isActive?"checked":"" %>>
                                    <label class="form-check-label" for="isActive<%= adId %>">Active</label>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </div>
                          </form>
                        </div>
                      </div>
                    </div>
                </div>
                <% 
                        }
                    } catch(Exception e){ out.println(e); }
                    finally{
                        if(rs!=null) try{ rs.close(); } catch(Exception ignore){}
                        if(ps!=null) try{ ps.close(); } catch(Exception ignore){}
                        if(conn!=null) try{ conn.close(); } catch(Exception ignore){}
                    }
                %>
            </div>
        </div>
		    
		    <!-- Sidebar Ads Column -->
        <div class="col-lg-4 mb-4">
            <h4>Sidebar Ads</h4>
            <div class="row g-3">
                <%
                    try {
                        conn = DB.getConnection();
                        ps = conn.prepareStatement("SELECT * FROM ads WHERE display_type='sidebar' ORDER BY ad_id DESC");
                        rs = ps.executeQuery();
                        while(rs.next()){
                            int adId = rs.getInt("ad_id");
                            String title = rs.getString("title");
                            String content = rs.getString("content");
                            String imageUrl = rs.getString("image_url");
                            String linkUrl = rs.getString("link_url");
                            boolean isActive = rs.getBoolean("is_active");
                %>
                <div class="col-12">
                    <div class="card ad-card-sidebar shadow-sm">
                        <% if(imageUrl!=null && !imageUrl.isEmpty()){ %>
                        <img src="<%= imageUrl %>" alt="<%= title %>">
                        <% } else { %>
                        <div class="bg-secondary text-white d-flex justify-content-center align-items-center" style="height:200px;">No Image</div>
                        <% } %>
                        <div class="card-body p-2">
                            <h5 class="card-title"><%= title %></h5>
                            <p class="mb-1"><%= content %></p>
                            <div class="d-flex justify-content-between">
                                <a href="AdServlet?action=toggle&adId=<%= adId %>" class="btn btn-sm <%= isActive?"btn-danger":"btn-success" %>"><%= isActive?"Deactivate":"Activate" %></a>
                                <a href="#" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#editAdModal<%= adId %>">Edit</a>
                                <a href="AdServlet?action=delete&adId=<%= adId %>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
                            </div>
                        </div>
                    </div>
                </div>
                <% 
                        }
                    } catch(Exception e){ out.println(e); }
                    finally{
                        if(rs!=null) try{ rs.close(); } catch(Exception ignore){}
                        if(ps!=null) try{ ps.close(); } catch(Exception ignore){}
                        if(conn!=null) try{ conn.close(); } catch(Exception ignore){}
                    }
                %>
            </div>
        </div>

		    <!-- Popup Ads Column -->
        <div class="col-lg-4 mb-4">
            <h4>Popup Ads</h4>
            <div class="row g-3">
                <%
                    try {
                        conn = DB.getConnection();
                        ps = conn.prepareStatement("SELECT * FROM ads WHERE display_type='popup' ORDER BY ad_id DESC");
                        rs = ps.executeQuery();
                        while(rs.next()){
                            int adId = rs.getInt("ad_id");
                            String title = rs.getString("title");
                            String content = rs.getString("content");
                            String imageUrl = rs.getString("image_url");
                            String linkUrl = rs.getString("link_url");
                            boolean isActive = rs.getBoolean("is_active");
                %>
                <div class="col-12">
                    <div class="card ad-card-popup shadow-sm">
                        <% if(imageUrl!=null && !imageUrl.isEmpty()){ %>
                        <img src="<%= imageUrl %>" alt="<%= title %>">
                        <% } else { %>
                        <div class="bg-secondary text-white d-flex justify-content-center align-items-center" style="height:200px;">No Image</div>
                        <% } %>
                        <div class="card-body p-2">
                            <h5 class="card-title"><%= title %></h5>
                            <div class="d-flex justify-content-between">
                                <a href="AdServlet?action=toggle&adId=<%= adId %>" class="btn btn-sm <%= isActive?"btn-danger":"btn-success" %>"><%= isActive?"Deactivate":"Activate" %></a>
                                <a href="#" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#editAdModal<%= adId %>">Edit</a>
                                <a href="AdServlet?action=delete&adId=<%= adId %>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
                            </div>
                        </div>
                    </div>
                </div>
                <% 
                        }
                    } catch(Exception e){ out.println(e); }
                    finally{
                        if(rs!=null) try{ rs.close(); } catch(Exception ignore){}
                        if(ps!=null) try{ ps.close(); } catch(Exception ignore){}
                        if(conn!=null) try{ conn.close(); } catch(Exception ignore){}
                    }
                %>
            </div>
        </div>

        
        <!-- Add Ad Modal -->
		<div class="modal fade" id="addAdModal" tabindex="-1" aria-hidden="true">
		  <div class="modal-dialog modal-lg">
		    <div class="modal-content">
		      <form action="AdServlet" method="post">
		        <input type="hidden" name="action" value="add">
		        <div class="modal-header">
		            <h5 class="modal-title">Add New Ad</h5>
		            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
		        </div>
		        <div class="modal-body">
		            <div class="mb-3">
		                <label>Title</label>
		                <input type="text" name="title" class="form-control" required>
		            </div>
		            <div class="mb-3">
		                <label>Content</label>
		                <textarea name="content" class="form-control" rows="3" required></textarea>
		            </div>
		            <div class="mb-3">
		                <label>Image URL</label>
		                <input type="text" name="imageUrl" class="form-control">
		            </div>
		            <div class="mb-3">
		                <label>Link URL</label>
		                <input type="text" name="linkUrl" class="form-control">
		            </div>
		            <div class="mb-3">
		                <label>Display Type</label>
		                <select name="displayType" class="form-select" required>
		                    <option value="sidebar">Sidebar</option>
		                    <option value="banner">Banner</option>
		                    <option value="popup">Popup</option>
		                </select>
		            </div>
		            <div class="form-check">
		                <input class="form-check-input" type="checkbox" name="isActive" id="addIsActive" checked>
		                <label class="form-check-label" for="addIsActive">Active</label>
		            </div>
		        </div>
		        <div class="modal-footer">
		            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
		            <button type="submit" class="btn btn-success">Add Ad</button>
		        </div>
		      </form>
		    </div>
		  </div>
		</div>
        <!-- End of Ad Modal -->
		</div>
		
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
