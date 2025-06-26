import 'package:flutter/material.dart';

class BookingItem {
  final int id; // Add this property
  final String name;
  final String service;
  final String time;
  final String date;
  final String status;
  final Color color;
  final String initial;

  BookingItem({
    required this.id, // Add this parameter
    required this.name,
    required this.service,
    required this.time,
    required this.date,
    required this.status,
    required this.color,
    required this.initial,
  });
}