import 'package:flutter_test/flutter_test.dart';
import 'package:beanza/features/table_session/presentation/controllers/join_approval_preview_controller.dart';
import 'package:beanza/features/table_session/presentation/models/join_request_preview_status.dart';
import 'package:beanza/features/table_session/presentation/models/preview_join_request.dart';
import 'package:beanza/features/table_session/presentation/models/preview_table_member.dart';

void main() {
  group('Table Join Approval Logic Unit Tests', () {
    late JoinApprovalPreviewController controller;

    const requester = PreviewTableMember(
      id: 'member_youssef',
      name: 'Youssef',
      isApproved: false,
    );

    const approvedMemberAhmed = PreviewTableMember(
      id: 'member_ahmed',
      name: 'Ahmed',
      isApproved: true,
    );

    const approvedMemberSara = PreviewTableMember(
      id: 'member_sara',
      name: 'Sara',
      isApproved: true,
    );

    const unapprovedMember = PreviewTableMember(
      id: 'member_guest_unapproved',
      name: 'Tariq',
      isApproved: false,
    );

    const pendingRequest = PreviewJoinRequest(
      id: 'req_101',
      requesterId: 'member_youssef',
      requesterName: 'Youssef',
      tableSessionId: 'table_12',
      status: JoinRequestPreviewStatus.pending,
    );

    setUp(() {
      controller = JoinApprovalPreviewController();
    });

    test('1. A requester cannot approve their own request', () {
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

    test('2. A non-approved member cannot approve', () {
      final canApprove = controller.canApproveRequest(
        request: pendingRequest,
        actingMember: unapprovedMember,
      );
      expect(canApprove, isFalse);

      final approved = controller.approveRequest(
        request: pendingRequest,
        actingMember: unapprovedMember,
      );
      expect(approved, isFalse);
      expect(controller.status, isNot(JoinRequestPreviewStatus.approved));
    });

    test('3. An approved different member can approve', () {
      final canApprove = controller.canApproveRequest(
        request: pendingRequest,
        actingMember: approvedMemberAhmed,
      );
      expect(canApprove, isTrue);

      final canSaraApprove = controller.canApproveRequest(
        request: pendingRequest,
        actingMember: approvedMemberSara,
      );
      expect(canSaraApprove, isTrue);
    });

    test('4. One valid approval changes the state to Approved', () {
      expect(controller.status, JoinRequestPreviewStatus.pending);

      final success = controller.approveRequest(
        request: pendingRequest,
        actingMember: approvedMemberAhmed,
      );

      expect(success, isTrue);
      expect(controller.status, JoinRequestPreviewStatus.approved);
      expect(controller.currentRequest.value.status,
          JoinRequestPreviewStatus.approved);
    });

    test('5. An already decided request cannot be approved again', () {
      // 1st approval -> success
      final firstApprove = controller.approveRequest(
        request: pendingRequest,
        actingMember: approvedMemberAhmed,
      );
      expect(firstApprove, isTrue);

      // Now status is approved, trying to approve again on the updated request
      final canApproveAgain = controller.canApproveRequest(
        request: controller.currentRequest.value,
        actingMember: approvedMemberSara,
      );
      expect(canApproveAgain, isFalse);

      final secondApprove = controller.approveRequest(
        request: controller.currentRequest.value,
        actingMember: approvedMemberSara,
      );
      expect(secondApprove, isFalse);
    });

    test('6. The requester remains Pending until another member approves', () {
      controller.initRequest(
        tableNumber: '12',
        requesterName: 'Youssef',
        initialStatus: JoinRequestPreviewStatus.pending,
      );

      expect(controller.status, JoinRequestPreviewStatus.pending);
      expect(controller.currentRequest.value.requesterName, 'Youssef');
    });

    test('7. No-member state does not auto-approve the requester', () {
      controller.setNoActiveMembers();
      expect(controller.hasActiveApprovedMembers, isFalse);
      expect(controller.approvedMembers, isEmpty);

      controller.initRequest(
        tableNumber: '12',
        requesterName: 'Youssef',
        initialStatus: JoinRequestPreviewStatus.pending,
      );

      expect(controller.status, JoinRequestPreviewStatus.pending);
      // Even without members, self-approval is rejected
      expect(
        controller.canApproveRequest(
          request: controller.currentRequest.value,
          actingMember: requester,
        ),
        isFalse,
      );
    });

    test('8. Duplicate approval taps do not create duplicate state transitions',
        () {
      final success1 = controller.approveRequest(
        request: pendingRequest,
        actingMember: approvedMemberAhmed,
      );
      expect(success1, isTrue);

      // Subsequent identical call on current state
      final success2 = controller.approveRequest(
        request: controller.currentRequest.value,
        actingMember: approvedMemberAhmed,
      );
      expect(success2, isFalse);
    });
  });
}
