import 'package:lastspot_app/core/base_import.dart';

class SelectionBottomSheet<T> extends StatefulWidget {
  final String title;
  final String searchHint;
  final List<T> items;
  final String Function(T) itemText;
  final bool Function(T, String) onSearch;
  final T? selectedItem;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final String? emptyMessage;
  final VoidCallback? onRetry;
  final Widget Function(T)? leadingIcon;

  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.searchHint,
    required this.items,
    required this.itemText,
    required this.onSearch,
    this.selectedItem,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.emptyMessage,
    this.onRetry,
    this.leadingIcon,
  });

  static bool _isSheetOpen = false;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String searchHint,
    required List<T> items,
    required String Function(T) itemText,
    required bool Function(T, String) onSearch,
    T? selectedItem,
    bool isLoading = false,
    bool hasError = false,
    String? errorMessage,
    String? emptyMessage,
    VoidCallback? onRetry,
    Widget Function(T)? leadingIcon,
  }) async {
    if (_isSheetOpen) return null;
    _isSheetOpen = true;
    try {
      return await showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        backgroundColor: context.surfaceColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.r24),
          ),
        ),
        builder: (context) => SelectionBottomSheet<T>(
          title: title,
          searchHint: searchHint,
          items: items,
          itemText: itemText,
          onSearch: onSearch,
          selectedItem: selectedItem,
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          emptyMessage: emptyMessage,
          onRetry: onRetry,
          leadingIcon: leadingIcon,
        ),
      );
    } finally {
      _isSheetOpen = false;
    }
  }

  @override
  State<SelectionBottomSheet<T>> createState() =>
      _SelectionBottomSheetState<T>();
}

class _SelectionBottomSheetState<T> extends State<SelectionBottomSheet<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(Dimensions.r16.dynamicW),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: Dimensions.r48.dynamicW,
            height: Dimensions.r4.dynamicH,
            decoration: BoxDecoration(
              color: context.dividerColor,
              borderRadius: BorderRadius.circular(Dimensions.r2.dynamicR),
            ),
          ),
          SizedBox(height: Dimensions.r16.dynamicH),

          // Title and Done button (optional)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: Dimensions.r20.dynamicSP,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: context.textSecondary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: Dimensions.r16.dynamicH),

          // Search Field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: widget.searchHint,
              prefixIcon: Icon(Icons.search, color: context.textSecondary),
              filled: true,
              fillColor: context.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: Dimensions.r16.dynamicW,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
          SizedBox(height: Dimensions.r16.dynamicH),

          // Content
          Expanded(child: _buildContent(context)),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor),
      );
    }

    if (widget.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 48, color: context.textSecondary),
            SizedBox(height: Dimensions.r16.dynamicH),
            Text(
              widget.errorMessage ?? context.loc.noInternetError,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.textSecondary),
            ),
            SizedBox(height: Dimensions.r16.dynamicH),
            if (widget.onRetry != null)
              AppButton(
                label: context.loc.retry,
                onPressed: widget.onRetry!,
                isFullWidth: false,
              ),
          ],
        ),
      );
    }

    final filteredItems = widget.items
        .where((item) => widget.onSearch(item, _searchQuery))
        .toList();

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: context.textSecondary),
            SizedBox(height: Dimensions.r16.dynamicH),
            Text(
              widget.emptyMessage ?? 'No items found',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final isSelected = widget.selectedItem == item;

        return Padding(
          padding: EdgeInsets.only(bottom: Dimensions.r8.dynamicH),
          child: Material(
            color: isSelected
                ? context.primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: widget.leadingIcon != null
                  ? widget.leadingIcon!(item)
                  : null,
              title: Text(
                widget.itemText(item),
                style: TextStyle(
                  color: isSelected
                      ? context.primaryColor
                      : context.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check_circle, color: context.primaryColor)
                  : const SizedBox.shrink(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
              ),
              onTap: () {
                Navigator.of(context).pop(item);
              },
            ),
          ),
        );
      },
    );
  }
}
