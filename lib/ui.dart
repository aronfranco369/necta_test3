import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:necta_test3/classes/school_model.dart';

import 'package:necta_test3/school_data_provider.dart';
import 'package:necta_test3/school_details.dart';

// Create a search filter provider

final schoolSearchProvider = StateProvider<String>((ref) => '');

// Create a filtered schools provider

final filteredSchoolsProvider = Provider<AsyncValue<List<School>>>((ref) {
  final schoolsAsync = ref.watch(schoolDataManagerProvider);

  final searchQuery = ref.watch(schoolSearchProvider).toLowerCase();

  return schoolsAsync.when(
    data: (schools) {
      if (searchQuery.isEmpty) return AsyncValue.data(schools);

      final filtered = schools.where((school) {
        final name = school.school.name.toLowerCase();

        final id = school.school.id.toLowerCase();

        final region = school.school.region.toLowerCase();

        return name.contains(searchQuery) || id.contains(searchQuery) || region.contains(searchQuery);
      }).toList();

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

class SchoolListScreen extends ConsumerWidget {
  SchoolListScreen({super.key});

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schoolsAsync = ref.watch(filteredSchoolsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schools'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(schoolDataManagerProvider.notifier).refresh();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search schools...',
              onChanged: (value) {
                ref.read(schoolSearchProvider.notifier).state = value;
              },
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();

                      ref.read(schoolSearchProvider.notifier).state = '';
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      body: schoolsAsync.when(
        data: (schools) => schools.isEmpty
            ? const Center(child: Text('No schools found'))
            : SchoolListView(
                schools: schools,
                scrollController: _scrollController,
              ),
        loading: () => const LoadingView(),
        error: (error, stackTrace) => ErrorView(
          error: error,
          onRetry: () => ref.refresh(schoolDataManagerProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
          );
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}

class SchoolListView extends StatelessWidget {
  final List<School> schools;

  final ScrollController scrollController;

  const SchoolListView({
    super.key,
    required this.schools,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: schools.length,
      itemBuilder: (context, index) {
        final school = schools[index];

        return SchoolListTile(school: school);
      },
    );
  }
}

class SchoolListTile extends StatelessWidget {
  final School school;

  const SchoolListTile({
    super.key,
    required this.school,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SchoolDetailsScreen(school: school),
            ),
          );
        },
        title: Text(
          '${school.school.id} ${school.school.name}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(school.school.region),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading schools...'),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final Object error;

  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load schools: ${error.toString()}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
