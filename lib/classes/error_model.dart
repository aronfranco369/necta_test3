// Model class for handling error data from JSON
class ErrorSchool {
  final String id;
  final String name;
  final String url;

  // Constructor
  ErrorSchool({
    required this.id,
    required this.name,
    required this.url,
  });

  // Factory constructor to create ErrorSchool instance from JSON
  factory ErrorSchool.fromJson(dynamic json) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(json);
    return ErrorSchool(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      url: data['url']?.toString() ?? '',
    );
  }

  // Convert ErrorSchool instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
    };
  }

  // Copy with method for creating a copy with modified fields
  ErrorSchool copyWith({
    String? id,
    String? name,
    String? url,
  }) {
    return ErrorSchool(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  // Override toString for better debugging
  @override
  String toString() {
    return 'ErrorSchool(id: $id, name: $name, url: $url)';
  }

  // Override equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ErrorSchool && other.id == id && other.name == name && other.url == url;
  }

  // Override hashCode
  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ url.hashCode;
}
