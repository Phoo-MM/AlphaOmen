package com.alphaomen.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.alphaomen.db.DB;
import com.alphaomen.model.Plan;

public class PlanDAO {
    public List<Plan> getAllPlans() {
        List<Plan> plans = new ArrayList<>();
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM plan")) {
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Plan plan = new Plan();
                plan.setPlanId(rs.getInt("plan_id"));
                plan.setName(rs.getString("name"));
                plan.setAdsEnabled(rs.getBoolean("ads_enabled"));
                plan.setPrice(rs.getDouble("price"));
                plan.setDurationMonths(rs.getInt("duration_months"));
                plans.add(plan);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return plans;
    }
    
    public Plan getPlanById(int planId) {
        Plan plan = null;
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM plan WHERE plan_id=?")) {
            ps.setInt(1, planId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                plan = new Plan();
                plan.setPlanId(rs.getInt("plan_id"));
                plan.setName(rs.getString("name"));
                plan.setAdsEnabled(rs.getBoolean("ads_enabled"));
                plan.setPrice(rs.getDouble("price"));
                plan.setDurationMonths(rs.getInt("duration_months"));
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return plan;
    }
    
    public Plan getPlanByName(String name) {
        Plan plan = null;
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM plan WHERE name=?")) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                plan = new Plan();
                plan.setPlanId(rs.getInt("plan_id"));
                plan.setName(rs.getString("name"));
                plan.setAdsEnabled(rs.getBoolean("ads_enabled"));
                plan.setPrice(rs.getDouble("price"));
                plan.setDurationMonths(rs.getInt("duration_months"));
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return plan;
    }

}
