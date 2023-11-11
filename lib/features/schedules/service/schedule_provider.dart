import 'package:flutter/foundation.dart';
import 'package:trash_track_mobile/features/user/models/user.dart';

class ScheduleProvider with ChangeNotifier {
  int _selectedPickupStatusIndex = 0;
  int get selectedPickupStatusIndex => _selectedPickupStatusIndex;

  int _selectedVehicleId = 0;
  int get selectedVehicleId => _selectedVehicleId;

  List<UserEntity> _selectedUsers = [];
  List<UserEntity> get selectedUsers => _selectedUsers;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void setPickupStatusIndex(int newValue) {
    _selectedPickupStatusIndex = newValue;
    notifyListeners();
  }

  void setVehicleId(int newValue) {
    _selectedVehicleId = newValue;
    notifyListeners();
  }

  void setUsers(List<UserEntity> newUsers) {
    _selectedUsers = newUsers;
    notifyListeners();
  }

  void setDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }
}
