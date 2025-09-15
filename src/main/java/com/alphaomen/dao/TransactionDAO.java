package com.alphaomen.dao;

import com.alphaomen.db.DB;
import com.alphaomen.model.Transaction;

import java.sql.*;

public class TransactionDAO {

    public Transaction getLatestTransactionByUserId(int userId) {
        Transaction tx = null;
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT * FROM transactions WHERE user_id=? ORDER BY created_at DESC LIMIT 1")) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                tx = new Transaction();
                tx.setTransactionId(rs.getInt("transaction_id"));
                tx.setUserId(rs.getInt("user_id"));
                tx.setPlanId(rs.getInt("plan_id"));
                tx.setAmount(rs.getDouble("amount"));
                tx.setUserReference(rs.getString("user_reference"));
                tx.setStatus(rs.getString("status")); // PENDING, APPROVED, etc.
                tx.setCreatedAt(rs.getTimestamp("created_at"));
                tx.setUpdatedAt(rs.getTimestamp("updated_at"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tx;
    }
    
}
