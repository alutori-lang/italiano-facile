import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// One vocabulary category.
///
/// [accent] is used ONLY for the icon background and the category tile. It is
/// never applied to body text and never replaces the reserved Italian red.
class Topic {
  const Topic({
    required this.id,
    required this.emoji,
    required this.icon,
    required this.accent,
  });

  final String id;
  final String emoji;
  final IconData icon;
  final Color accent;

  String label(AppLocalizations t) => topicLabel(t, id);
}

String topicLabel(AppLocalizations t, String id) {
  switch (id) {
    case 'greetings':
      return t.topicGreetings;
    case 'numbers':
      return t.topicNumbers;
    case 'colors':
      return t.topicColors;
    case 'time':
      return t.topicTime;
    case 'family':
      return t.topicFamily;
    case 'body':
      return t.topicBody;
    case 'health':
      return t.topicHealth;
    case 'pharmacy':
      return t.topicPharmacy;
    case 'food':
      return t.topicFood;
    case 'fruit':
      return t.topicFruit;
    case 'vegetables':
      return t.topicVegetables;
    case 'drinks':
      return t.topicDrinks;
    case 'cooking':
      return t.topicCooking;
    case 'shopping':
      return t.topicShopping;
    case 'money':
      return t.topicMoney;
    case 'house':
      return t.topicHouse;
    case 'kitchen':
      return t.topicKitchen;
    case 'bathroom':
      return t.topicBathroom;
    case 'clothes':
      return t.topicClothes;
    case 'weather':
      return t.topicWeather;
    case 'city':
      return t.topicCity;
    case 'transport':
      return t.topicTransport;
    case 'work':
      return t.topicWork;
    case 'jobs':
      return t.topicJobs;
    case 'offices':
      return t.topicOffices;
    case 'school':
      return t.topicSchool;
    case 'animals':
      return t.topicAnimals;
    case 'nature':
      return t.topicNature;
    case 'sport':
      return t.topicSport;
    case 'feelings':
      return t.topicFeelings;
    case 'verbs':
      return t.topicVerbs;
    case 'adjectives':
      return t.topicAdjectives;
    case 'phrases':
      return t.topicPhrases;
    default:
      return id;
  }
}

/// Every category, in learning order.
const List<Topic> kTopics = <Topic>[
  Topic(id: 'greetings', emoji: '👋', icon: Icons.waving_hand_rounded, accent: Color(0xFF3B7A57)),
  Topic(id: 'numbers', emoji: '🔢', icon: Icons.pin_rounded, accent: Color(0xFF3F6FA8)),
  Topic(id: 'colors', emoji: '🎨', icon: Icons.palette_rounded, accent: Color(0xFF8E5BA6)),
  Topic(id: 'time', emoji: '📅', icon: Icons.calendar_month_rounded, accent: Color(0xFF2F6F7E)),
  Topic(id: 'family', emoji: '👨‍👩‍👧', icon: Icons.family_restroom_rounded, accent: Color(0xFFB4654A)),
  Topic(id: 'body', emoji: '🦵', icon: Icons.accessibility_new_rounded, accent: Color(0xFF9C5B6E)),
  Topic(id: 'health', emoji: '🏥', icon: Icons.local_hospital_rounded, accent: Color(0xFF2E7D6B)),
  Topic(id: 'pharmacy', emoji: '💊', icon: Icons.medication_rounded, accent: Color(0xFF4E7D3A)),
  Topic(id: 'food', emoji: '🍽️', icon: Icons.restaurant_rounded, accent: Color(0xFFB07A2A)),
  Topic(id: 'fruit', emoji: '🍎', icon: Icons.apple_rounded, accent: Color(0xFFBE5A3C)),
  Topic(id: 'vegetables', emoji: '🥕', icon: Icons.grass_rounded, accent: Color(0xFF4F7A33)),
  Topic(id: 'drinks', emoji: '☕', icon: Icons.local_cafe_rounded, accent: Color(0xFF8A5A33)),
  Topic(id: 'cooking', emoji: '🍳', icon: Icons.soup_kitchen_rounded, accent: Color(0xFFA8732F)),
  Topic(id: 'shopping', emoji: '🛒', icon: Icons.shopping_cart_rounded, accent: Color(0xFF3E6DA3)),
  Topic(id: 'money', emoji: '💶', icon: Icons.account_balance_rounded, accent: Color(0xFF2F7355)),
  Topic(id: 'house', emoji: '🏠', icon: Icons.home_rounded, accent: Color(0xFF7A6A4F)),
  Topic(id: 'kitchen', emoji: '🍴', icon: Icons.countertops_rounded, accent: Color(0xFF9A6B3F)),
  Topic(id: 'bathroom', emoji: '🚿', icon: Icons.bathtub_rounded, accent: Color(0xFF3C7D96)),
  Topic(id: 'clothes', emoji: '👕', icon: Icons.checkroom_rounded, accent: Color(0xFF6A5FA8)),
  Topic(id: 'weather', emoji: '🌦️', icon: Icons.wb_sunny_rounded, accent: Color(0xFF3D7EA6)),
  Topic(id: 'city', emoji: '🏙️', icon: Icons.location_city_rounded, accent: Color(0xFF5A6B7C)),
  Topic(id: 'transport', emoji: '🚌', icon: Icons.directions_bus_rounded, accent: Color(0xFF2F6E8F)),
  Topic(id: 'work', emoji: '💼', icon: Icons.work_rounded, accent: Color(0xFF6B5B45)),
  Topic(id: 'jobs', emoji: '🧑‍🔧', icon: Icons.engineering_rounded, accent: Color(0xFF8A6A2F)),
  Topic(id: 'offices', emoji: '🏛️', icon: Icons.account_balance_wallet_rounded, accent: Color(0xFF4A5E8C)),
  Topic(id: 'school', emoji: '🎒', icon: Icons.school_rounded, accent: Color(0xFFA85A2F)),
  Topic(id: 'animals', emoji: '🐕', icon: Icons.pets_rounded, accent: Color(0xFF7A5230)),
  Topic(id: 'nature', emoji: '🌳', icon: Icons.park_rounded, accent: Color(0xFF3E7A3E)),
  Topic(id: 'sport', emoji: '⚽', icon: Icons.sports_soccer_rounded, accent: Color(0xFF2E7A72)),
  Topic(id: 'feelings', emoji: '😊', icon: Icons.emoji_emotions_rounded, accent: Color(0xFFA9603F)),
  Topic(id: 'verbs', emoji: '🏃', icon: Icons.bolt_rounded, accent: Color(0xFF7A4F8A)),
  Topic(id: 'adjectives', emoji: '✨', icon: Icons.auto_awesome_rounded, accent: Color(0xFF8A7A2F)),
  Topic(id: 'phrases', emoji: '💬', icon: Icons.chat_bubble_rounded, accent: Color(0xFF4F6B8A)),
];

final Map<String, Topic> kTopicsById = <String, Topic>{
  for (final Topic t in kTopics) t.id: t,
};
