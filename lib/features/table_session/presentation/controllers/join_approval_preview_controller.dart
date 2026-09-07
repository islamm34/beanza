import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/table_session_controller.dart';
import '../models/join_request_preview_status.dart';
import '../models/preview_join_request.dart';
import '../models/preview_table_member.dart';
import '../models/table_occupancy_state.dart';

class JoinApprovalPreviewController extends GetxController {
  static const String defaultRequesterId = 'member_youssef';
  static const String defaultRequesterName = 'Youssef';
  static const String defaultTableSessionId = 'table_12';

  static const PreviewTableMember memberAhmed = PreviewTableMember(
    id: 'member_ahmed',
    name: 'Ahmed',
    tableSessionId: defaultTableSessionId,
    isApproved: true,
    isActive: true,
  );

  static const PreviewTableMember memberSara = PreviewTableMember(
    id: 'member_sara',
    name: 'Sara',
    tableSessionId: defaultTableSessionId,
    isApproved: true,
    isActive: true,
  );

  static const PreviewTableMember memberMostafa = PreviewTableMember(
    id: 'member_mostafa',
    name: 'Mostafa',
    tableSessionId: defaultTableSessionId,
    isApproved: true,
    isActive: true,
  );

  static const PreviewTableMember requesterAsMember = PreviewTableMember(
    id: defaultRequesterId,
    name: defaultRequesterName,
    tableSessionId: defaultTableSessionId,
    isApproved: false,
    isActive: true,
  );

  static const PreviewTableMember unapprovedGuest = PreviewTableMember(
    id: 'member_guest_unapproved',
    name: 'Tariq',
    tableSessionId: defaultTableSessionId,
    isApproved: false,
    isActive: true,
  );

  // TODO: Replace local empty-table state with backend session members when the real table-session backend is connected.
  final tableMembers = <PreviewTableMember>[].obs;

  late final Rx<PreviewTableMember> actingMember =
      Rx<PreviewTableMember>(memberAhmed);

  late final Rx<PreviewJoinRequest> currentRequest = Rx<PreviewJoinRequest>(
    const PreviewJoinRequest(
      id: '',
      requesterId: '',
      requesterName: '',
      tableSessionId: '',
      status: JoinRequestPreviewStatus.cancelled,
    ),
  );

  String currentTableSessionId = defaultTableSessionId;
  String currentUserId = defaultRequesterId;
  String? currentProfileAvatar;

  final enteredName = ''.obs;
  final tableOccupancyState = TableOccupancyState.empty.obs;
  final isCheckingTable = false.obs;
  final isSubmitting = false.obs;
  final checkErrorMessage = Rxn<String>();

  // Forced debug occupancy mode (null = dynamically computed from activeApprovedMembers)
  final forcedDebugOccupancy = Rxn<TableOccupancyState>();

  JoinRequestPreviewStatus get status => currentRequest.value.status;

  List<PreviewTableMember> get approvedMembers =>
      tableMembers.where((m) => m.isApproved).toList();

  /// Count only approved, active members belonging to the current table session.
  List<PreviewTableMember> get activeApprovedMembers {
    return tableMembers.where((member) {
      return member.tableSessionId == currentTableSessionId &&
          member.isApproved &&
          member.isActive;
    }).toList();
  }

  bool get isCurrentTableEmpty => activeApprovedMembers.isEmpty;

  bool get hasActiveApprovedMembers => activeApprovedMembers.isNotEmpty;

  TableOccupancyState computeOccupancy() {
    if (forcedDebugOccupancy.value != null) {
      return forcedDebugOccupancy.value!;
    }
    return isCurrentTableEmpty
        ? TableOccupancyState.empty
        : TableOccupancyState.occupied;
  }

  Future<TableOccupancyState> checkTableOccupancy({
    required String tableNumber,
    Duration simulationDelay = const Duration(milliseconds: 300),
  }) async {
    currentTableSessionId = 'table_$tableNumber';
    isCheckingTable.value = true;
    checkErrorMessage.value = null;

    if (simulationDelay > Duration.zero) {
      await Future.delayed(simulationDelay);
    }

    final state = computeOccupancy();
    tableOccupancyState.value = state;
    isCheckingTable.value = false;
    return state;
  }

  Future<bool> continueAfterNameEntry({
    required String name,
    required String tableId,
    required String tableNumber,
    String? avatarPath,
    Duration simulationDelay = const Duration(milliseconds: 300),
    VoidCallback? onDirectJoin,
    VoidCallback? onWaitingApproval,
    void Function(String message)? onError,
  }) async {
    if (isCheckingTable.value || isSubmitting.value) {
      return false;
    }

    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return false;
    }

    enteredName.value = trimmedName;
    currentProfileAvatar = avatarPath;
    isSubmitting.value = true;

    try {
      final occupancy = await checkTableOccupancy(
        tableNumber: tableNumber,
        simulationDelay: simulationDelay,
      );

      switch (occupancy) {
        case TableOccupancyState.empty:
          joinAsFirstMember(
            name: trimmedName,
            tableId: tableId,
            tableNumber: tableNumber,
            avatarPath: avatarPath,
          );
          onDirectJoin?.call();
          return true;

        case TableOccupancyState.occupied:
          createLocalPendingRequest(
            name: trimmedName,
            tableNumber: tableNumber,
            avatarPath: avatarPath,
          );
          onWaitingApproval?.call();
          return true;

        case TableOccupancyState.loading:
          return false;

        case TableOccupancyState.error:
          final msg = checkErrorMessage.value ??
              'Unable to check table status. Please try again.';
          onError?.call(msg);
          return false;
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  bool joinAsFirstMember({
    required String name,
    required String tableId,
    required String tableNumber,
    String? avatarPath,
  }) {
    final sessionId = 'table_$tableNumber';
    final alreadyExists = tableMembers.any((m) =>
        m.id == currentUserId &&
        m.tableSessionId == sessionId &&
        m.isApproved &&
        m.isActive);

    if (!alreadyExists) {
      final member = PreviewTableMember(
        id: currentUserId,
        name: name,
        avatarPath: avatarPath,
        tableSessionId: sessionId,
        isApproved: true,
        isActive: true,
      );
      tableMembers.add(member);
    }

    if (Get.isRegistered<TableSessionController>()) {
      final sessionCtrl = Get.find<TableSessionController>();
      sessionCtrl.startSingleMemberSession(
        tableId: tableId,
        tableNumber: tableNumber,
        participantName: name,
      );
    }
    return true;
  }

  void createLocalPendingRequest({
    required String name,
    required String tableNumber,
    String? avatarPath,
  }) {
    initRequest(
      tableNumber: tableNumber,
      requesterName: name,
      requesterId: currentUserId,
      initialStatus: JoinRequestPreviewStatus.pending,
    );
  }

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

    // 2. Only approved table members can approve
    if (!actingMember.isApproved) {
      return false;
    }

    // 3. Only active members can approve
    if (!actingMember.isActive) {
      return false;
    }

    // 4. Must belong to the same table session
    if (actingMember.tableSessionId != request.tableSessionId) {
      return false;
    }

    // 5. Only pending requests can be approved
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

    // 3. Only active members can reject
    if (!actingMember.isActive) {
      return false;
    }

    // 4. Must belong to the same table session
    if (actingMember.tableSessionId != request.tableSessionId) {
      return false;
    }

    // 5. Only pending requests can be rejected
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

    // Add requester once to approved table members
    final requesterExists = tableMembers.any((m) =>
        m.id == request.requesterId &&
        m.tableSessionId == request.tableSessionId &&
        m.isApproved &&
        m.isActive);

    if (!requesterExists) {
      tableMembers.add(
        PreviewTableMember(
          id: request.requesterId,
          name: request.requesterName,
          tableSessionId: request.tableSessionId,
          isApproved: true,
          isActive: true,
        ),
      );
    }

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

  void seedOccupiedTableForPreview() {
    if (!kDebugMode) return;
    forcedDebugOccupancy.value = null;
    tableMembers.assignAll([
      memberAhmed,
      memberSara,
      memberMostafa,
    ]);
    tableOccupancyState.value = TableOccupancyState.occupied;
  }

  void clearPreviewTable() {
    if (!kDebugMode) return;
    forcedDebugOccupancy.value = null;
    tableMembers.clear();
    tableOccupancyState.value = TableOccupancyState.empty;
  }

  void setNoActiveMembers() {
    tableMembers.clear();
    tableOccupancyState.value = TableOccupancyState.empty;
  }

  void setForcedDebugOccupancy(TableOccupancyState? state) {
    forcedDebugOccupancy.value = state;
    if (state != null) {
      tableOccupancyState.value = state;
    }
  }

  void restoreDefaultMembers() {
    forcedDebugOccupancy.value = null;
    tableMembers.assignAll([
      memberAhmed,
      memberSara,
      memberMostafa,
    ]);
    tableOccupancyState.value = TableOccupancyState.occupied;
  }
}
