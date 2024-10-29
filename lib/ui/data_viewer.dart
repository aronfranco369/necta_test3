import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:necta_test3/hive/processed_data.dart';
import 'package:necta_test3/file_processor.dart';

class DataViewer extends StatefulWidget {
  final String zipUrl;

  const DataViewer({Key? key, required this.zipUrl}) : super(key: key);

  @override
  State<DataViewer> createState() => _DataViewerState();
}

class _DataViewerState extends State<DataViewer> {
  final FileProcessor _fileProcessor = FileProcessor();

  ProcessedData? _data;

  bool _isLoading = true;

  String? _error;

  @override
  void initState() {
    super.initState();

    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      setState(() {
        _isLoading = true;

        _error = null;
      });

      // Check if data exists in Hive

      final storedData = await _fileProcessor.getStoredData();

      if (storedData != null) {
        print('GETTING DATA OFFLINE');
        print('GETTING DATA OFFLINE');
        print('GETTING DATA OFFLINE');
        print('GETTING DATA OFFLINE');

        setState(() {
          _data = storedData;

          _isLoading = false;
        });
      } else {
        print('GETTING DATA ONLINE');
        print('GETTING DATA ONLINE');
        print('GETTING DATA ONLINE');
        print('GETTING DATA ONLINE');
        print('GETTING DATA ONLINE');
        print('GETTING DATA ONLINE');
        print('GETTING DATA ONLINE');
        print('GETTING DATA ONLINE');
        print('GETTING DATA ONLINE');
        print('GETTING DATA ONLINE');

        // Process ZIP file if no stored data

        final processedData = await _fileProcessor.processAllFiles(widget.zipUrl);

        setState(() {
          _data = processedData;

          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();

        _isLoading = false;
      });
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $_error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _initializeData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataWidget() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Processed Data'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Schools'),
              Tab(text: 'Errors'),
              Tab(text: 'QT'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildListView(_data!.schools, 'Schools'),
            _buildListView(_data!.errors, 'Errors'),
            _buildListView(_data!.qt, 'QT'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // await _fileProcessor.clearStoredData();

            _initializeData();
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> items, String type) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text('Item ${index + 1}'),
            subtitle: Text(item.toString()),
            onTap: () {
              // Show detailed view in dialog

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('$type Details'),
                  content: SingleChildScrollView(
                    child: Text(
                      const JsonEncoder.withIndent('  ').convert(item),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading data...'),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(body: _buildErrorWidget());
    }

    if (_data == null) {
      return const Scaffold(
        body: Center(
          child: Text('No data available'),
        ),
      );
    }

    return _buildDataWidget();
  }
}
