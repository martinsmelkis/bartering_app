import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// State for the profile panel
class ProfilePanelState {
  final bool isOpen;
  final String? userId;
  final String? userName;
  final List<ParsedAttributeData>? interests;
  final List<ParsedAttributeData>? offerings;

  const ProfilePanelState({
    this.isOpen = false,
    this.userId,
    this.userName,
    this.interests,
    this.offerings,
  });

  ProfilePanelState copyWith({
    bool? isOpen,
    String? userId,
    String? userName,
    List<ParsedAttributeData>? interests,
    List<ParsedAttributeData>? offerings,
  }) {
    return ProfilePanelState(
      isOpen: isOpen ?? this.isOpen,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      interests: interests ?? this.interests,
      offerings: offerings ?? this.offerings,
    );
  }
}

/// Cubit to manage profile panel state globally
class ProfilePanelCubit extends Cubit<ProfilePanelState> {
  ProfilePanelCubit() : super(const ProfilePanelState());

  /// Open profile panel
  void openProfile({
    required String userId,
    required String userName,
    List<ParsedAttributeData>? interests,
    List<ParsedAttributeData>? offerings,
  }) {
    emit(ProfilePanelState(
      isOpen: true,
      userId: userId,
      userName: userName,
      interests: interests,
      offerings: offerings,
    ));
  }

  /// Close the profile panel
  void closeProfile() {
    emit(const ProfilePanelState(isOpen: false));
  }
}
