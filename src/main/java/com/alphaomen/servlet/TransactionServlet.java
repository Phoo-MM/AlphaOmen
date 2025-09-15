package com.alphaomen.servlet;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import com.alphaomen.db.DB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/TransactionServlet")
public class TransactionServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String tidParam = request.getParameter("transaction_id");
        if(tidParam == null) {
            response.sendRedirect("admin.jsp?error=MissingTransactionId");
            return;
        }
        int transactionId = Integer.parseInt(tidParam);
        
        try (Connection conn = DB.getConnection()) {

            // Fetch transaction details
            PreparedStatement ps1 = conn.prepareStatement("SELECT user_id, plan_id, user_reference FROM transactions WHERE transaction_id=?");
            ps1.setInt(1, transactionId);
            ResultSet rs = ps1.executeQuery();

            if(rs.next()) {
                int userId = rs.getInt("user_id");
                int planId = rs.getInt("plan_id");
                String userReference = rs.getString("user_reference"); // get user input reference
                
                if("approve".equalsIgnoreCase(action)) {

                	// Update transaction: status=SUCCESS, reference_number=userReference
                    PreparedStatement ps2 = conn.prepareStatement(
                        "UPDATE transactions SET status='SUCCESS', reference_number=? WHERE transaction_id=?"
                    );
                    ps2.setString(1, userReference);
                    ps2.setInt(2, transactionId);
                    ps2.executeUpdate();

                    // Update user's current plan
                    PreparedStatement ps3 = conn.prepareStatement(
                        "UPDATE users SET plan_id=? WHERE user_id=?"
                    );
                    ps3.setInt(1, planId);
                    ps3.setInt(2, userId);
                    ps3.executeUpdate();

                    // Insert subscription
                    LocalDate start = LocalDate.now();
                    PreparedStatement ps5 = conn.prepareStatement("SELECT duration_months FROM plan WHERE plan_id=?");
                    ps5.setInt(1, planId);
                    ResultSet rs2 = ps5.executeQuery();
                    int duration = 12;
                    if(rs2.next()) duration = rs2.getInt("duration_months");
                    LocalDate end = start.plusMonths(duration);

                    PreparedStatement ps4 = conn.prepareStatement(
                    	    "INSERT INTO subscription(user_id, plan_id, transaction_id, start_date, end_date, is_active) VALUES (?, ?, ?, ?, ?, ?)"
                    	);
                    	ps4.setInt(1, userId);
                    	ps4.setInt(2, planId);
                    	ps4.setInt(3, transactionId); // transaction_id
                    	ps4.setDate(4, java.sql.Date.valueOf(start)); // start_date
                    	ps4.setDate(5, java.sql.Date.valueOf(end));   // end_date
                    	ps4.setInt(6, 1); // is_active
                    	ps4.executeUpdate();

                    
                    HttpSession session = request.getSession();
                    session.setAttribute("showPremiumAlert",true);
                    
                } else if("reject".equalsIgnoreCase(action)) {
                    String reason = request.getParameter("reason") != null ? request.getParameter("reason") : "No reason provided";

                    // Set status FAILED and store rejection reason in reference_number
                    PreparedStatement ps6 = conn.prepareStatement(
                        "UPDATE transactions SET status='FAILED', reference_number=? WHERE transaction_id=?"
                    );
                    ps6.setString(1, reason);
                    ps6.setInt(2, transactionId);
                    ps6.executeUpdate();
                } else if("verify".equalsIgnoreCase(action)) {
                    String kbzpayId = request.getParameter("kbzpay_id");
                    
                    // Optional: check if kbzpayId equals user_reference
                    if(kbzpayId != null && kbzpayId.trim().equals(userReference.trim())) {
                        PreparedStatement psVerify = conn.prepareStatement(
                            "UPDATE transactions SET verified=1, reference_number=? WHERE transaction_id=?"
                        );
                        psVerify.setString(1, kbzpayId); // store actual verified payment ID
                        psVerify.setInt(2, transactionId);
                        psVerify.executeUpdate();
                    } else {
                        // Optional: show an error if KBZPay ID doesn't match
                        HttpSession session = request.getSession();
                        session.setAttribute("verifyError", "KBZPay ID does not match user input!");
                    }
                }

                
            }

            response.sendRedirect("admin.jsp");

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=1");
        }
    }
}
