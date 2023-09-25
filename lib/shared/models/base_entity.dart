class BaseEntity {
  final int? id;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  const BaseEntity({
    this.id,
    this.isDeleted,
    this.createdAt,
    this.modifiedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      isDeleted,
      createdAt,
      modifiedAt,
    ];
  }
}
