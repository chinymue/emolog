import 'package:flutter/material.dart';
import '../../isar/isar_service.dart';
import '../../isar/model/relax.dart';
import 'package:uuid/uuid.dart';

class RelaxProvider extends ChangeNotifier
    with ServiceAccess, RelaxStateMixin, RelaxCRUDMixin {
  RelaxProvider(IsarService service) {
    isarService = service;
  }
}

mixin ServiceAccess on ChangeNotifier {
  late final IsarService isarService;
}

mixin RelaxStateMixin on ChangeNotifier {
  List<Relax> relaxs = [];
  bool isFetchedRelaxs = false;

  void reset() {
    relaxs = [];
    isFetchedRelaxs = false;
    notifyListeners();
  }

  // Relax newSession = Relax();

  // late Relax editSession;
  // bool hasEditSession = false;

  // void updateRelaxField(
  //   Relax target,
  //   void Function(Relax) updater, {
  //   bool notify = false,
  // }) {
  //   updater(target);
  //   if (notify) notifyListeners();
  // }

  void updateSessionInList(
    int id,
    Relax Function(Relax) transform, {
    bool notify = true,
  }) {
    if (!isFetchedRelaxs) return;

    final index = relaxs.indexWhere((l) => l.id == id);
    if (index == -1) return;

    relaxs[index] = transform(relaxs[index]);
    if (notify) notifyListeners();
  }
}

mixin RelaxCRUDMixin on ServiceAccess, RelaxStateMixin {
  Future<Relax> saveRelax(String userUID, DateTime start, DateTime end) async {
    final relax = Relax(
      relaxId: const Uuid().v4(),
      userUid: userUID,
      startTime: start,
      endTime: end,
      durationMiliseconds: end.difference(start).inMilliseconds,
    );
    final savedRelax = await isarService.saveRelax(relax);

    if (isFetchedRelaxs) {
      relaxs.add(savedRelax);
      notifyListeners();
    }

    return savedRelax;
  }

  Future<void> updateRelax(
    int id, {
    DateTime? start,
    DateTime? end,
    int? durationSeconds,
  }) async {
    final existedRelax = await isarService.getById<Relax>(id);
    if (existedRelax.id != id) return;
    DateTime? newStart = start;
    DateTime? newEnd = end;

    if (durationSeconds != null) {
      if (newStart != null) {
        newEnd = newStart.add(Duration(seconds: durationSeconds));
      } else if (newEnd != null) {
        newStart = newEnd.subtract(Duration(seconds: durationSeconds));
      } else {
        return;
      }
    } else {
      newStart ??= existedRelax.startTime;
      newEnd ??= existedRelax.endTime;
    }

    final updatedRelax = existedRelax.copyWith(
      startTime: newStart,
      endTime: newEnd,
      durationMiliseconds: newEnd.difference(newStart).inMilliseconds,
    );

    await isarService.updateRelax(updatedRelax);
    updateSessionInList(id, (_) => updatedRelax);
  }

  Future<void> fetchRelaxs(String? userUid) async {
    if (!isFetchedRelaxs) {
      relaxs = userUid == null
          ? await isarService.getAll<Relax>()
          : await isarService.getAllRelaxs(userUid);
      isFetchedRelaxs = true;
      notifyListeners();
    }
  }

  Future<void> deleteRelax({required id}) async {
    await isarService.deleteById<Relax>(id);
    if (isFetchedRelaxs) {
      relaxs.removeWhere((relax) => relax.id == id);
      notifyListeners();
    }
  }

  Future<void> deleteAllRelax(String? userUid) async {
    if (userUid == null) return;
    await isarService.deleteRelaxOfUser(userUid);
    if (isFetchedRelaxs) {
      relaxs = [];
      notifyListeners();
    }
  }

  Future<void> deleteAllRelaxs() async {
    await isarService.clearCollection<Relax>();
    if (isFetchedRelaxs) {
      relaxs = [];
      notifyListeners();
    }
  }
}
