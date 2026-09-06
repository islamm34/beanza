import 'join_request_preview_status.dart';

class PreviewJoinRequest {
  const PreviewJoinRequest({
    required this.id,
    required this.requesterId,
    required this.requesterName,
    required this.tableSessionId,
    required this.status,
  });

  final String id;
  final String requesterId;
  final String requesterName;
  final String tableSessionId;
  final JoinRequestPreviewStatus status;

  PreviewJoinRequest copyWith({
    String? id,
    String? requesterId,
    String? requesterName,
    String? tableSessionId,
    JoinRequestPreviewStatus? status,
  }) {
    return PreviewJoinRequest(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      requesterName: requesterName ?? this.requesterName,
      tableSessionId: tableSessionId ?? this.tableSessionId,
      status: status ?? this.status,
    );
  }
}
