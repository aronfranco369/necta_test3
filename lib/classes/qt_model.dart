class SchoolQt {
  final SchoolInfo school;
  final Divisions divisions;
  final List<StudentResult> results;

  SchoolQt({
    required this.school,
    required this.divisions,
    required this.results,
  });

  factory SchoolQt.fromJson(dynamic json) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(json);
    return SchoolQt(
      school: SchoolInfo.fromJson(Map<String, dynamic>.from(data['school'])),
      divisions: Divisions.fromJson(Map<String, dynamic>.from(data['divisions'])),
      results: (data['results'] as List).map((x) => StudentResult.fromJson(Map<String, dynamic>.from(x))).toList(),
    );
  }
}

class SchoolInfo {
  final String id;
  final String name;
  final String url;

  SchoolInfo({
    required this.id,
    required this.name,
    required this.url,
  });

  factory SchoolInfo.fromJson(Map<String, dynamic> json) {
    return SchoolInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }
}

class DivisionCount {
  final int divI;
  final int divII;
  final int divIII;
  final int divIV;
  final int div0;

  DivisionCount({
    required this.divI,
    required this.divII,
    required this.divIII,
    required this.divIV,
    required this.div0,
  });

  factory DivisionCount.fromJson(Map<String, dynamic> json) {
    return DivisionCount(
      divI: int.tryParse(json['I']?.toString() ?? '0') ?? 0,
      divII: int.tryParse(json['II']?.toString() ?? '0') ?? 0,
      divIII: int.tryParse(json['III']?.toString() ?? '0') ?? 0,
      divIV: int.tryParse(json['IV']?.toString() ?? '0') ?? 0,
      div0: int.tryParse(json['0']?.toString() ?? '0') ?? 0,
    );
  }
}

class Divisions {
  final DivisionCount female;
  final DivisionCount male;
  final DivisionCount total;

  Divisions({
    required this.female,
    required this.male,
    required this.total,
  });

  factory Divisions.fromJson(Map<String, dynamic> json) {
    return Divisions(
      female: DivisionCount.fromJson(Map<String, dynamic>.from(json['female'])),
      male: DivisionCount.fromJson(Map<String, dynamic>.from(json['male'])),
      total: DivisionCount.fromJson(Map<String, dynamic>.from(json['total'])),
    );
  }
}

class Subject {
  final String code;
  final String grade;

  Subject({
    required this.code,
    required this.grade,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      code: json['code']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
    );
  }
}

class StudentResult {
  final String studentId;
  final String sex;
  final String aggregate;
  final String division;
  final List<Subject> subjects;

  StudentResult({
    required this.studentId,
    required this.sex,
    required this.aggregate,
    required this.division,
    required this.subjects,
  });

  factory StudentResult.fromJson(Map<String, dynamic> json) {
    return StudentResult(
      studentId: json['studentId']?.toString() ?? '',
      sex: json['sex']?.toString() ?? '',
      aggregate: json['aggregate']?.toString() ?? '',
      division: json['division']?.toString() ?? '',
      subjects: (json['subjects'] as List).map((x) => Subject.fromJson(Map<String, dynamic>.from(x))).toList(),
    );
  }
}
