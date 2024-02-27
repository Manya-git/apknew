import 'package:ride_mobile/app/models/config_response.dart';

import '../../models/user_model.dart';

class CurrentUser {
  CurrentUser._internal();

  static final CurrentUser _singleton = CurrentUser._internal();

  factory CurrentUser() => _singleton;
  UserModel currentUser = UserModel();
  ConfigResponse configResponse = ConfigResponse();
  // RewardResponse rewardPointsResponse = RewardResponse();
}
