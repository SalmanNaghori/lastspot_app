import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/services/installation_id_service.dart';
import 'package:lastspot_app/features/auth/data/datasources/device_remote_datasource.dart';

class FakeInstallationIdService extends Fake implements InstallationIdService {
  final String id;
  FakeInstallationIdService([this.id = 'test-installation-uuid-999']);

  @override
  Future<String> getId() async => id;
}

class FakeSupabaseClientForDevice extends Fake implements SupabaseClient {
  String? lastRpcFn;
  Map<String, dynamic>? lastRpcParams;
  String? lastFromTable;
  Map<dynamic, dynamic>? lastUpdateMap;
  Map<String, dynamic>? lastMatchMap;

  @override
  PostgrestFilterBuilder<T> rpc<T>(
    String fn, {
    Map<String, dynamic>? params,
    dynamic get,
  }) {
    lastRpcFn = fn;
    lastRpcParams = params;
    return FakePostgrestFilterBuilder<T>(null as T);
  }

  @override
  SupabaseQueryBuilder from(String table) {
    lastFromTable = table;
    return FakeSupabaseQueryBuilder(this);
  }
}

class FakeSupabaseQueryBuilder extends Fake implements SupabaseQueryBuilder {
  final FakeSupabaseClientForDevice client;
  FakeSupabaseQueryBuilder(this.client);

  @override
  PostgrestFilterBuilder update(Map values, {dynamic defaultToNull}) {
    client.lastUpdateMap = values;
    return FakePostgrestFilterBuilder<dynamic>(
      null,
      onMatch: (map) {
        client.lastMatchMap = map;
      },
    );
  }
}

class FakePostgrestFilterBuilder<T> extends Fake
    implements PostgrestFilterBuilder<T> {
  final T _value;
  final void Function(Map<String, dynamic>)? onMatch;

  FakePostgrestFilterBuilder(this._value, {this.onMatch});

  @override
  PostgrestFilterBuilder<T> match(Map<String, dynamic> expectedValues) {
    onMatch?.call(expectedValues);
    return this;
  }

  @override
  Future<U> then<U>(
    FutureOr<U> Function(T value) onValue, {
    Function? onError,
  }) async {
    return onValue(_value);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SupabaseDeviceDataSourceImpl', () {
    late FakeSupabaseClientForDevice fakeClient;
    late FakeInstallationIdService fakeInstallationService;
    late SupabaseDeviceDataSourceImpl dataSource;

    setUp(() {
      PackageInfo.setMockInitialValues(
        appName: 'LastSpot',
        packageName: 'com.lastspot.app',
        version: '1.0.0',
        buildNumber: '42',
        buildSignature: '',
      );

      fakeClient = FakeSupabaseClientForDevice();
      fakeInstallationService = FakeInstallationIdService('install-id-xyz');
      dataSource = SupabaseDeviceDataSourceImpl(
        client: fakeClient,
        installationIdService: fakeInstallationService,
      );
    });

    test(
      'registerDevice calls register_my_device RPC with null FCM token when FCM is unavailable',
      () async {
        await dataSource.registerDevice('user-123');

        expect(fakeClient.lastRpcFn, equals('register_my_device'));
        expect(fakeClient.lastRpcParams, isNotNull);
        expect(
          fakeClient.lastRpcParams!['p_device_identifier'],
          equals('install-id-xyz'),
        );
        expect(fakeClient.lastRpcParams!['p_fcm_token'], isNull);
        expect(fakeClient.lastRpcParams!['p_app_version'], equals('1.0.0'));
        expect(fakeClient.lastRpcParams!['p_build_number'], equals(42));
      },
    );

    test(
      'updateFcmToken uses installationId for device_identifier matching',
      () async {
        await dataSource.updateFcmToken('user-123', 'fcm-token-abc');

        expect(fakeClient.lastFromTable, equals('user_devices'));
        expect(fakeClient.lastUpdateMap, isNotNull);
        expect(fakeClient.lastUpdateMap!['fcm_token'], equals('fcm-token-abc'));
        expect(fakeClient.lastMatchMap, isNotNull);
        expect(fakeClient.lastMatchMap!['user_id'], equals('user-123'));
        expect(
          fakeClient.lastMatchMap!['device_identifier'],
          equals('install-id-xyz'),
        );
      },
    );

    test(
      'unregisterDevice calls unregister_my_device with installationId',
      () async {
        await dataSource.unregisterDevice('user-123');

        expect(fakeClient.lastRpcFn, equals('unregister_my_device'));
        expect(
          fakeClient.lastRpcParams!['p_device_identifier'],
          equals('install-id-xyz'),
        );
      },
    );
  });
}
