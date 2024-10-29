// Models for handling the complex school data structure
class School {
  final SchoolInfo school;
  final List<StudentStats> students;
  final Divisions divisions;
  final List<Centre> centre;
  final List<StudentResult> results;

  School({
    required this.school,
    required this.students,
    required this.divisions,
    required this.centre,
    required this.results,
  });

  factory School.fromJson(dynamic json) {
    // Convert the dynamic map to Map<String, dynamic>
    final Map<String, dynamic> data = Map<String, dynamic>.from(json);

    return School(
      school: SchoolInfo.fromJson(Map<String, dynamic>.from(data['school'])),
      students: (data['students'] as List).map((x) => StudentStats.fromJson(Map<String, dynamic>.from(x))).toList(),
      divisions: Divisions.fromJson(Map<String, dynamic>.from(data['divisions'])),
      centre: (data['centre'] as List).map((x) => Centre.fromJson(Map<String, dynamic>.from(x))).toList(),
      results: (data['results'] as List).map((x) => StudentResult.fromJson(Map<String, dynamic>.from(x))).toList(),
    );
  }
}

class SchoolInfo {
  final String id;
  final String name;
  final String url;
  final String region;
  final String passed;
  final String gpa;
  final String grade;

  SchoolInfo({
    required this.id,
    required this.name,
    required this.url,
    required this.region,
    required this.passed,
    required this.gpa,
    required this.grade,
  });

  factory SchoolInfo.fromJson(Map<String, dynamic> json) {
    return SchoolInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      passed: json['passed']?.toString() ?? '',
      gpa: json['gpa']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
    );
  }
}

class StudentStats {
  final String registered;
  final String absent;
  final String sat;
  final String withheld;
  final String noca;
  final String clean;

  StudentStats({
    required this.registered,
    required this.absent,
    required this.sat,
    required this.withheld,
    required this.noca,
    required this.clean,
  });

  factory StudentStats.fromJson(Map<String, dynamic> json) {
    return StudentStats(
      registered: json['registered']?.toString() ?? '',
      absent: json['absent']?.toString() ?? '',
      sat: json['sat']?.toString() ?? '',
      withheld: json['withheld']?.toString() ?? '',
      noca: json['noca']?.toString() ?? '',
      clean: json['clean']?.toString() ?? '',
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

class Centre {
  final String code;
  final String name;
  final String registered;
  final String sat;
  final String noca;
  final String withheld;
  final String clean;
  final String pass;
  final String gpa;
  final String grade;

  Centre({
    required this.code,
    required this.name,
    required this.registered,
    required this.sat,
    required this.noca,
    required this.withheld,
    required this.clean,
    required this.pass,
    required this.gpa,
    required this.grade,
  });

  factory Centre.fromJson(Map<String, dynamic> json) {
    return Centre(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      registered: json['registered']?.toString() ?? '',
      sat: json['sat']?.toString() ?? '',
      noca: json['noca']?.toString() ?? '',
      withheld: json['withheld']?.toString() ?? '',
      clean: json['clean']?.toString() ?? '',
      pass: json['pass']?.toString() ?? '',
      gpa: json['gpa']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
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
