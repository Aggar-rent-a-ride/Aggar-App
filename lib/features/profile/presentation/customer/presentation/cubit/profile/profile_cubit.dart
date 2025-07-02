import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../main_screen/customer/data/model/list_vehicle_model.dart';
import '../../../../../../main_screen/customer/data/model/vehicle_model.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  final DioConsumer dio = DioConsumer(dio: Dio());

  bool _isLoadingMore = false;
  int _pageFavorite = 1, _pageRenter = 1;
  int _totalPagesFavorite = 1, _totalPagesRenter = 1;

  final List<VehicleModel> _favoriteVehicles = [];
  final List<VehicleModel> _renterVehicles = [];

  List<VehicleModel> get favoriteVehicles =>
      List.unmodifiable(_favoriteVehicles);
  List<VehicleModel> get renterVehicles => List.unmodifiable(_renterVehicles);

  void _resetList<T>(List<T> list, int page, int totalPages) {
    list.clear();
    if (T == VehicleModel) {
      if (list == _favoriteVehicles) {
        _pageFavorite = page;
        _totalPagesFavorite = totalPages;
      } else if (list == _renterVehicles) {
        _pageRenter = page;
        _totalPagesRenter = totalPages;
      }
    }
  }

  Future<void> fetchFavoriteVehicles(String token,
      {bool isLoadMore = false}) async {
    if (isLoadMore && (_isLoadingMore || _pageFavorite >= _totalPagesFavorite))
      return;

    try {
      if (!isLoadMore) {
        emit(ProfileLoading());
        _resetList(_favoriteVehicles, 1, 1);
      } else {
        _isLoadingMore = true;
        emit(
          ProfileFavoriteVehicleLoadingMore(
            listVehicleModel: ListVehicleModel(
              data: _favoriteVehicles,
              totalPages: _totalPagesFavorite,
            ),
          ),
        );
      }

      final response = await dio.get(
        EndPoint.getFavouriteVehicles,
        queryParameters: {
          "pageNo": isLoadMore ? _pageFavorite + 1 : 1,
          "pageSize": 10
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final vehicles = ListVehicleModel.fromJson(response);
      if (isLoadMore) {
        _favoriteVehicles.addAll(vehicles.data);
      } else {
        _favoriteVehicles.clear();
        _favoriteVehicles.addAll(vehicles.data);
      }
      if (_favoriteVehicles.length > 50) {
        _favoriteVehicles.removeRange(0, _favoriteVehicles.length - 50);
      }

      _pageFavorite = isLoadMore ? _pageFavorite + 1 : 1;
      _totalPagesFavorite = vehicles.totalPages ?? 1;

      emit(ProfileGetFavoriteSuccess(
          listVehicleModel: ListVehicleModel(
              data: _favoriteVehicles, totalPages: _totalPagesFavorite)));
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> fetchRenterVehicles(String token,
      {bool isLoadMore = false}) async {
    if (isLoadMore && (_isLoadingMore || _pageRenter >= _totalPagesRenter))
      return;

    try {
      if (!isLoadMore) {
        emit(ProfileLoading());
        _resetList(_renterVehicles, 1, 1);
      } else {
        _isLoadingMore = true;
        emit(
          ProfileRenterVehicleLoadingMore(
            listVehicleModel: ListVehicleModel(
              data: _renterVehicles,
              totalPages: _totalPagesRenter,
            ),
          ),
        );
      }

      final response = await dio.get(
        EndPoint.getRenterVehicles,
        queryParameters: {
          "pageNo": isLoadMore ? _pageRenter + 1 : 1,
          "pageSize": 10
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final vehicles = ListVehicleModel.fromJson(response);
      if (isLoadMore) {
        _renterVehicles.addAll(vehicles.data);
      } else {
        _renterVehicles.clear();
        _renterVehicles.addAll(vehicles.data);
      }
      if (_renterVehicles.length > 50) {
        _renterVehicles.removeRange(0, _renterVehicles.length - 50);
      }

      _pageRenter = isLoadMore ? _pageRenter + 1 : 1;
      _totalPagesRenter = vehicles.totalPages ?? 1;
      print(_renterVehicles);
      emit(ProfileVehiclesSuccess(
          listVehicleModel: ListVehicleModel(
              data: _renterVehicles, totalPages: _totalPagesRenter)));
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }

  void loadMoreFavoriteVehicles(String token) =>
      fetchFavoriteVehicles(token, isLoadMore: true);
  void loadMoreRenterVehicles(String token) =>
      fetchRenterVehicles(token, isLoadMore: true);

  bool get canLoadMoreFavorite =>
      _pageFavorite < _totalPagesFavorite && !_isLoadingMore;
  bool get canLoadMoreRenter =>
      _pageRenter < _totalPagesRenter && !_isLoadingMore;
}
