import 'dart:ffi';

class FeedbackModel {
  String feedback = "";
  bool selected = false;

  String get getFeedback {
    return feedback;
  }
  bool get getSelected {
    return selected;
  }

  set setFeedback(String feedback) {
    this.feedback = feedback;
  }
  set setSelected(bool selected) {
    this.selected = selected;
  }
}
