import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_icon.dart';

class PickImageIconWithTitleAndSubtitle extends StatefulWidget {
  final Function(String)? onImageSelected;
  final String? selectedImagePath;

  const PickImageIconWithTitleAndSubtitle({
    super.key,
    this.onImageSelected,
    this.selectedImagePath,
  });

  @override
  State<PickImageIconWithTitleAndSubtitle> createState() =>
      _PickImageIconWithTitleAndSubtitleState();
}

class _PickImageIconWithTitleAndSubtitleState
    extends State<PickImageIconWithTitleAndSubtitle> {
  String? _localImagePath;

  @override
  void initState() {
    super.initState();
    _localImagePath = widget.selectedImagePath;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _localImagePath = image.path;
        });

        if (widget.onImageSelected != null) {
          widget.onImageSelected!(image.path);
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: () => _showImagePickerOptions(context),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: AppLightColors.myBlue100_2,
                radius: 90,
                child: _localImagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: Image.file(
                          File(_localImagePath!),
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const CustomIcon(
                        hight: 80,
                        width: 80,
                        flag: false,
                        imageIcon: AppAssets.assetsIconsAddPhoto,
                      ),
              ),
              const SizedBox(height: 10),
              Text(
                _localImagePath != null
                    ? "Change profile photo"
                    : "Profile photo",
                style: AppStyles.semiBold24(context).copyWith(
                  color: AppLightColors.myBlue100_1,
                ),
              ),
              Text(
                "Please make sure that the photo you \n    upload will not be modified later",
                style: AppStyles.regular12(context).copyWith(
                  color: AppLightColors.myBlack50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
