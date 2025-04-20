import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/features/profile/data/car_model.dart';
import 'package:flutter/material.dart';

class CarItemWidget extends StatefulWidget {
  final Car car;

  const CarItemWidget({super.key, required this.car});

  @override
  _CarItemWidgetState createState() => _CarItemWidgetState();
}

class _CarItemWidgetState extends State<CarItemWidget> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.white100_1,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    widget.car.assetImage,
                    width: double.infinity,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 8),
                child: CircleAvatar(
                  backgroundColor: context.theme.white100_1,
                  radius: 20,
                  child: IconButton(
                    iconSize: 13,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? context.theme.red100_1
                          : context.theme.blue100_1,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CustomIcon(
                          hight: 12,
                          width: 12,
                          flag: false,
                          imageIcon: AppAssets.assetsIconsStar,
                        ),
                        Text(" ${widget.car.rating.toString()}",
                            style: AppStyles.semiBold12(context)),
                      ],
                    ),
                    Row(children: [
                      const CustomIcon(
                        hight: 12,
                        width: 12,
                        flag: false,
                        imageIcon: AppAssets.assetsIconsMap,
                      ),
                      Text(
                        " ${widget.car.distance} km",
                        style: AppStyles.bold12(context)
                            .copyWith(color: Colors.grey),
                      ),
                    ]),
                  ],
                ),
                Text(widget.car.name, style: AppStyles.semiBold24(context)),
                Row(
                  children: [
                    Text(
                      "\$${widget.car.pricePerHour}",
                      style: AppStyles.regular24(context)
                          .copyWith(color: context.theme.blue100_2),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "/hr",
                        style: AppStyles.regular12(context)
                            .copyWith(color: context.theme.blue100_2),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.theme.white100_1,
                        foregroundColor: context.theme.blue100_2,
                        elevation: 2,
                        fixedSize: const Size(60, 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: context.theme.blue100_2,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                      ),
                      child: Text(
                        "Show more",
                        style: AppStyles.regular12(context).copyWith(
                          color: context.theme.blue100_2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
