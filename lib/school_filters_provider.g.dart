// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'school_filters_provider.dart';

// // **************************************************************************
// // RiverpodGenerator
// // **************************************************************************

// String _$filteredSchoolsHash() => r'b9b30bcc54efff020d2430079e113ee923ebb7a0';

// /// Copied from Dart SDK
// class _SystemHash {
//   _SystemHash._();

//   static int combine(int hash, int value) {
//     // ignore: parameter_assignments
//     hash = 0x1fffffff & (hash + value);
//     // ignore: parameter_assignments
//     hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
//     return hash ^ (hash >> 6);
//   }

//   static int finish(int hash) {
//     // ignore: parameter_assignments
//     hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
//     // ignore: parameter_assignments
//     hash = hash ^ (hash >> 11);
//     return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
//   }
// }

// /// See also [filteredSchools].
// @ProviderFor(filteredSchools)
// const filteredSchoolsProvider = FilteredSchoolsFamily();

// /// See also [filteredSchools].
// class FilteredSchoolsFamily extends Family<AsyncValue<List<School>>> {
//   /// See also [filteredSchools].
//   const FilteredSchoolsFamily();

//   /// See also [filteredSchools].
//   FilteredSchoolsProvider call({
//     String? searchQuery,
//     String? region,
//     String? performanceFilter,
//   }) {
//     return FilteredSchoolsProvider(
//       searchQuery: searchQuery,
//       region: region,
//       performanceFilter: performanceFilter,
//     );
//   }

//   @override
//   FilteredSchoolsProvider getProviderOverride(
//     covariant FilteredSchoolsProvider provider,
//   ) {
//     return call(
//       searchQuery: provider.searchQuery,
//       region: provider.region,
//       performanceFilter: provider.performanceFilter,
//     );
//   }

//   static const Iterable<ProviderOrFamily>? _dependencies = null;

//   @override
//   Iterable<ProviderOrFamily>? get dependencies => _dependencies;

//   static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

//   @override
//   Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
//       _allTransitiveDependencies;

//   @override
//   String? get name => r'filteredSchoolsProvider';
// }

// /// See also [filteredSchools].
// class FilteredSchoolsProvider extends AutoDisposeFutureProvider<List<School>> {
//   /// See also [filteredSchools].
//   FilteredSchoolsProvider({
//     String? searchQuery,
//     String? region,
//     String? performanceFilter,
//   }) : this._internal(
//           (ref) => filteredSchools(
//             ref as FilteredSchoolsRef,
//             searchQuery: searchQuery,
//             region: region,
//             performanceFilter: performanceFilter,
//           ),
//           from: filteredSchoolsProvider,
//           name: r'filteredSchoolsProvider',
//           debugGetCreateSourceHash:
//               const bool.fromEnvironment('dart.vm.product')
//                   ? null
//                   : _$filteredSchoolsHash,
//           dependencies: FilteredSchoolsFamily._dependencies,
//           allTransitiveDependencies:
//               FilteredSchoolsFamily._allTransitiveDependencies,
//           searchQuery: searchQuery,
//           region: region,
//           performanceFilter: performanceFilter,
//         );

//   FilteredSchoolsProvider._internal(
//     super._createNotifier, {
//     required super.name,
//     required super.dependencies,
//     required super.allTransitiveDependencies,
//     required super.debugGetCreateSourceHash,
//     required super.from,
//     required this.searchQuery,
//     required this.region,
//     required this.performanceFilter,
//   }) : super.internal();

//   final String? searchQuery;
//   final String? region;
//   final String? performanceFilter;

//   @override
//   Override overrideWith(
//     FutureOr<List<School>> Function(FilteredSchoolsRef provider) create,
//   ) {
//     return ProviderOverride(
//       origin: this,
//       override: FilteredSchoolsProvider._internal(
//         (ref) => create(ref as FilteredSchoolsRef),
//         from: from,
//         name: null,
//         dependencies: null,
//         allTransitiveDependencies: null,
//         debugGetCreateSourceHash: null,
//         searchQuery: searchQuery,
//         region: region,
//         performanceFilter: performanceFilter,
//       ),
//     );
//   }

//   @override
//   AutoDisposeFutureProviderElement<List<School>> createElement() {
//     return _FilteredSchoolsProviderElement(this);
//   }

//   @override
//   bool operator ==(Object other) {
//     return other is FilteredSchoolsProvider &&
//         other.searchQuery == searchQuery &&
//         other.region == region &&
//         other.performanceFilter == performanceFilter;
//   }

//   @override
//   int get hashCode {
//     var hash = _SystemHash.combine(0, runtimeType.hashCode);
//     hash = _SystemHash.combine(hash, searchQuery.hashCode);
//     hash = _SystemHash.combine(hash, region.hashCode);
//     hash = _SystemHash.combine(hash, performanceFilter.hashCode);

//     return _SystemHash.finish(hash);
//   }
// }

// @Deprecated('Will be removed in 3.0. Use Ref instead')
// // ignore: unused_element
// mixin FilteredSchoolsRef on AutoDisposeFutureProviderRef<List<School>> {
//   /// The parameter `searchQuery` of this provider.
//   String? get searchQuery;

//   /// The parameter `region` of this provider.
//   String? get region;

//   /// The parameter `performanceFilter` of this provider.
//   String? get performanceFilter;
// }

// class _FilteredSchoolsProviderElement
//     extends AutoDisposeFutureProviderElement<List<School>>
//     with FilteredSchoolsRef {
//   _FilteredSchoolsProviderElement(super.provider);

//   @override
//   String? get searchQuery => (origin as FilteredSchoolsProvider).searchQuery;
//   @override
//   String? get region => (origin as FilteredSchoolsProvider).region;
//   @override
//   String? get performanceFilter =>
//       (origin as FilteredSchoolsProvider).performanceFilter;
// }

// String _$schoolStatisticsHash() => r'e92d15304a558661605fcc0ef3d0a8e71d397ed8';

// /// See also [schoolStatistics].
// @ProviderFor(schoolStatistics)
// final schoolStatisticsProvider =
//     AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
//   schoolStatistics,
//   name: r'schoolStatisticsProvider',
//   debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
//       ? null
//       : _$schoolStatisticsHash,
//   dependencies: null,
//   allTransitiveDependencies: null,
// );

// @Deprecated('Will be removed in 3.0. Use Ref instead')
// // ignore: unused_element
// typedef SchoolStatisticsRef
//     = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
// // ignore_for_file: type=lint
// // ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
