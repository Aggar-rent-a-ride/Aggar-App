import 'package:aggar/features/rent_history/data/models/rent_history_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class RentalHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RentalHistoryInitial extends RentalHistoryState {}

class RentalHistoryLoading extends RentalHistoryState {}

class RentalHistoryLoaded extends RentalHistoryState {
  final List<RentalHistoryItem> rentals;
  final int currentPage;
  final bool hasMoreData;

  RentalHistoryLoaded({
    required this.rentals,
    required this.currentPage,
    required this.hasMoreData,
  });

  @override
  List<Object?> get props => [rentals, currentPage, hasMoreData];
}

class RentalHistoryError extends RentalHistoryState {
  final String message;

  RentalHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
