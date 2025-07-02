import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/search_text_field.dart'
    show SearchTextField;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart' show AppStyles;
import '../../data/model/dropbown_button.dart';

class InputNameWithDropDownList extends StatefulWidget {
  const InputNameWithDropDownList({
    super.key,
    required this.hintTextSearch,
    required this.lableText,
    required this.hintText,
    this.width,
    required this.items,
    required this.ids,
    this.flag = false,
    this.onSaved,
    this.validator,
    this.controller,
    this.initialValue,
    this.onValueChanged,
  });

  final String hintTextSearch;
  final String lableText;
  final String hintText;
  final double? width;
  final List<String> items;
  final List<int> ids;
  final bool? flag;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? initialValue;
  final void Function(String value, int id)? onValueChanged;

  @override
  State<InputNameWithDropDownList> createState() =>
      _InputNameWithDropDownListState();
}

class _InputNameWithDropDownListState extends State<InputNameWithDropDownList> {
  String? selectedValue;
  late final TextEditingController textEditingController;
  late final TextEditingController dropdownController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    dropdownController = widget.controller ?? TextEditingController();

    if (widget.initialValue != null) {
      if (widget.items == vehicleStatus) {
        if (widget.items.contains(widget.initialValue)) {
          selectedValue = widget.initialValue;
          dropdownController.text = widget.initialValue!;
        }
      } else {
        int index = widget.items.indexOf(widget.initialValue!);
        if (index != -1 && index < widget.ids.length) {
          selectedValue = widget.ids[index].toString();
          dropdownController.text = widget.initialValue!;
        }
      }
    } else if (widget.items == vehicleStatus) {
      int activeIndex = widget.items.indexOf("active");
      if (activeIndex != -1) {
        selectedValue = widget.items[activeIndex];
        dropdownController.text = widget.items[activeIndex];
      } else {
        selectedValue = null;
        dropdownController.text = '';
      }
    } else {
      selectedValue = null;
      dropdownController.text = '';
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    if (widget.controller == null) {
      dropdownController.dispose();
    }
    super.dispose();
  }

  TextStyle getItemTextStyle(
      BuildContext context, String item, String? selectedItem) {
    if (item == selectedItem) {
      if (item == "active") {
        return AppStyles.medium15(context).copyWith(
          color: context.theme.green100_1,
        );
      } else if (item == "out of stock") {
        return AppStyles.medium15(context).copyWith(
          color: context.theme.red100_1,
        );
      }
      return AppStyles.medium15(context).copyWith(
        color: context.theme.black100,
      );
    }
    return AppStyles.medium15(context).copyWith(
      color: context.theme.black100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      onSaved: widget.onSaved,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lableText,
              style: AppStyles.medium18(context).copyWith(
                color: context.theme.blue100_1,
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  widget.hintText,
                  style: AppStyles.medium15(context).copyWith(
                    color: context.theme.black50,
                  ),
                ),
                items: List.generate(
                  widget.items.length,
                  (index) => DropdownMenuItem(
                    value: widget.items == vehicleStatus
                        ? widget.items[index]
                        : widget.ids[index].toString(),
                    child: Text(
                      widget.items[index],
                      style: getItemTextStyle(context, widget.items[index],
                          dropdownController.text),
                    ),
                  ),
                ),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;

                    if (widget.items == vehicleStatus) {
                      dropdownController.text = value ?? '';
                      state.didChange(value);
                    } else {
                      int idValue = int.parse(value ?? '0');
                      int index = widget.ids.indexOf(idValue);
                      if (index != -1) {
                        dropdownController.text = widget.items[index];
                        state.didChange(value);
                        widget.onValueChanged
                            ?.call(widget.items[index], idValue);
                      }
                    }
                  });
                },
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(color: context.theme.white100_1),
                  maxHeight: 200,
                ),
                buttonStyleData: ButtonStyleData(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width:
                      widget.width ?? MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: context.theme.white100_1,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: state.hasError
                          ? context.theme.red100_1
                          : context.theme.black50,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                dropdownSearchData: widget.flag == true
                    ? DropdownSearchData(
                        searchController: textEditingController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          color: context.theme.white100_1,
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: SearchTextField(
                            hintText: widget.hintTextSearch,
                            textEditingController: textEditingController,
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          if (widget.items == vehicleStatus) {
                            return item.value.toString().contains(searchValue);
                          }
                          int index = widget.ids.indexWhere(
                            (id) => id.toString() == item.value,
                          );
                          return widget.items[index]
                              .toLowerCase()
                              .contains(searchValue.toLowerCase());
                        },
                      )
                    : const DropdownSearchData(),
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 12.0),
                child: Text(
                  state.errorText!,
                  style: AppStyles.regular14(context).copyWith(
                    color: context.theme.red100_1,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
