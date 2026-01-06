part of 'review_cubit.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {
  const ReviewInitial();
}

class ReviewLoading extends ReviewState {
  const ReviewLoading();
}

class ReviewSubmitting extends ReviewState {
  const ReviewSubmitting();
}

class ReviewSubmitSuccess extends ReviewState {
  const ReviewSubmitSuccess();
}

class ReviewSubmitError extends ReviewState {
  final String errorMessage;

  const ReviewSubmitError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class ReviewScamWarningRequired extends ReviewState {
  const ReviewScamWarningRequired();
}

class ReviewRiskAnalysisDetected extends ReviewState {
  final RiskAnalysisReport riskReport;

  const ReviewRiskAnalysisDetected(this.riskReport);

  @override
  List<Object?> get props => [riskReport];
}
