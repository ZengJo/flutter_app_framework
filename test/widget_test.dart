import 'package:flutter/material.dart';
import 'package:flutter_app_framework/core/globalization/bootstrap/globalization_bootstrap_data.dart';
import 'package:flutter_app_framework/core/globalization/model/globalization_preferences.dart';
import 'package:flutter_app_framework/core/globalization/providers/globalization_bootstrap_provider.dart';
import 'package:flutter_app_framework/core/network/connectivity/network_state.dart';
import 'package:flutter_app_framework/core/network/offline_queue/offline_queue_state.dart';
import 'package:flutter_app_framework/core/network/providers/network_providers.dart';
import 'package:flutter_app_framework/core/network/providers/offline_queue_state_provider.dart';
import 'package:flutter_app_framework/features/example/presentation/pages/example_page.dart';
import 'package:flutter_app_framework/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Application smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          globalizationBootstrapProvider.overrideWithValue(
            const GlobalizationBootstrapData(
              preferences: GlobalizationPreferences(),
              systemLocales: [Locale('en')],
              systemTimeZoneId: 'Etc/UTC',
              systemUses24HourFormat: true,
            ),
          ),
          networkStateProvider.overrideWith(
            (ref) => Stream<NetworkState>.value(
              const NetworkState(Reachability.online),
            ),
          ),
          offlineQueueStateProvider.overrideWith(
            (ref) => Stream<OfflineQueueState>.value(OfflineQueueState.empty),
          ),
        ],
        child: const Application(startPage: ExamplePage()),
      ),
    );

    await tester.pump();

    expect(find.text('ExamplePage'), findsOneWidget);
  });
}
