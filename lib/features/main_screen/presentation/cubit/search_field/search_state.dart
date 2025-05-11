abstract class SearchCubitState {}

class SearchCubitInitial extends SearchCubitState {}

class SearchCubitLoading extends SearchCubitState {
  SearchCubitLoading();
}

class SearchCubitToggleFilter extends SearchCubitState {
  bool isFilterVisable;
  SearchCubitToggleFilter(this.isFilterVisable);
}

class SearchCubitSuccess extends SearchCubitState {}

class SearchCubitEmpty extends SearchCubitState {}

class SearchCubitError extends SearchCubitState {
  final String message;

  SearchCubitError({required this.message});
}
