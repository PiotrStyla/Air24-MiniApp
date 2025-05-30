import 'package:flutter/material.dart';

/// A generic pagination service that handles lazy loading for lists of data.
class PaginationService<T> {
  /// The initial page size.
  final int pageSize;
  
  /// The maximum number of items to load in total.
  final int? maxItems;
  
  /// The current data items that have been loaded.
  List<T> _items = [];
  
  /// Whether there are more items to load.
  bool _hasMore = true;
  
  /// The current page index.
  int _currentPage = 0;
  
  /// Whether a load operation is currently in progress.
  bool _isLoading = false;
  
  /// The error that occurred during loading, if any.
  Object? _error;

  /// Creates a new pagination service.
  PaginationService({
    this.pageSize = 20,
    this.maxItems,
  });

  /// The current items that have been loaded.
  List<T> get items => _items;
  
  /// Whether there are more items to load.
  bool get hasMore => _hasMore;
  
  /// Whether a load operation is currently in progress.
  bool get isLoading => _isLoading;
  
  /// The error that occurred during loading, if any.
  Object? get error => _error;

  /// Loads the next page of items using the provided loader function.
  Future<void> loadNextPage(Future<List<T>> Function(int offset, int limit) loader) async {
    if (_isLoading || !_hasMore) return;
    
    try {
      _isLoading = true;
      _error = null;
      
      final offset = _currentPage * pageSize;
      final itemsToFetch = maxItems != null ? 
          (offset + pageSize <= maxItems! ? pageSize : maxItems! - offset) : 
          pageSize;
          
      if (itemsToFetch <= 0) {
        _hasMore = false;
        return;
      }
      
      final newItems = await loader(offset, itemsToFetch);
      
      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        _items.addAll(newItems);
        _currentPage++;
        
        if (maxItems != null && _items.length >= maxItems!) {
          _hasMore = false;
        }
      }
    } catch (e) {
      _error = e;
      debugPrint('Error loading pagination data: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Refreshes the data by clearing existing items and loading the first page.
  Future<void> refresh(Future<List<T>> Function(int offset, int limit) loader) async {
    _items = [];
    _currentPage = 0;
    _hasMore = true;
    _error = null;
    await loadNextPage(loader);
  }
}
