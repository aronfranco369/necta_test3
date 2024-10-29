import 'package:flutter/material.dart';
import 'package:necta_test3/classes/school_model.dart';

class SchoolDetailsScreen extends StatelessWidget {
  final School school;

  const SchoolDetailsScreen({
    super.key,
    required this.school,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(school.school.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SchoolPerformanceCard(school: school),
            const SizedBox(height: 16),
            StudentResultsList(results: school.results),
          ],
        ),
      ),
    );
  }
}

class SchoolPerformanceCard extends StatelessWidget {
  final School school;

  const SchoolPerformanceCard({
    super.key,
    required this.school,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'School Performance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard(
                    'GPA',
                    school.school.gpa,
                    Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    'Grade',
                    school.school.grade,
                    Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    'Pass Rate',
                    '${school.school.passed}%',
                    Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Division Distribution',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 64, // Account for padding
                child: DivisionDistributionChart(divisions: school.divisions),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      width: 120, // Fixed width for consistency
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use minimum space needed
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis, // Handle long text gracefully
          ),
        ],
      ),
    );
  }
}

class DivisionDistributionChart extends StatelessWidget {
  final Divisions divisions;

  const DivisionDistributionChart({
    super.key,
    required this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    final int maxCount = [
      divisions.total.divI,
      divisions.total.divII,
      divisions.total.divIII,
      divisions.total.divIV,
      divisions.total.div0,
    ].reduce((max, value) => max > value ? max : value);

    return Container(
      height: 100,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: _buildDivisionBar('I', divisions.total.divI, maxCount, Colors.green)),
          const SizedBox(width: 4),
          Expanded(child: _buildDivisionBar('II', divisions.total.divII, maxCount, Colors.blue)),
          const SizedBox(width: 4),
          Expanded(child: _buildDivisionBar('III', divisions.total.divIII, maxCount, Colors.orange)),
          const SizedBox(width: 4),
          Expanded(child: _buildDivisionBar('IV', divisions.total.divIV, maxCount, Colors.red)),
          const SizedBox(width: 4),
          Expanded(child: _buildDivisionBar('0', divisions.total.div0, maxCount, Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDivisionBar(String label, int count, int maxCount, Color color) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                FractionallySizedBox(
                  heightFactor: maxCount > 0 ? count / maxCount : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Div $label',
          style: const TextStyle(fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class StudentResultsList extends StatelessWidget {
  final List<StudentResult> results;

  const StudentResultsList({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Student Results',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${results.length} Students',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final result = results[index];
            return StudentResultCard(result: result);
          },
        ),
      ],
    );
  }
}

class StudentResultCard extends StatelessWidget {
  final StudentResult result;

  const StudentResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(
              result.sex.toLowerCase() == 'f' ? Icons.female : Icons.male,
              color: result.sex.toLowerCase() == 'f' ? Colors.pink : Colors.blue,
            ),
            const SizedBox(width: 8),
            Text('Student ${result.studentId}'),
          ],
        ),
        subtitle: Text(
          'Division ${result.division} (${result.aggregate})',
          style: TextStyle(
            color: _getDivisionColor(result.division),
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.subjects.map((subject) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getGradeColor(subject.grade).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getGradeColor(subject.grade).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    '${subject.code} - ${subject.grade}',
                    style: TextStyle(
                      color: _getGradeColor(subject.grade),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDivisionColor(String division) {
    switch (division) {
      case '1':
        return Colors.green;
      case '2':
        return Colors.blue;
      case '3':
        return Colors.orange;
      case '4':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getGradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.red;
      case 'F':
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }
}
