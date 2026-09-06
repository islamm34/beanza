class PreviewTableMember {
  const PreviewTableMember({
    required this.id,
    required this.name,
    this.avatarPath,
    required this.isApproved,
  });

  final String id;
  final String name;
  final String? avatarPath;
  final bool isApproved;
}
