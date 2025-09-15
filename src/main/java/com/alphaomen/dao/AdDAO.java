package com.alphaomen.dao;

import java.sql.*;
import java.util.*;
import com.alphaomen.db.DB;
import com.alphaomen.model.Ad;

public class AdDAO {

    public List<Ad> getActiveAds() {
        List<Ad> ads = new ArrayList<>();
        try(Connection conn = DB.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM ads WHERE is_active=1"
            );
            ResultSet rs = ps.executeQuery();
         // Collect ads by display type
            Map<String, List<Ad>> adsByType = new HashMap<>();
            while (rs.next()) {
                Ad ad = new Ad();
                ad.setAdId(rs.getInt("ad_id"));
                ad.setTitle(rs.getString("title"));
                ad.setContent(rs.getString("content"));
                ad.setImageUrl(rs.getString("image_url"));
                ad.setLinkUrl(rs.getString("link_url"));
                ad.setDisplayType(rs.getString("display_type").trim().toLowerCase());

                adsByType.computeIfAbsent(ad.getDisplayType(), k -> new ArrayList<>()).add(ad);
            }

         // Pick one random ad from each type
            Random rand = new Random();
            for (String type : adsByType.keySet()) {
                List<Ad> list = adsByType.get(type);
                if (!list.isEmpty()) {
                    Ad randomAd = list.get(rand.nextInt(list.size())); 
                    ads.add(randomAd); // only one ad per type
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return ads;
    }
}