part of 'onboarding_cubit.dart';

enum OnboardingStatus { initial, inProgress, submitting, success, error }

class OnboardingQuestion {
  final int id;
  final String text;
  double? answer; // null: unanswered, -1.0: left, 1.0: right, 0.0: neutral

  OnboardingQuestion({
    required this.id,
    required this.text,
    this.answer,
  });

  OnboardingQuestion copyWith({double? answer}) {
    return OnboardingQuestion(
      id: id,
      text: text,
      answer: answer ?? this.answer,
    );
  }
}

class OnboardingState extends Equatable {
  List<OnboardingQuestion> questions;
  final bool isCompleted;
  final OnboardingStatus status;
  final String? errorMessage;
  List<ParsedAttributeData>? interestsKeyList;

  OnboardingState({
    required this.questions,
    this.isCompleted = true,
    this.status = OnboardingStatus.initial,
    this.errorMessage,
    this.interestsKeyList,
  });

  factory OnboardingState.initial() {
    return OnboardingState(
      questions: _initialQuestions,
      isCompleted: true,
      status: OnboardingStatus.initial,
    );
  }

  OnboardingState copyWith({
    List<OnboardingQuestion>? questions,
    bool? isCompleted,
    OnboardingStatus? status,
    String? errorMessage,
    List<ParsedAttributeData>? interestsKeyList
  }) {
    return OnboardingState(
      questions: questions ?? this.questions,
      isCompleted: isCompleted ?? this.isCompleted,
      status: status ?? this.status,
      errorMessage: errorMessage,
      interestsKeyList: interestsKeyList
    );
  }

  @override
  List<Object?> get props => [questions, isCompleted, status, errorMessage,
    interestsKeyList];
}

// 1. Initial Questions ---

// ####### Add individual weights to the yes/no questions. e.g. Job is more important than Zodiac sign

// 2. AI parses all that and generates Keyword bubbles
// Bubble view with specific passions that you are REALLY into - new screen after basic Onboarding questions
// Provide some defaults and get the rest with AI Prompt

// 3. From interests AI can generate what that person can provide, e.g. Gardening - Fruits/vegetables
final List<OnboardingQuestion> _initialQuestions = [

];