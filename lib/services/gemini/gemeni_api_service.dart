import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeminiApiService {
  final String apiKey = 'AIzaSyB3Nqd1ZZNCFYKjJsXKkk4pkfI1_Q2Rm9I';

  final String endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=';

  Future<Map<String, dynamic>> getDailyMeals({
    required int age,
    required int heightCm,
    required int weightKg,
    String gender = "male",
  }) async {
    final prompt = '''
You are a meal planning API. Respond ONLY with a valid JSON object containing meal suggestions.
Create a meal plan for a $age-year-old $gender who is $heightCm cm tall and weighs $weightKg kg.

The response should be a JSON object with this exact structure:
{
  "breakfast": {
    "name": "string",
    "description": "string",
    "kcal": "string",
    "yields": "string",
    "cook_time": "string",
    "ingredients": ["string"]
  },
  "lunch": {
    "name": "string",
    "description": "string",
    "kcal": "string",
    "yields": "string",
    "cook_time": "string",
    "ingredients": ["string"]
  },
  "dinner": {
    "name": "string",
    "description": "string",
    "kcal": "string",
    "yields": "string",
    "cook_time": "string",
    "ingredients": ["string"]
  },
  "snacks": {
    "name": "string",
    "description": "string",
    "kcal": "string",
    "yields": "string",
    "cook_time": "string",
    "ingredients": ["string"]
  },
}

Focus on healthy, balanced nutrition appropriate for the person's metrics. Only respond with the JSON, no additional text.
''';

    final body = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    };

    final response = await http.post(
      Uri.parse('$endpoint$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      String cleanJson =
          response.body.replaceAll(RegExp(r'```json|```'), '').trim();

      final decoded = jsonDecode(cleanJson);
      final content = decoded["candidates"][0]["content"]["parts"][0]["text"];
      debugPrint('Response: $content');

      // Parse the content as JSON and return the Map
      try {
        final mealPlan = json.decode(content) as Map<String, dynamic>;
        return mealPlan;
      } catch (e) {
        throw Exception('Invalid JSON response from Gemini: $content');
      }
    } else {
      throw Exception('Failed to get meal suggestions: ${response.body}');
    }
  }
}
