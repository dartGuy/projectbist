import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';

final switchUserProvider =
    StateNotifierProvider<SwitchUser, UserTypes>((ref) => SwitchUser());

class SwitchUser extends StateNotifier<UserTypes> {
  SwitchUser() : super(UserTypes.researcher);

  void switchUser(UserTypes newUser) {
    state = newUser;
  }
}
