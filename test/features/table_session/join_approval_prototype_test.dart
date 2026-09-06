import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beanza/app/controllers/table_session_controller.dart';
import 'package:beanza/app/routes/app_pages.dart';
import 'package:beanza/app/routes/app_routes.dart';
import 'package:beanza/features/table_session/presentation/controllers/join_approval_preview_controller.dart';
import 'package:beanza/features/table_session/presentation/models/join_request_preview_status.dart';
import 'package:beanza/features/table_session/presentation/models/preview_join_request.dart';
import 'package:beanza/features/table_session/presentation/pages/name_entry_page.dart';
import 'package:beanza/features/table_session/presentation/pages/waiting_approval_page.dart';
import 'package:beanza/features/table_session/presentation/widgets/join_approval_bottom_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Table Join Approval Prototype Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      Get.reset();
      Get.testMode = true;
      Get.put(TableSessionController());
      Get.put(JoinApprovalPreviewController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets(
        '1. Name Entry transitions to Waiting for Approval prototype screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.NAME_ENTRY,
          getPages: AppPages.routes,
        ),
      );
      await tester.pump();

      expect(find.byType(NameEntryPage), findsOneWidget);

      final nameField = find.byType(TextFormField);
      expect(nameField, findsOneWidget);
      await tester.enterText(nameField, 'Youssef');
      await tester.pump();

      final joinButton = find.text('Join Table Session ☕');
      await tester.tap(joinButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(Get.currentRoute, Routes.WAITING_APPROVAL);
      expect(find.byType(WaitingApprovalPage), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(WaitingApprovalPage),
          matching: find.text('Youssef'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('2. Requester Waiting screen has no Approve or Reject buttons',
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

      // Ensure requester CANNOT approve or reject their own request
      expect(
          find.byKey(const Key('approve_join_request_button')), findsNothing);
      expect(find.byKey(const Key('reject_join_request_button')), findsNothing);
      expect(find.text('Approve / موافقة'), findsNothing);
      expect(find.text('Reject / رفض'), findsNothing);

      // Only Cancel Request & Scan Another Table are available
      expect(
          find.byKey(const Key('cancel_join_request_button')), findsOneWidget);
      expect(
          find.byKey(const Key('scan_another_table_button')), findsOneWidget);

      // Displays correct waiting explanation & members
      expect(
        find.textContaining('Waiting for someone at the table to approve you'),
        findsWidgets,
      );
      expect(find.text('Ahmed'), findsOneWidget);
      expect(find.text('Sara'), findsOneWidget);
      expect(find.text('Mostafa'), findsOneWidget);
    });

    testWidgets(
        '3. No-member state displays polite warning without auto-approving',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: WaitingApprovalPage(
            initialTableNumber: '12',
            initialRequesterName: 'Youssef',
            initialStatus: JoinRequestPreviewStatus.pending,
            initialMembers: [],
          ),
        ),
      );
      await tester.pump();

      expect(
        find.textContaining(
            'No active member is available to approve this request.'),
        findsWidgets,
      );
      expect(
          find.byKey(const Key('approve_join_request_button')), findsNothing);
      expect(
          find.byKey(const Key('cancel_join_request_button')), findsOneWidget);
    });

    testWidgets(
        '4. Table Lobby member view: Ahmed sees incoming request and can approve',
        (WidgetTester tester) async {
      var approved = false;

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
                    onApprove: () => approved = true,
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

      expect(find.textContaining('Previewing as Ahmed'), findsOneWidget);
      expect(find.text('Is Youssef with you?'), findsOneWidget);
      expect(find.text('هل Youssef موجود معكم على الترابيزة؟'), findsOneWidget);
      expect(
          find.byKey(const Key('approve_join_request_button')), findsOneWidget);
      expect(
          find.byKey(const Key('reject_join_request_button')), findsOneWidget);

      // Tap Approve
      await tester.tap(find.byKey(const Key('approve_join_request_button')));
      await tester.pumpAndSettle();
      expect(approved, isTrue);
    });

    testWidgets(
        '5. Youssef cannot approve Youssef (Self-Approval blocked with warning)',
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
                    actingMember:
                        JoinApprovalPreviewController.requesterAsMember,
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

      // Warning is displayed
      expect(
          find.byKey(const Key('self_approval_warning_card')), findsOneWidget);
      expect(find.text('You cannot approve your own request'), findsOneWidget);
      expect(find.text('لا يمكنك الموافقة على طلبك بنفسك'), findsOneWidget);

      // Approve & Reject buttons are hidden / disabled
      expect(
          find.byKey(const Key('approve_join_request_button')), findsNothing);
      expect(find.byKey(const Key('reject_join_request_button')), findsNothing);
    });

    testWidgets(
        '6. Approved state displays success checkmark and Enter Table button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: WaitingApprovalPage(
            initialTableNumber: '12',
            initialRequesterName: 'Youssef',
            initialStatus: JoinRequestPreviewStatus.approved,
          ),
        ),
      );
      await tester.pump();

      expect(find.text("You’re approved!"), findsOneWidget);
      expect(find.textContaining('Ahmed confirmed that you are at Table 12'),
          findsOneWidget);
      expect(find.byKey(const Key('enter_table_button')), findsOneWidget);
    });

    testWidgets(
        '7. Rejected state displays polite message and Try Again button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: WaitingApprovalPage(
            initialTableNumber: '12',
            initialRequesterName: 'Youssef',
            initialStatus: JoinRequestPreviewStatus.rejected,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Request not approved'), findsOneWidget);
      expect(find.textContaining('A table member could not confirm'),
          findsOneWidget);
      expect(find.byKey(const Key('try_again_button')), findsOneWidget);

      // Tap try again -> resets to pending
      await tester.ensureVisible(find.byKey(const Key('try_again_button')));
      await tester.tap(find.byKey(const Key('try_again_button')));
      await tester.pump();
      expect(
        find.textContaining('Waiting for someone at the table to approve you'),
        findsWidgets,
      );
    });

    testWidgets(
        '8. Expired state displays Request expired and Send Again button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: WaitingApprovalPage(
            initialTableNumber: '12',
            initialRequesterName: 'Youssef',
            initialStatus: JoinRequestPreviewStatus.expired,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Request expired'), findsOneWidget);
      expect(find.byKey(const Key('send_again_button')), findsOneWidget);

      // Tap send again -> restarts countdown to pending
      await tester.ensureVisible(find.byKey(const Key('send_again_button')));
      await tester.tap(find.byKey(const Key('send_again_button')));
      await tester.pump();
      expect(
        find.textContaining('Waiting for someone at the table to approve you'),
        findsWidgets,
      );
    });

    testWidgets(
        '9. Cancel request dialog confirms cancellation and updates state',
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

      final cancelButton = find.byKey(const Key('cancel_join_request_button'));
      await tester.ensureVisible(cancelButton);
      await tester.tap(cancelButton);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('Cancel Request?'), findsOneWidget);
      final confirmButton =
          find.byKey(const Key('confirm_cancel_request_button'));
      await tester.tap(confirmButton);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Request cancelled'), findsOneWidget);
      expect(find.byKey(const Key('request_again_button')), findsOneWidget);
    });

    testWidgets('10. Light Mode and Dark Mode themes render without exceptions',
        (WidgetTester tester) async {
      // Dark Mode
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const WaitingApprovalPage(
            initialTableNumber: '12',
            initialRequesterName: 'Youssef',
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(WaitingApprovalPage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Light Mode
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.light(),
          home: const WaitingApprovalPage(
            initialTableNumber: '12',
            initialRequesterName: 'Youssef',
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(WaitingApprovalPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('11. Arabic RTL layout renders cleanly without overflow',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          locale: Locale('ar'),
          home: WaitingApprovalPage(
            initialTableNumber: '12',
            initialRequesterName: 'يوسف عبد الرحمن',
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(WaitingApprovalPage), findsOneWidget);
      expect(find.text('يوسف عبد الرحمن'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        '12. Responsive viewports at 320, 360, 390, 412px have no RenderFlex overflow',
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
            home: WaitingApprovalPage(
              initialTableNumber: '12',
              initialRequesterName: 'Youssef Alexander',
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(WaitingApprovalPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      }

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
