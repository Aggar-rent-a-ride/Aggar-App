import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_state.dart';

class SearchCubit extends Cubit<SearchCubitState> {
  final TextEditingController textController = TextEditingController();
  String query = '';
  List<String> searchResults = [];
  List<String> recentSearches = [
    'Headphones',
    'Laptop',
    'Smart Watch',
    'iPhone'
  ];

  // Track filter visibility separately since it's in a different state
  bool isFilterVisible = false;

  SearchCubit() : super(SearchCubitInitial()) {
    textController.addListener(onTextChanged);
  }

  void onTextChanged() {
    if (textController.text != query) {
      updateQuery(textController.text);
    }
  }

  void updateQuery(String newQuery) {
    query = newQuery;

    if (query.isEmpty) {
      searchResults = [];
      emit(SearchCubitEmpty());
      return;
    }

    emit(SearchCubitLoading());
    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        searchResults = [
          '$query - Product 1',
          '$query - Product 2',
          '$query - Product 3',
          '$query - Category',
        ];

        if (searchResults.isEmpty) {
          emit(SearchCubitEmpty());
        } else {
          emit(SearchCubitSuccess());
        }
      } catch (e) {
        emit(SearchCubitError(message: e.toString()));
      }
    });
  }

  void saveRecentSearch(String searchQuery) {
    if (searchQuery.isEmpty) return;
    recentSearches.remove(searchQuery);
    recentSearches.insert(0, searchQuery);
    if (recentSearches.length > 5) {
      recentSearches.removeRange(5, recentSearches.length);
    }
  }

  void clearSearch() {
    textController.clear();
    query = '';
    searchResults = [];
    emit(SearchCubitEmpty());
  }

  void selectRecentSearch(String searchQuery) {
    textController.text = searchQuery;
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: searchQuery.length),
    );
    updateQuery(searchQuery);
  }

  void toggleFilterVisibility() {
    isFilterVisible = !isFilterVisible;
    emit(SearchCubitToggleFilter(isFilterVisible));
    if (query.isEmpty) {
      emit(SearchCubitEmpty());
    } else if (searchResults.isEmpty) {
      emit(SearchCubitEmpty());
    } else {
      emit(SearchCubitSuccess());
    }
  }

  @override
  Future<void> close() {
    textController.removeListener(onTextChanged);
    textController.dispose();
    return super.close();
  }
}
