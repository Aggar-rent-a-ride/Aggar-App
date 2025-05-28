import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    super.key,
    required this.vehicleId,
    required this.isFavorite,
    required this.token,
  });

  final String vehicleId;
  final bool isFavorite;
  final String token;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        return Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(50),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.grey[600],
              size: 20,
            ),
            onPressed: () async {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              await context
                  .read<VehicleCubit>()
                  .toggleFavorite(widget.token, widget.vehicleId, !_isFavorite);
            },
          ),
        );
      },
    );
  }
}
