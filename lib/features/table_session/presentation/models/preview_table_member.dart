class PreviewTableMember {
  const PreviewTableMember({
    required this.id,
    required this.name,
    this.avatarPath,
    this.tableSessionId = 'table_12',
    required this.isApproved,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? avatarPath;
  final String tableSessionId;
  final bool isApproved;
  final bool isActive;

  PreviewTableMember copyWith({
    String? id,
    String? name,
    String? avatarPath,
    String? tableSessionId,
    bool? isApproved,
    bool? isActive,
  }) {
    return PreviewTableMember(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      tableSessionId: tableSessionId ?? this.tableSessionId,
      isApproved: isApproved ?? this.isApproved,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreviewTableMember &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          tableSessionId == other.tableSessionId;

  @override
  int get hashCode => id.hashCode ^ tableSessionId.hashCode;
}
