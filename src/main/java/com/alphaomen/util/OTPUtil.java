package com.alphaomen.util;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.concurrent.ThreadLocalRandom;

public class OTPUtil {
    private static final SecureRandom random = new SecureRandom();
    
    public static String generateOTP() {
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            otp.append(random.nextInt(10));
        }
        return otp.toString();
    }
    
    public static boolean isOTPValid(LocalDateTime expiryTime) {
        LocalDateTime now = LocalDateTime.now();
        return now.isBefore(expiryTime);
    }
    
    public static LocalDateTime getExpiryTime() {
        return LocalDateTime.now().plus(10, ChronoUnit.MINUTES); // OTP valid for 10 minutes
    }
}