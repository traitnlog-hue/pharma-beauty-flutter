import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../catalog.dart';
import '../features/purchase_trends/purchase_trend_service.dart';
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
  final Set<int> _cartIds = {};
  final List<PurchaseOrder> _orders = [];
  final PurchaseTrendService _purchaseTrendService =
      const PurchaseTrendService();
  String? _userEmail;
  String? _userName;

  SkinProfile get skinProfile => _skinProfile;
  String get profileConcern => _profileConcern;
  UnmodifiableSetView<int> get compareIds => UnmodifiableSetView(_compareIds);
  UnmodifiableSetView<int> get savedIds => UnmodifiableSetView(_savedIds);
  UnmodifiableListView<int> get recentIds => UnmodifiableListView(_recentIds);
  UnmodifiableSetView<int> get cartIds => UnmodifiableSetView(_cartIds);
  UnmodifiableListView<PurchaseOrder> get orders =>
      UnmodifiableListView(_orders);
  bool get isSignedIn => _userEmail != null;
  String get userName => _userName ?? '회원';
  String? get userEmail => _userEmail;

  List<BeautyProduct> get comparedProducts => products
      .where((product) => _compareIds.contains(product.id))
      .toList(growable: false);

  List<BeautyProduct> get cartProducts => products
      .where((product) => _cartIds.contains(product.id))
      .toList(growable: false);

  void addToCart(BeautyProduct product) {
    _cartIds.add(product.id);
    notifyListeners();
  }

  void removeFromCart(BeautyProduct product) {
    _cartIds.remove(product.id);
    notifyListeners();
  }

  PurchaseOrder checkout(Iterable<BeautyProduct> selected) {
    final purchasedProducts = selected.toList(growable: false);
    final selectedIds = purchasedProducts.map((product) => product.id).toList();
    final order = PurchaseOrder(
      id: 'LX${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      productIds: selectedIds,
      createdAt: DateTime.now(),
      status: DeliveryStatus.preparing,
    );
    _cartIds.removeAll(selectedIds);
    _orders.insert(0, order);
    unawaited(_purchaseTrendService.recordCompletedPurchase(purchasedProducts));
    notifyListeners();
    return order;
  }

  void advanceDelivery(String orderId) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index < 0) return;
    final next = switch (_orders[index].status) {
      DeliveryStatus.paid => DeliveryStatus.preparing,
      DeliveryStatus.preparing => DeliveryStatus.shipping,
      DeliveryStatus.shipping => DeliveryStatus.delivered,
      DeliveryStatus.delivered => DeliveryStatus.delivered,
    };
    _orders[index] = _orders[index].copyWith(status: next);
    notifyListeners();
  }

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

  void signIn({required String email, required String name}) {
    _userEmail = email;
    _userName = name.trim().isEmpty ? email.split('@').first : name.trim();
    notifyListeners();
  }

  void signOut() {
    _userEmail = null;
    _userName = null;
    notifyListeners();
  }
}
