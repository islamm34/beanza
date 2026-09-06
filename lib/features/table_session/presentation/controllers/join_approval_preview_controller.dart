import 'package:get/get.dart';
import '../models/join_request_preview_status.dart';
import '../models/preview_join_request.dart';
import '../models/preview_table_member.dart';

class JoinApprovalPreviewController extends GetxController {
  static const String defaultRequesterId = 'member_youssef';
  static const String defaultRequesterName = 'Youssef';
  static const String defaultTableSessionId = 'table_12';

  static const PreviewTableMember memberAhmed = PreviewTableMember(
    id: 'member_ahmed',
    name: 'Ahmed',
    isApproved: true,
  );

  static const PreviewTableMember memberSara = PreviewTableMember(
    id: 'member_sara',
    name: 'Sara',
    isApproved: true,
  );

  static const PreviewTableMember memberMostafa = PreviewTableMember(
    id: 'member_mostafa',
    name: 'Mostafa',
    isApproved: true,
  );

  static const PreviewTableMember requesterAsMember = PreviewTableMember(
    id: defaultRequesterId,
    name: defaultRequesterName,
    isApproved: false,
  );

  static const PreviewTableMember unapprovedGuest = PreviewTableMember(
    id: 'member_guest_unapproved',
    name: 'Tariq',
    isApproved: false,
  );

  final tableMembers = <PreviewTableMember>[
    memberAhmed,
    memberSara,
    memberMostafa,
  ].obs;

  late final Rx<PreviewTableMember> actingMember =
      Rx<PreviewTableMember>(memberAhmed);

  late final Rx<PreviewJoinRequest> currentRequest = Rx<PreviewJoinRequest>(
    const PreviewJoinRequest(
      id: 'req_join_101',
      requesterId: defaultRequesterId,
      requesterName: defaultRequesterName,
      tableSessionId: defaultTableSessionId,
      status: JoinRequestPreviewStatus.pending,
    ),
  );

  JoinRequestPreviewStatus get status => currentRequest.value.status;
  List<PreviewTableMember> get approvedMembers =>
      tableMembers.where((m) => m.isApproved).toList();

  bool get hasActiveApprovedMembers => approvedMembers.isNotEmpty;

  void initRequest({
    String? tableNumber,
    String? requesterName,
    String? requesterId,
    JoinRequestPreviewStatus? initialStatus,
  }) {
    final reqName = requesterName ?? defaultRequesterName;
    final reqId = requesterId ?? defaultRequesterId;
    final tableId =
        tableNumber != null ? 'table_$tableNumber' : defaultTableSessionId;

    currentRequest.value = PreviewJoinRequest(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      requesterId: reqId,
      requesterName: reqName,
      tableSessionId: tableId,
      status: initialStatus ?? JoinRequestPreviewStatus.pending,
    );
  }

  bool canApproveRequest({
    required PreviewJoinRequest request,
    required PreviewTableMember actingMember,
  }) {
    // 1. Requester can never approve themselves (ID check)
    if (actingMember.id == request.requesterId) {
      return false;
    }

    // 2. Only already approved table members can approve
    if (!actingMember.isApproved) {
      return false;
    }

    // 3. Only pending requests can be approved
    if (request.status != JoinRequestPreviewStatus.pending) {
      return false;
    }

    return true;
  }

  bool canRejectRequest({
    required PreviewJoinRequest request,
    required PreviewTableMember actingMember,
  }) {
    // 1. Requester can never reject themselves (ID check)
    if (actingMember.id == request.requesterId) {
      return false;
    }

    // 2. Only approved table members can reject
    if (!actingMember.isApproved) {
      return false;
    }

    // 3. Only pending requests can be rejected
    if (request.status != JoinRequestPreviewStatus.pending) {
      return false;
    }

    return true;
  }

  bool approveRequest({
    required PreviewJoinRequest request,
    required PreviewTableMember actingMember,
  }) {
    if (!canApproveRequest(
      request: request,
      actingMember: actingMember,
    )) {
      return false;
    }

    currentRequest.value = request.copyWith(
      status: JoinRequestPreviewStatus.approved,
    );
    return true;
  }

  bool rejectRequest({
    required PreviewJoinRequest request,
    required PreviewTableMember actingMember,
  }) {
    if (!canRejectRequest(
      request: request,
      actingMember: actingMember,
    )) {
      return false;
    }

    currentRequest.value = request.copyWith(
      status: JoinRequestPreviewStatus.rejected,
    );
    return true;
  }

  void cancelRequest() {
    currentRequest.value = currentRequest.value.copyWith(
      status: JoinRequestPreviewStatus.cancelled,
    );
  }

  void resetToPending() {
    currentRequest.value = currentRequest.value.copyWith(
      status: JoinRequestPreviewStatus.pending,
    );
  }

  void expireRequest() {
    currentRequest.value = currentRequest.value.copyWith(
      status: JoinRequestPreviewStatus.expired,
    );
  }

  void setActingMember(PreviewTableMember member) {
    actingMember.value = member;
  }

  void setNoActiveMembers() {
    tableMembers.clear();
  }

  void restoreDefaultMembers() {
    tableMembers.assignAll([
      memberAhmed,
      memberSara,
      memberMostafa,
    ]);
  }
}
