import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DropDownSearchField extends StatefulWidget {
  const DropDownSearchField({
    super.key,
    required this.items,
    required this.controller,
    required this.itemBuilder,
    this.textFormFieldvalidator,
    this.textFormFieldDecoration,
    required this.onSelected,
    this.textFormFieldstyle,
    this.onTap,
    this.menuHeight,
    this.onChanged,
    this.menuBgColor,
    this.errorWidget,
    this.menuDecoration,
    this.textFormscrollPadding,
    this.enabled = true,
    this.focusNode,
    this.textMode = true,
    this.keyboardType,
    this.openDropdownOnTap = true,
  });
  final TextEditingController controller;
  final String? Function(String?)? textFormFieldvalidator;
  final InputDecoration? textFormFieldDecoration;
  final List<String?> items;
  final Widget Function(BuildContext, String) itemBuilder;
  final void Function(String) onSelected;
  final TextStyle? textFormFieldstyle;
  final void Function()? onTap;
  final double? menuHeight;
  final void Function(String)? onChanged;
  final Color? menuBgColor;
  final Widget? errorWidget;
  final BoxDecoration? menuDecoration;
  final EdgeInsets? textFormscrollPadding;
  final bool enabled;
  final FocusNode? focusNode;
  final bool textMode;
  final TextInputType? keyboardType;
  final bool openDropdownOnTap;

  @override
  State<DropDownSearchField> createState() => _DropDownSearchFieldState();
}

class _DropDownSearchFieldState extends State<DropDownSearchField> {
  List<String> _items = [];
  List<String> _filteredItems = [];
  bool _isTapped = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _items = widget.items.whereType<String>().toList();
  }

  @override
  void didUpdateWidget(covariant DropDownSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Items listesi değiştiğinde items'ı güncelle
    if (!listEquals(oldWidget.items, widget.items)) {
      _items = widget.items.whereType<String>().toList();

      // Dropdown açıksa filtreleri de güncelle
      if (_isTapped) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _filterItems(widget.controller.text);
          }
        });
      }
    }
  }

  void _filterItems(String searchText) {
    if (!mounted) return;

    final normalizedSearchText = searchText.toLowerCase();
    setState(() {
      _items = widget.items.whereType<String>().toList();
      if (normalizedSearchText.isEmpty) {
        _filteredItems = _items;
      } else {
        _filteredItems = _items.where((element) => element.toLowerCase().contains(normalizedSearchText)).toList();
      }
    });

    if (mounted && _isTapped) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateOverlay();
        }
      });
    }
  }

  void _updateOverlay() {
    if (_overlayEntry != null && mounted) {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
      _overlayEntry = null;
      if (mounted) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
      }
    }
  }

  void _toggleDropdown() {
    if (_isTapped) {
      _closeDropdown();
      return;
    }

    setState(() => _isTapped = true);
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    if (mounted && _isTapped) {
      setState(() => _isTapped = false);
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject();
    if (renderBox == null || !mounted) {
      // Added: Null check
      return OverlayEntry(builder: (_) => const SizedBox.shrink());
    }

    final size = (renderBox as RenderBox).size;
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              _closeDropdown();
            },
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 3),
            child: SizedBox(
              width: size.width,
              child: Material(
                child: Container(
                  decoration: widget.menuDecoration ?? BoxDecoration(color: widget.menuBgColor ?? Colors.white),
                  child: LayoutBuilder(
                    builder: (context, constraints) => ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: widget.menuHeight ?? 200,
                        minWidth: constraints.maxWidth,
                      ),
                      child: _filteredItems.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: _filteredItems.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                return InkWell(
                                  onTap: () {
                                    _closeDropdown();
                                    widget.controller.text = item;
                                    widget.onSelected(item);
                                  },
                                  child: widget.itemBuilder(context, item),
                                );
                              },
                            )
                          : widget.errorWidget ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    if (widget.focusNode == null) {
      // Only dispose if we created it
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        enabled: widget.enabled,
        scrollPadding: widget.textFormscrollPadding ?? const EdgeInsets.all(0),
        controller: widget.controller,
        onTap: () {
          widget.onTap?.call();
          if (widget.openDropdownOnTap) {
            _toggleDropdown();
            if (widget.textMode) {
              _filterItems(widget.controller.text);
            }
          }
        },
        focusNode: _focusNode,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        keyboardType: widget.keyboardType,
        style: widget.textFormFieldstyle,
        validator: widget.textFormFieldvalidator,
        decoration:
            widget.textFormFieldDecoration ??
            InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'common.search'.tr(),
              suffixIcon: const Icon(Icons.search),
            ),
        onChanged: (value) {
          widget.onChanged?.call(value);
          if (widget.textMode) {
            _filterItems(value);
          }
        },
      ),
    );
  }
}
