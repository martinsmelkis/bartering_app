part of 'offers_cubit.dart';

enum OffersStatus { initial, loading, success, error }

class OffersState extends Equatable {
  final List<ParsedAttributeData> allOffers;
  final List<ParsedAttributeData> selectedOffers;
  final List<String> customKeywords;
  final OffersStatus status;
  final String? errorMessage;

  const OffersState({
    required this.allOffers,
    required this.selectedOffers,
    this.customKeywords = const [],
    this.status = OffersStatus.initial,
    this.errorMessage,
  });

  factory OffersState.initial() {
    final userRepository = getIt<UserRepository>();
    // Default offers list - can be loaded from repository asynchronously later
    return OffersState(
      allOffers: userRepository.userOfferings?.isNotEmpty == true ?
      userRepository.userOfferings! : [],
      selectedOffers: [],
      customKeywords: [],
    );
  }

  OffersState copyWith({
    List<ParsedAttributeData>? allOffers,
    List<ParsedAttributeData>? selectedOffers,
    List<String>? customKeywords,
    OffersStatus? status,
    String? errorMessage,
  }) {
    return OffersState(
      allOffers: allOffers ?? this.allOffers,
      selectedOffers: selectedOffers ?? this.selectedOffers,
      customKeywords: customKeywords ?? this.customKeywords,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [allOffers, selectedOffers, customKeywords, status, errorMessage];
}
