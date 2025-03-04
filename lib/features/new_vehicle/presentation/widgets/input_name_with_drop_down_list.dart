import 'package:aggar/features/new_vehicle/presentation/widgets/search_text_field.dart'
    show SearchTextField;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart' show AppColors;
import '../../../../core/utils/app_styles.dart' show AppStyles;
import '../../data/model/dropbown_button.dart' show items;

class InputNameWithDropDownList extends StatefulWidget {
  const InputNameWithDropDownList(
      {super.key,
      required this.hintTextSearch,
      required this.lableText,
      required this.hintText,
      this.width});
  final String hintTextSearch;
  final String lableText;
  final String hintText;
  final double? width;

  @override
  State<InputNameWithDropDownList> createState() =>
      _InputNameWithDropDownListState();
}

class _InputNameWithDropDownListState extends State<InputNameWithDropDownList> {
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.lableText,
          style: AppStyles.medium18(context).copyWith(
            color: AppColors.myBlue100_1,
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              widget.hintText,
              style: AppStyles.medium15(context).copyWith(
                color: AppColors.myBlack50,
              ),
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: AppStyles.medium15(context).copyWith(
                        color: AppColors.myBlack50,
                      ),
                    ),
                  ),
                )
                .toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(color: AppColors.myWhite100_1),
              maxHeight: 200,
            ),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: widget.width ?? MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                color: AppColors.myWhite100_1,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: AppColors.myBlack25,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: textEditingController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                color: AppColors.myWhite100_1,
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: SearchTextField(
                    hintText: widget.hintTextSearch,
                    textEditingController: textEditingController),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value.toString().contains(searchValue);
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
          ),
        ),
      ],
    );
  }
}
