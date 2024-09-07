class TreeEntity {
  final int id;
  final int level;
  final String name;
  final int? parent;

  TreeEntity({
    required this.id,
    required this.level,
    required this.name,
    this.parent,
  });

  factory TreeEntity.fromJson(Map<String, dynamic> json) {
    return TreeEntity(
      id: json['id'],
      level: json['level'],
      name: json['name'],
      parent: json['parent'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'name': name,
      'parent': parent,
    };
  }
}
