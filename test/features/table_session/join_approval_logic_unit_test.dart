import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:beanza/app/controllers/table_session_controller.dart';
import 'package:beanza/features/table_session/presentation/controllers/join_approval_preview_controller.dart';
import 'package:beanza/features/table_session/presentation/models/join_request_preview_status.dart';
import 'package:beanza/features/table_session/presentation/models/preview_join_request.dart';
import 'package:beanza/features/table_session/presentation/models/preview_table_member.dart';
import 'package:beanza/features/table_session/presentation/models/table_occupancy_state.dart';

void main() {
  group('Table Join Approval & Occupancy Logic Unit Tests (14 Requirements)',
      () {
    late JoinApprovalPreviewController controller;
    late TableSessionController tableSessionController;

    const requester = PreviewTableMember(
      id: 'member_youssef',
      name: 'Youssef',
      tableSessionId: 'table_12',
      isApproved: false,
      isActive: true,
    );

    const approvedMemberAhmed = PreviewTableMember(
      id: 'member_ahmed',
      name: 'Ahmed',
      tableSessionId: 'table_12',
      isApproved: true,
      isActive: true,
    );

    const pendingRequest = PreviewJoinRequest(
      id: 'req_101',
      requesterId: 'member_youssef',
      requesterName: 'Youssef',
      tableSessionId: 'table_12',
      status: JoinRequestPreviewStatus.pending,
    );

    setUp(() {
      Get.reset();
      tableSessionController = Get.put(TableSessionController());
      controller = Get.put(JoinApprovalPreviewController());
    });

    tearDown(() {
      Get.reset();
    });

    test('0. Default state is completely empty on fresh run', () {
      expect(controller.tableMembers, isEmpty);
      expect(controller.activeApprovedMembers, isEmpty);
      expect(controller.isCurrentTableEmpty, isTrue);
      expect(controller.tableOccupancyState.value, TableOccupancyState.empty);
      expect(controller.status, JoinRequestPreviewStatus.cancelled);
    });

    test('1. Empty table allows direct entry without approval', () async {
      expect(controller.isCurrentTableEmpty, isTrue);

      var directJoined = false;
      var waitingOpened = false;

      final handled = await controller.continueAfterNameEntry(
        name: 'Youssef',
        tableId: '12',
        tableNumber: '12',
        simulationDelay: Duration.zero,
        onDirectJoin: () => directJoined = true,
        onWaitingApproval: () => waitingOpened = true,
      );

      expect(handled, isTrue);
      expect(directJoined, isTrue);
      expect(waitingOpened, isFalse);
    });

    test('2. Empty table adds the user as the first approved member', () async {
      expect(controller.activeApprovedMembers, isEmpty);

      await controller.continueAfterNameEntry(
        name: 'Youssef',
        tableId: '12',
        tableNumber: '12',
        simulationDelay: Duration.zero,
      );

      expect(controller.tableMembers.length, 1);
      final firstMember = controller.tableMembers.first;
      expect(firstMember.name, 'Youssef');
      expect(firstMember.isApproved, isTrue);
      expect(firstMember.isActive, isTrue);
      expect(controller.isCurrentTableEmpty, isFalse);
      expect(tableSessionController.hasActiveSession, isTrue);
    });

    test('3. First member is added only once', () {
      controller.joinAsFirstMember(
        name: 'Youssef',
        tableId: '12',
        tableNumber: '12',
      );
      expect(controller.tableMembers.length, 1);

      // Repeat call
      controller.joinAsFirstMember(
        name: 'Youssef',
        tableId: '12',
        tableNumber: '12',
      );
      expect(controller.tableMembers.length, 1);
    });

    test('3b. Debug seed and clear helpers work correctly', () {
      controller.seedOccupiedTableForPreview();
      expect(controller.tableMembers.length, 3);
      expect(controller.isCurrentTableEmpty, isFalse);
      expect(
          controller.tableOccupancyState.value, TableOccupancyState.occupied);

      controller.clearPreviewTable();
      expect(controller.tableMembers, isEmpty);
      expect(controller.isCurrentTableEmpty, isTrue);
      expect(controller.tableOccupancyState.value, TableOccupancyState.empty);
    });

    test('4. Occupied table creates a pending request', () async {
      controller.seedOccupiedTableForPreview();
      expect(controller.activeApprovedMembers, isNotEmpty);

      var directJoined = false;
      var waitingOpened = false;

      final handled = await controller.continueAfterNameEntry(
        name: 'Youssef',
        tableId: '12',
        tableNumber: '12',
        simulationDelay: Duration.zero,
        onDirectJoin: () => directJoined = true,
        onWaitingApproval: () => waitingOpened = true,
      );

      expect(handled, isTrue);
      expect(directJoined, isFalse);
      expect(waitingOpened, isTrue);
      expect(controller.currentRequest.value.status,
          JoinRequestPreviewStatus.pending);
      expect(controller.currentRequest.value.requesterName, 'Youssef');
    });

    test('5. Occupied table does not grant immediate access', () async {
      controller.restoreDefaultMembers();
      final initialMemberCount = controller.tableMembers.length;

      await controller.continueAfterNameEntry(
        name: 'Youssef',
        tableId: '12',
        tableNumber: '12',
        simulationDelay: Duration.zero,
      );

      // Requester is not added to table members yet
      expect(controller.tableMembers.length, initialMemberCount);
      expect(
        controller.tableMembers.any((m) => m.name == 'Youssef'),
        isFalse,
      );
    });

    test('6. Requester cannot approve themselves', () {
      final canApprove = controller.canApproveRequest(
        request: pendingRequest,
        actingMember: requester,
      );
      expect(canApprove, isFalse);

      final approved = controller.approveRequest(
        request: pendingRequest,
        actingMember: requester,
      );
      expect(approved, isFalse);
      expect(controller.status, isNot(JoinRequestPreviewStatus.approved));
    });

    test('7. Another approved member can approve', () {
      final canAhmedApprove = controller.canApproveRequest(
        request: pendingRequest,
        actingMember: approvedMemberAhmed,
      );
      expect(canAhmedApprove, isTrue);

      final success = controller.approveRequest(
        request: pendingRequest,
        actingMember: approvedMemberAhmed,
      );
      expect(success, isTrue);
      expect(controller.status, JoinRequestPreviewStatus.approved);
    });

    test('8. Pending members are not counted as table occupants', () {
      controller.setNoActiveMembers();
      controller.tableMembers.add(
        const PreviewTableMember(
          id: 'member_pending',
          name: 'PendingUser',
          tableSessionId: 'table_12',
          isApproved: false,
          isActive: true,
        ),
      );

      expect(controller.activeApprovedMembers, isEmpty);
      expect(controller.isCurrentTableEmpty, isTrue);
    });

    test('9. Inactive members are not counted', () {
      controller.setNoActiveMembers();
      controller.tableMembers.add(
        const PreviewTableMember(
          id: 'member_left',
          name: 'LeftUser',
          tableSessionId: 'table_12',
          isApproved: true,
          isActive: false,
        ),
      );

      expect(controller.activeApprovedMembers, isEmpty);
      expect(controller.isCurrentTableEmpty, isTrue);
    });

    test('10. Members from another table are not counted', () {
      controller.setNoActiveMembers();
      controller.tableMembers.add(
        const PreviewTableMember(
          id: 'member_table_99',
          name: 'Table99User',
          tableSessionId: 'table_99',
          isApproved: true,
          isActive: true,
        ),
      );

      controller.currentTableSessionId = 'table_12';
      expect(controller.activeApprovedMembers, isEmpty);
      expect(controller.isCurrentTableEmpty, isTrue);
    });

    test('11. Loading is not treated as empty', () async {
      controller.setForcedDebugOccupancy(TableOccupancyState.loading);

      var directJoined = false;
      var waitingOpened = false;

      final handled = await controller.continueAfterNameEntry(
        name: 'Youssef',
        tableId: '12',
        tableNumber: '12',
        simulationDelay: Duration.zero,
        onDirectJoin: () => directJoined = true,
        onWaitingApproval: () => waitingOpened = true,
      );

      expect(handled, isFalse);
      expect(directJoined, isFalse);
      expect(waitingOpened, isFalse);
    });

    test('12. Error is not treated as empty', () async {
      controller.setForcedDebugOccupancy(TableOccupancyState.error);

      var directJoined = false;
      var waitingOpened = false;
      var errorMessage = '';

      final handled = await controller.continueAfterNameEntry(
        name: 'Youssef',
        tableId: '12',
        tableNumber: '12',
        simulationDelay: Duration.zero,
        onDirectJoin: () => directJoined = true,
        onWaitingApproval: () => waitingOpened = true,
        onError: (msg) => errorMessage = msg,
      );

      expect(handled, isFalse);
      expect(directJoined, isFalse);
      expect(waitingOpened, isFalse);
      expect(errorMessage, isNotEmpty);
    });

    test('13. Repeated Continue taps do not create duplicate members or routes',
        () async {
      controller.setNoActiveMembers();

      controller.isSubmitting.value = true;
      var directJoined = false;

      final handled = await controller.continueAfterNameEntry(
        name: 'Youssef',
        tableId: '12',
        tableNumber: '12',
        simulationDelay: Duration.zero,
        onDirectJoin: () => directJoined = true,
      );

      expect(handled, isFalse);
      expect(directJoined, isFalse);
    });

    test('14. Repeated Approve taps do not create duplicate members', () {
      controller.restoreDefaultMembers();
      final countBefore = controller.tableMembers.length;

      final success1 = controller.approveRequest(
        request: pendingRequest,
        actingMember: approvedMemberAhmed,
      );
      expect(success1, isTrue);
      expect(controller.tableMembers.length, countBefore + 1);

      // Repeated approval on already approved request
      final success2 = controller.approveRequest(
        request: controller.currentRequest.value,
        actingMember: approvedMemberAhmed,
      );
      expect(success2, isFalse);
      expect(controller.tableMembers.length, countBefore + 1);
    });
  });
}
