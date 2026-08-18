import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../catalog.dart';
import '../models.dart';

class AppState extends ChangeNotifier {
  AppState({
    String? initialConcern,
    SkinProfile? initialSkinProfile,
    Set<int>? initialSavedIds,
    List<int>? initialRecentIds,
  })  : _skinProfile = initialSkinProfile ?? const SkinProfile.empty(),
        _profileConcern = initialSkinProfile?.isComplete == true
            ? initialSkinProfile!.primaryConcern
            : initialConcern ?? concerns.first,
        _savedIds = Set<int>.of(initialSavedIds ?? {1, 3}),
        _recentIds = List<int>.of(initialRecentIds ?? [2]);

  SkinProfile _skinProfile;
  String _profileConcern;
  final Set<int> _compareIds = {};
  final Set<int> _savedIds;
  final List<int> _recentIds;

  SkinProfile get skinProfile => _skinProfile;
  String get profileConcern => _profileConcern;
  UnmodifiableSetView<int> get compareIds => UnmodifiableSetView(_compareIds);
  UnmodifiableSetView<int> get savedIds => UnmodifiableSetView(_savedIds);
  UnmodifiableListView<int> get recentIds => UnmodifiableListView(_recentIds);

  List<BeautyProduct> get comparedProducts => products
      .where((product) => _compareIds.contains(product.id))
      .toList(growable: false);

  bool toggleCompare(BeautyProduct product) {
    if (_compareIds.remove(product.id)) {
      notifyListeners();
      return true;
    }
    if (_compareIds.length >= 3) return false;
    _compareIds.add(product.id);
    notifyListeners();
    return true;
  }

  void toggleSaved(BeautyProduct product) {
    if (!_savedIds.add(product.id)) _savedIds.remove(product.id);
    notifyListeners();
  }

  void updateProfileConcern(String concern) {
    if (_profileConcern == concern) return;
    _profileConcern = concern;
    notifyListeners();
  }

  void updateSkinProfile(SkinProfile profile) {
    _skinProfile = profile;
    _profileConcern = profile.primaryConcern;
    notifyListeners();
  }

  void recordViewed(BeautyProduct product) {
    _recentIds.remove(product.id);
    _recentIds.insert(0, product.id);
    if (_recentIds.length > 5) _recentIds.removeLast();
    notifyListeners();
  }
}
