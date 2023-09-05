import 'package:flutter/material.dart';

class RatingProviderAll with ChangeNotifier {
  List<String> _feedbackTrainerList = [];
  List<String> _feedbackClassroomList = [];
  List<String> _feedbackCourseMaterialList = [];

  String _optionalTrainerFeedback = '';
  String _optionalClassroomFeedback = '';
  String _optionalCourseMaterialFeedback = '';

  int _ratingOverallCount = 0;
  int _ratingClassroomCount = 0;
  int _ratingTrainerCount = 0;
  int _ratingCourseMaterialCount = 0;

  List<int> selectedTrainerFeedback = [];
  List<int> selectedClassroomFeedback = [];
  List<int> selectedCourseMaterialFeedback = [];

  bool isSubmitted = false;
  String _classroomStringFeedback = "";
  String _trainerStringFeedback = "";
  String _courseMaterialStringFeedback = "";



  deselectFeedback() {
    _feedbackTrainerList = [];
    _feedbackClassroomList = [];
    _feedbackCourseMaterialList = [];
  }


  changeFeedbackByType(String type, String feedback) {
    switch(type) {
      case "classroom":
        if (_feedbackClassroomList.contains(feedback)){
          _feedbackClassroomList.remove(feedback);
        } else {
          _feedbackClassroomList.add(feedback);
        }
        break;
      case "trainer":
        if (_feedbackTrainerList.contains(feedback)){
          _feedbackTrainerList.remove(feedback);
        } else {
          _feedbackTrainerList.add(feedback);
        }
        break;
      case "courseMaterial":
        if (_feedbackCourseMaterialList.contains(feedback)){
          _feedbackCourseMaterialList.remove(feedback);
        } else {
          _feedbackCourseMaterialList.add(feedback);
        }
        break;
      default:
        break;
    }

    notifyListeners();
  }

  set submit(bool value){
    isSubmitted = value;
    notifyListeners();
  }
  submitted(){
    isSubmitted = false;
  }

  bool get submitClicked {
    return isSubmitted;
  }

  String get getConcatenatedTrainerFeedback {
    return _trainerStringFeedback;
  }

  String get getConcatenatedClassroomFeedback {
    return _classroomStringFeedback;
  }

  String get getConcatenatedCourseMaterialFeedback {
    return _courseMaterialStringFeedback;
  }


  changeRatingByType(String type, int ratingCount) {
    print(type);
    print(ratingCount);
    switch(type) {
      case "overall":
        setOverallRating(ratingCount);
        break;
      case "classroom":
        setClassroomRating(ratingCount);
        break;
      case "trainer":
        setTrainerRating(ratingCount);
        break;
      case "courseMaterial":
        setCourseMaterialRating(ratingCount);
        break;
      default:
        break;
    }

  }

  changeOptionalFeedbackByType(String type, String feedback) {
    switch(type) {
      case "classroom":
        setOptionalClassroomFeedback(feedback);
        break;
      case "trainer":
        setOptionalTrainerFeedback(feedback);
        break;
      case "courseMaterial":
        setOptionalCourseMaterialFeedback(feedback);
        break;
      default:
        break;
    }
  }

  void setOptionalTrainerFeedback(String optionalFeedback){
    _optionalTrainerFeedback = optionalFeedback;
    notifyListeners();
  }

  void setOptionalClassroomFeedback(String optionalFeedback){
    _optionalClassroomFeedback = optionalFeedback;
    notifyListeners();
  }

  void setOptionalCourseMaterialFeedback(String optionalFeedback){
    _optionalCourseMaterialFeedback = optionalFeedback;
    notifyListeners();
  }

  void setOverallRating(int ratingCount) {
    _ratingOverallCount = ratingCount;
    if (ratingCount ==5) {
      _ratingTrainerCount = ratingCount;
      _ratingClassroomCount = ratingCount;
      _ratingCourseMaterialCount = ratingCount;
    }
    notifyListeners();
  }

  void setTrainerRating(int ratingCount) {
    _ratingTrainerCount = ratingCount;
    notifyListeners();
  }

  void setClassroomRating(int ratingCount) {
    _ratingClassroomCount = ratingCount;
    notifyListeners();
  }

  void setCourseMaterialRating(int ratingCount) {
    _ratingCourseMaterialCount = ratingCount;
    notifyListeners();
  }

  void changeSelectedTrainerFeedback(int index) {
    if (selectedTrainerFeedback.contains(index)) {
      selectedTrainerFeedback.remove(index);
    } else {
      selectedTrainerFeedback.add(index);
    }
    notifyListeners();
  }

  void changeSelectedClassroomFeedback(int index) {
    if (selectedClassroomFeedback.contains(index)) {
      selectedClassroomFeedback.remove(index);
    } else {
      selectedClassroomFeedback.add(index);
    }
    notifyListeners();
  }

  void changeSelectedCourseMaterialFeedback(int index) {
    if (selectedCourseMaterialFeedback.contains(index)) {
      selectedCourseMaterialFeedback.remove(index);
    } else {
      selectedCourseMaterialFeedback.add(index);
    }
    notifyListeners();
  }

  List<String> getFeedbackByType(String type) {
    switch(type) {
      case "trainer":
        return getTrainerFeedback;
      case "classroom":
        return getClassroomFeedback;
      case "courseMaterial":
        return getCourseMaterialFeedback;
      default:
        return [];
    }
  }

  List<String> get getTrainerFeedback => _feedbackTrainerList;
  List<String> get getClassroomFeedback => _feedbackClassroomList;
  List<String> get getCourseMaterialFeedback => _feedbackCourseMaterialList;

  int get getOverallRating => _ratingOverallCount;
  int get getTrainerRating => _ratingTrainerCount;
  int get getClassroomRating => _ratingClassroomCount;
  int get getCourseMaterialRating => _ratingCourseMaterialCount;

  String get getOptionalTrainerFeedback => _optionalTrainerFeedback;
  String get getOptionalClassroomFeedback => _optionalClassroomFeedback;
  String get getOptionalCourseMaterialFeedback => _optionalCourseMaterialFeedback;
}