import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beanza/app/controllers/table_session_controller.dart';
import 'package:beanza/app/routes/app_pages.dart';
import 'package:beanza/app/routes/app_routes.dart';
import 'package:beanza/core/widgets/buttons/primary_button.dart';
import 'package:beanza/features/table_session/presentation/controllers/join_approval_preview_controller.dart';
import 'package:beanza/features/table_session/presentation/models/join_request_preview_status.dart';
import 'package:beanza/features/table_session/presentation/models/preview_join_request.dart';
import 'package:beanza/features/table_session/presentation/models/table_occupancy_state.dart';
import 'package:beanza/features/table_session/presentation/pages/name_entry_page.dart';
import 'package:beanza/features/table_session/presentation/pages/table_overview_page.dart';
import 'package:beanza/features/table_session/presentation/pages/waiting_approval_page.dart';
import 'package:beanza/features/table_session/presentation/widgets/join_approval_bottom_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Table Join Approval Prototype Widget Tests (12 Scenarios)', () {
    late JoinApprovalPreviewController controller;
    late TableSessionController tableSessionController;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      Get.reset();
      Get.testMode = true;
      tableSessionController = Get.put(TableSessionController());
      controller = Get.put(JoinApprovalPreviewController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('1. Checking state displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.NAME_ENTRY,
          getPages: AppPages.routes,
        ),
      );
      await tester.pump();

      controller.isCheckingTable.value = true;
      await tester.pump();

      expect(find.textContaining('Checking Table 12…'), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('2. Continue is disabled while checking',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.NAME_ENTRY,
          getPages: AppPages.routes,
        ),
      );
      await tester.pump();

      controller.isCheckingTable.value = true;
      await tester.pump();

      final continueBtnFinder =
          find.byKey(const Key('join_table_continue_button'));
      expect(continueBtnFinder, findsOneWidget);

      final button = tester.widget<PrimaryButton>(continueBtnFinder);
      expect(button.isEnabled, isFalse);
    });

    testWidgets('3. Empty-table flow opens Table Lobby',
        (WidgetTester tester) async {
      controller.setNoActiveMembers();
      controller.setForcedDebugOccupancy(TableOccupancyState.empty);

      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.NAME_ENTRY,
          getPages: AppPages.routes,
        ),
      );
      await tester.pump();

      final nameField = find.byType(TextFormField);
      await tester.enterText(nameField, 'Youssef');
      await tester.pump();

      final joinButton = find.byKey(const Key('join_table_continue_button'));
      await tester.tap(joinButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(Get.currentRoute, Routes.TABLE_OVERVIEW);
      expect(find.byType(TableOverviewPage), findsOneWidget);
      expect(tableSessionController.hasActiveSession, isTrue);
    });

    testWidgets('4. Occupied-table flow opens Waiting for Approval',
        (WidgetTester tester) async {
      controller.restoreDefaultMembers();

      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.NAME_ENTRY,
          getPages: AppPages.routes,
        ),
      );
      await tester.pump();

      final nameField = find.byType(TextFormField);
      await tester.enterText(nameField, 'Youssef');
      await tester.pump();

      final joinButton = find.byKey(const Key('join_table_continue_button'));
      await tester.tap(joinButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(Get.currentRoute, Routes.WAITING_APPROVAL);
      expect(find.byType(WaitingApprovalPage), findsOneWidget);
    });

    testWidgets('5. Requester has no Approve or Reject button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: WaitingApprovalPage(
            initialTableNumber: '12',
            initialRequesterName: 'Youssef',
            initialStatus: JoinRequestPreviewStatus.pending,
          ),
        ),
      );
      await tester.pump();

      expect(
          find.byKey(const Key('approve_join_request_button')), findsNothing);
      expect(find.byKey(const Key('reject_join_request_button')), findsNothing);
      expect(find.text('Approve / موافقة'), findsNothing);
      expect(find.text('Reject / رفض'), findsNothing);
    });

    testWidgets('6. Existing member sees Approve and Reject',
        (WidgetTester tester) async {
      const request = PreviewJoinRequest(
        id: 'req_101',
        requesterId: 'member_youssef',
        requesterName: 'Youssef',
        tableSessionId: 'table_12',
        status: JoinRequestPreviewStatus.pending,
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                key: const Key('open_sheet_btn'),
                onPressed: () {
                  JoinApprovalBottomSheet.show(
                    context: ctx,
                    request: request,
                    actingMember: JoinApprovalPreviewController.memberAhmed,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('open_sheet_btn')));
      await tester.pumpAndSettle();

      expect(
          find.byKey(const Key('approve_join_request_button')), findsOneWidget);
      expect(
          find.byKey(const Key('reject_join_request_button')), findsOneWidget);
    });

    testWidgets('7. Approval opens Table Lobby once',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.WAITING_APPROVAL,
          getPages: [
            GetPage(
              name: Routes.WAITING_APPROVAL,
              page: () => const WaitingApprovalPage(
                initialTableNumber: '12',
                initialRequesterName: 'Youssef',
                initialStatus: JoinRequestPreviewStatus.approved,
              ),
            ),
            GetPage(
              name: Routes.HOME,
              page: () => const Scaffold(body: Text('Table Lobby Home Screen')),
            ),
          ],
        ),
      );
      await tester.pump();

      final enterTableBtn = find.byKey(const Key('enter_table_button'));
      expect(enterTableBtn, findsOneWidget);

      await tester.ensureVisible(enterTableBtn);
      await tester.tap(enterTableBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('Table Lobby Home Screen'), findsOneWidget);
    });

    testWidgets('8. Error state displays Retry', (WidgetTester tester) async {
      controller.setForcedDebugOccupancy(TableOccupancyState.error);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: NameEntryPage(),
        ),
      );
      await tester.pump();

      expect(find.text('Retry Table Check ↻'), findsOneWidget);
      expect(find.textContaining('Check error'), findsOneWidget);
    });

    testWidgets('9. Dark Mode renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const NameEntryPage(),
        ),
      );
      await tester.pump();

      expect(find.byType(NameEntryPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('10. Off-White Light Mode renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.light(),
          home: const NameEntryPage(),
        ),
      );
      await tester.pump();

      expect(find.byType(NameEntryPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('11. Arabic RTL does not overflow',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          locale: Locale('ar'),
          home: NameEntryPage(),
        ),
      );
      await tester.pump();

      expect(find.byType(NameEntryPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('12. English LTR does not overflow across responsive viewports',
        (WidgetTester tester) async {
      final viewports = [
        const Size(320, 600),
        const Size(360, 740),
        const Size(390, 844),
        const Size(412, 915),
      ];

      for (final size in viewports) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          const GetMaterialApp(
            locale: Locale('en'),
            home: NameEntryPage(),
          ),
        );
        await tester.pump();

        expect(find.byType(NameEntryPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      }

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
