import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zal/Functions/models.dart';
import 'package:zal/Screens/HomeScreen/home_screen_providers.dart';
import 'package:zal/Screens/SettingsScreen/settings_providers.dart';

class NewNotificationsDataNotifier extends StateNotifier<NotificationData> {
  AutoDisposeStateNotifierProviderRef<NewNotificationsDataNotifier, NotificationData> ref;

  NewNotificationsDataNotifier(this.ref) : super(NotificationData(factorType: NewNotificationFactorType.Higher, secondsThreshold: 10));
  setKey(NewNotificationKey newKey) {
    state = state.copyWith(key: newKey, childKey: null);
  }

  setChildKey(NotificationKeyWithUnit childKey) {
    state = state.copyWith(childKey: childKey);
  }

  setFactorType(NewNotificationFactorType factorType) {
    state = state.copyWith(factorType: factorType);
  }

  setFactorValue(String factorValue) {
    final parsedDouble = double.tryParse(factorValue);
    if (parsedDouble == null) return;
    state = state.copyWith(factorValue: parsedDouble);
  }

  setSecondsThreshold(int secondsThreshold) {
    state = state.copyWith(secondsThreshold: secondsThreshold);
  }

  List<NotificationKeyWithUnit> getChildrenForSelectedKey() {
    final parsedData = ref.read(socketProvider).valueOrNull?.rawData;
    final computerData = ref.read(socketProvider).valueOrNull;
    final isCelcius = ref.read(settingsProvider).valueOrNull?.useCelcius ?? true;
    if (parsedData == null) return [];
    if (state.key == NewNotificationKey.Gpu) {
      final primaryGpu = ref.read(socketProvider.notifier).getPrimaryGpu();
      if (primaryGpu == null) return [];
      List<NotificationKeyWithUnit> notificationKeys = [];
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'temperature', unit: isCelcius ? 'C' : 'F'));

      notificationKeys.add(NotificationKeyWithUnit(keyName: 'corePercentage', unit: '%'));
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'fanSpeedPercentage', unit: "%"));
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'power', unit: 'W'));
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'coreSpeed', unit: 'MHz'));
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'memorySpeed', unit: 'MHz'));
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'voltage', unit: 'V'));

      return notificationKeys;
    } else if (state.key == NewNotificationKey.Cpu) {
      List<NotificationKeyWithUnit> notificationKeys = [];
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'temperature', unit: isCelcius ? 'C' : 'F'));
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'load', unit: '%'));
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'power', unit: 'W'));

      return notificationKeys;
    } else if (state.key == NewNotificationKey.Ram) {
      List<NotificationKeyWithUnit> notificationKeys = [];
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'memoryUsedPercentage', unit: '%'));
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'memoryUsed', unit: 'GB'));
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'memoryAvailable', unit: 'GB'));

      return notificationKeys;
    } else if (state.key == NewNotificationKey.Network) {
      List<NotificationKeyWithUnit> notificationKeys = [];
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'totalUpload', unit: 'GB'));
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'totalDownload', unit: 'GB'));
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'downloadSpeed', unit: 'MB/s'));
      notificationKeys.add(NotificationKeyWithUnit(keyName: 'uploadSpeed', unit: 'MB/s'));

      return notificationKeys;
    } else if (state.key == NewNotificationKey.Storage) {
      List<NotificationKeyWithUnit> notificationKeys = [];
      for (final Storage storage in computerData?.storages ?? []) {
        notificationKeys.add(NotificationKeyWithUnit(
            keyName: "${storage.diskNumber}", displayName: "(${storage.getDisplayName()}) temperature", unit: isCelcius ? 'C' : 'F'));
      }

      return notificationKeys;
    }
    return [];
  }
}

final newNotificationDataProvider = StateNotifierProvider.autoDispose<NewNotificationsDataNotifier, NotificationData>((ref) {
  return NewNotificationsDataNotifier(ref);
});

class NotificationsNotifier extends AsyncNotifier<List<NotificationData>> {
  NotificationsNotifier();

  @override
  Future<List<NotificationData>> build() async {
    final data = ref.watch(_notificationsDataProvider).valueOrNull;
    if (data == null) return [];

    List<NotificationData> notifications = [];
    for (final rawNotification in data.data) {
      notifications.add(NotificationData.fromJson(rawNotification));
    }
    return notifications;
  }
}

final notificationsProvider = AsyncNotifierProvider<NotificationsNotifier, List<NotificationData>>(() {
  return NotificationsNotifier();
});

///this provider only updates if the data type is [StreamDataType.Notifications]
final _notificationsDataProvider = FutureProvider<StreamData>((ref) {
  final sub = ref.listen(computerSocketStreamProvider, (prev, cur) {
    if (cur.value?.type == StreamDataType.Notifications) {
      ref.state = cur;
    } else {}
  });
  ref.onDispose(() => sub.close());
  return ref.future;
});