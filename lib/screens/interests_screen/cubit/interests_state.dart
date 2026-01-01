part of 'interests_cubit.dart';

enum InterestsStatus { initial, loading, success, error }

class InterestsState extends Equatable {
  final List<ParsedAttributeData> allInterests;
  final List<ParsedAttributeData> selectedInterests;
  final List<String> customKeywords;
  final InterestsStatus status;
  final String? errorMessage;
  List<ParsedAttributeData>? offersKeyList;

  InterestsState({
    required this.allInterests,
    required this.selectedInterests,
    this.customKeywords = const [],
    this.status = InterestsStatus.initial,
    this.errorMessage,
    this.offersKeyList,
  });

  factory InterestsState.initial() {
    // Default interests list - can be loaded from repository asynchronously later
    final userRepository = getIt<UserRepository>();
    // In a real app, this list would likely come from the backend
    return InterestsState(
      allInterests: userRepository.userInterests?.isNotEmpty == true ?
        userRepository.userInterests! : [],
      selectedInterests: [],
      customKeywords: [],
    );
  }

  InterestsState copyWith({
    List<ParsedAttributeData>? allInterests,
    List<ParsedAttributeData>? selectedInterests,
    List<String>? customKeywords,
    InterestsStatus? status,
    String? errorMessage,
    List<ParsedAttributeData>? offersKeyList
  }) {
    return InterestsState(
      allInterests: allInterests ?? this.allInterests,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      customKeywords: customKeywords ?? this.customKeywords,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      offersKeyList: offersKeyList ?? this.offersKeyList
    );
  }

  @override
  List<Object?> get props => [allInterests, selectedInterests, customKeywords, status, errorMessage,
    offersKeyList];
}
