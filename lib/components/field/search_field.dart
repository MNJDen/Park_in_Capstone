import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:searchfield/searchfield.dart';

class PRKSearchField extends StatefulWidget {
  final IconData prefixIcon;
  final String labelText;
  final List<SearchFieldListItem> searchFieldListItems;
  final TextEditingController controller;
  final Function(String) onTap;

  const PRKSearchField({
    required this.prefixIcon,
    required this.labelText,
    required this.searchFieldListItems,
    required this.controller,
    required this.onTap,
  });

  @override
  State<PRKSearchField> createState() => _PRKSearchFieldState();
}

class _PRKSearchFieldState extends State<PRKSearchField> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _handleSuggestionTap(SearchFieldListItem<dynamic> item) {
    final suggestionText = item.toString();
    widget.onTap(suggestionText);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: whiteColor,
      child: SearchField(
        focusNode: _focusNode,
        searchInputDecoration: InputDecoration(
          filled: true,
          fillColor: whiteColor,
          prefixIcon: Icon(
            size: 20,
            widget.prefixIcon,
            color: _isFocused ? blueColor : blackColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 1.w,
              color: blueColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 0.1.w,
              color: borderBlack,
            ),
          ),
          labelText: widget.labelText,
          labelStyle: TextStyle(
            fontSize: 12.r,
            color: _isFocused ? blueColor : blackColor,
          ),
        ),
        suggestionStyle: TextStyle(
          backgroundColor: whiteColor,
          fontSize: 12.r,
          color: blackColor,
          overflow: TextOverflow.fade,
        ),
        suggestionsDecoration: SuggestionDecoration(
          elevation: 15,
          color: whiteColor,
          selectionColor: blueColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        searchStyle: TextStyle(
          fontSize: 12.r,
          color: blackColor,
        ),
        scrollbarDecoration: ScrollbarDecoration(
          thumbColor: blueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        offset: const Offset(0, 50),
        controller: widget.controller,
        suggestions: widget.searchFieldListItems,
        // maxSuggestionsInViewPort: 5,
        dynamicHeight: true,
        // itemHeight: 60,
        maxSuggestionBoxHeight: 185.h,
        textCapitalization: TextCapitalization.sentences,
        onSuggestionTap: (item) {
          _handleSuggestionTap(item); // Handle suggestion tap
        },
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
