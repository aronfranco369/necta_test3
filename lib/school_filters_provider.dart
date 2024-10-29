// // school_filters_provider.dart
// import 'package:necta_test3/classes/school_model.dart';
// import 'package:necta_test3/school_data_provider.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'school_filters_provider.g.dart';

// @riverpod
// Future<List<School>> filteredSchools(
//   FilteredSchoolsRef ref, {
//   String? searchQuery,
//   String? region,
//   String? performanceFilter,
// }) async {
//   final schoolsAsync = await ref.watch(schoolDataManagerProvider.future);

//   return schoolsAsync.where((school) {
//     bool matchesSearch = true;
//     bool matchesRegion = true;
//     bool matchesPerformance = true;

//     if (searchQuery != null && searchQuery.isNotEmpty) {
//       final query = searchQuery.toLowerCase();
//       matchesSearch = school.school.name.toLowerCase().contains(query) || school.school.id.toLowerCase().contains(query);
//     }

//     if (region != null && region.isNotEmpty) {
//       matchesRegion = school.school.region.toLowerCase() == region.toLowerCase();
//     }

//     if (performanceFilter != null && performanceFilter.isNotEmpty) {
//       final gpa = double.tryParse(school.school.gpa) ?? 0;
//       switch (performanceFilter) {
//         case 'high':
//           matchesPerformance = gpa >= 3.5;
//           break;
//         case 'medium':
//           matchesPerformance = gpa >= 2.5 && gpa < 3.5;
//           break;
//         case 'low':
//           matchesPerformance = gpa < 2.5;
//           break;
//       }
//     }

//     return matchesSearch && matchesRegion && matchesPerformance;
//   }).toList();
// }

// @riverpod
// Future<Map<String, dynamic>> schoolStatistics(SchoolStatisticsRef ref) async {
//   final schools = await ref.watch(schoolDataManagerProvider.future);

//   if (schools.isEmpty) {
//     return {
//       'totalSchools': 0,
//       'averageGPA': 0.0,
//       'totalStudents': 0,
//       'regionDistribution': <String, int>{},
//       'performanceDistribution': {
//         'high': 0,
//         'medium': 0,
//         'low': 0,
//       }
//     };
//   }

//   double totalGPA = 0;
//   int totalStudents = 0;
//   final regionDistribution = <String, int>{};
//   final performanceDistribution = {
//     'high': 0,
//     'medium': 0,
//     'low': 0,
//   };

//   for (final school in schools) {
//     final gpa = double.tryParse(school.school.gpa) ?? 0;
//     totalGPA += gpa;
//     totalStudents += int.tryParse(school.students.first.registered) ?? 0;

//     // Region distribution
//     regionDistribution[school.school.region] = (regionDistribution[school.school.region] ?? 0) + 1;

//     // Performance distribution
//     if (gpa >= 3.5) {
//       performanceDistribution['high'] = performanceDistribution['high']! + 1;
//     } else if (gpa >= 2.5) {
//       performanceDistribution['medium'] = performanceDistribution['medium']! + 1;
//     } else {
//       performanceDistribution['low'] = performanceDistribution['low']! + 1;
//     }
//   }

//   return {
//     'totalSchools': schools.length,
//     'averageGPA': totalGPA / schools.length,
//     'totalStudents': totalStudents,
//     'regionDistribution': regionDistribution,
//     'performanceDistribution': performanceDistribution,
//   };
// }
