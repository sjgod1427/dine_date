// user_preferences.dart
import 'package:flutter/foundation.dart';

class UserPreferences with ChangeNotifier {
  List<String> selectedPronouns = [];
  List<String> selectedDiets = [];
  List<String> selectedEatingHabits = [];
  List<String> selectedDineInOut = [];

  void updateSelection(String category, String value) {
    if (category == 'pronouns') {
      selectedPronouns.contains(value)
          ? selectedPronouns.remove(value)
          : selectedPronouns.add(value);
    } else if (category == 'diets') {
      selectedDiets.contains(value)
          ? selectedDiets.remove(value)
          : selectedDiets.add(value);
    } else if (category == 'eatingHabits') {
      selectedEatingHabits.contains(value)
          ? selectedEatingHabits.remove(value)
          : selectedEatingHabits.add(value);
    } else if (category == 'dineInOut') {
      selectedDineInOut.contains(value)
          ? selectedDineInOut.remove(value)
          : selectedDineInOut.add(value);
    }
    notifyListeners();
  }
}
