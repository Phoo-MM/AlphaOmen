package com.alphaomen.engine;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.apache.commons.text.similarity.CosineSimilarity;
import java.util.*;

public class ChatbotEngine {
	private JSONArray intents;

	public ChatbotEngine(String jsonData) throws Exception { 
		JSONParser parser = new JSONParser(); 
		JSONObject obj = (JSONObject) parser.parse(jsonData); 
		intents = (JSONArray) obj.get("intents"); 
		}

	public String getResponse(String userInput) { 
		if (userInput == null || userInput.trim().isEmpty()) {
	        return getFallback();
	    }
		userInput = userInput.toLowerCase().trim(); 
		double bestScore = 0.0; 
		JSONObject bestIntent = null; 
		for (Object o : intents) { 
			JSONObject intent = (JSONObject) o;
			JSONArray patterns = (JSONArray) intent.get("patterns");
			for (Object p : patterns) { String pattern = p.toString().toLowerCase();
			double score = similarity(userInput, pattern);
			if (score > bestScore) { 
				bestScore = score; bestIntent = intent; 
			} 
		} 
	} // threshold 
		if (bestScore < 0.35 || bestIntent == null) { 
			return getFallback(); 
		} 
		
		JSONArray responses = (JSONArray) bestIntent.get("responses"); 
		Random rand = new Random(); 
		return responses.get(rand.nextInt(responses.size())).toString(); 
	} 
	
	private double similarity(String a, String b) { 
		Map<CharSequence, Integer> left = toVector(a); 
		Map<CharSequence, Integer> right = toVector(b); 
		CosineSimilarity cos = new CosineSimilarity(); 
		return cos.cosineSimilarity(left, right); 
	} 
	
	private Map<CharSequence, Integer> toVector(String text) { 
		Map<CharSequence, Integer> freq = new HashMap<>(); 
		for (String token : text.split("\\s+")) { 
			freq.put(token, freq.getOrDefault(token, 0) + 1); 
		} 
		return freq; 
	} 
	
	private String getFallback() { 
		for (Object o : intents) { 
			JSONObject intent = (JSONObject) o; 
			if (intent.get("intent").equals("fallback")) { 
				JSONArray responses = (JSONArray) intent.get("responses"); 
				return responses.get(0).toString(); 
			} 
		} 
		return "Sorry, I didn’t understand that."; 
	} 
}
