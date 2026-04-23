import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'my_text.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final String? title;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  // Dropdown mode — when provided, renders a custom styled dropdown instead.
  final List<String>? dropdownItems;
  final String? dropdownValue;
  final ValueChanged<String?>? onDropdownChanged;

  const MyTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.labelText,
    this.title,
    this.onChanged,
    this.validator,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscure;
  }

  bool get _isDropdown => widget.dropdownItems != null;

  @override
  Widget build(BuildContext context) {
    if (widget.title != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            widget.title!,
            font: AppFont.inter,
            size: AppSizes.body,
            color: AppColors.white,
            weight: FontWeight.w600,
          ),
          const SizedBox(height: 6),
          _isDropdown ? _buildDropdown() : _buildField(),
        ],
      );
    }
    return _isDropdown ? _buildDropdown() : _buildField();
  }

  InputDecoration get _baseDecoration => InputDecoration(
    hintText: widget.hintText,
    hintStyle: const TextStyle(color: AppColors.textHint),
    labelText: widget.labelText,
    labelStyle: const TextStyle(color: AppColors.textHint),
    filled: true,
    fillColor: Colors.transparent,
    prefixIcon: widget.prefixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      borderSide: BorderSide(color: AppColors.textHint.withValues(alpha: 0.4)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      borderSide: BorderSide(color: AppColors.infoDim.withValues(alpha: 0.4)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
  );

  Widget _buildField() {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscured,
      onChanged: widget.onChanged,
      validator: widget.validator,
      style: const TextStyle(
        color: AppColors.white,
        fontFamily: 'Inter',
        fontSize: AppSizes.body,
      ),
      decoration: _baseDecoration.copyWith(
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(
                  _obscured ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textHint,
                  size: AppSizes.iconMd,
                ),
                onPressed: () => setState(() => _obscured = !_obscured),
              )
            : widget.suffixIcon,
      ),
    );
  }

  Widget _buildDropdown() {
    return _CustomDropdown(
      items: widget.dropdownItems!,
      value: widget.dropdownValue,
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon,
      onChanged: widget.onDropdownChanged,
      validator: widget.validator,
      baseDecoration: _baseDecoration,
    );
  }
}

// ---------------------------------------------------------------------------
// Custom dropdown — renders a FormField that shows a styled overlay popup
// with a primary-colored border, matching the app's dark card color.
// ---------------------------------------------------------------------------
class _CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String? value;
  final String hintText;
  final Widget? prefixIcon;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;
  final InputDecoration baseDecoration;

  const _CustomDropdown({
    required this.items,
    required this.value,
    required this.hintText,
    required this.prefixIcon,
    required this.onChanged,
    required this.validator,
    required this.baseDecoration,
  });

  @override
  State<_CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<_CustomDropdown> {
  final _layerLink = LayerLink();
  OverlayEntry? _overlay;
  String? _selected;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
  }

  @override
  void didUpdateWidget(_CustomDropdown old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) _selected = widget.value;
  }

  void _toggle() => _isOpen ? _close() : _open();

  void _open() {
    final box = context.findRenderObject() as RenderBox;
    final size = box.size;
    final popupHeight = widget.items.length * 52.0;
    const titleHeight = 28.0;
    final fieldTop = titleHeight;
    final fieldCenter = fieldTop + 56.0 / 2;
    final verticalOffset = fieldCenter - popupHeight / 2;

    _overlay = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _close,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, verticalOffset),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1820),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(color: AppColors.primary, width: 1.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: () {
                      final tiles = <Widget>[];
                      for (int i = 0; i < widget.items.length; i++) {
                        final item = widget.items[i];
                        final isSelected = item == _selected;
                        tiles.add(
                          GestureDetector(
                            onTap: () {
                              setState(() => _selected = item);
                              widget.onChanged?.call(item);
                              _close();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.15)
                                    : Colors.transparent,
                              ),
                              child: MyText(
                                item,
                                font: AppFont.inter,
                                size: AppSizes.body,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.white,
                                weight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                        if (i < widget.items.length - 1) {
                          tiles.add(
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.primary.withValues(alpha: 0.25),
                            ),
                          );
                        }
                      }
                      return tiles;
                    }(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlay!);
    setState(() => _isOpen = true);
  }

  void _close() {
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  void dispose() {
    _overlay?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: _selected,
      validator: (_) => widget.validator?.call(_selected),
      builder: (field) {
        final hasError = field.hasError;
        return CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggle,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(
                      color: hasError
                          ? AppColors.error
                          : _isOpen
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.5),
                      width: _isOpen ? 2 : 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (widget.prefixIcon != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: widget.prefixIcon!,
                        ),
                      Expanded(
                        child: MyText(
                          _selected ?? widget.hintText,
                          font: AppFont.inter,
                          size: AppSizes.body,
                          color: _selected != null
                              ? AppColors.white
                              : AppColors.textHint,
                          weight: _selected != null
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: AnimatedRotation(
                          turns: _isOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: MyText(
                      field.errorText!,
                      font: AppFont.inter,
                      size: AppSizes.caption,
                      color: AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
