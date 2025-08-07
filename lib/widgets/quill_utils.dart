import 'dart:convert'; // Để dùng jsonDecode
import 'package:flutter_quill/flutter_quill.dart'
    as quill; // Để dùng quill.Document
import 'package:flutter/material.dart';
import '../utils/constant.dart';

/// === CONSTANTS ===

const textFormattingButtons = [
  'bold',
  'italic',
  'underline',
  'strike',
  'clear',
];

const fontAndColorButtons = ['fontFamily', 'fontSize', 'color', 'background'];

const layoutButtons = ['align', 'header', 'indent', 'direction'];

const blockButtons = ['code', 'quote'];

const listButtons = ['bullets', 'numbers'];

const actionButtons = ['undo', 'redo', 'link', 'search'];

/// === QUILL UTILS ===

// Data type ------------------------------------------------------------
String deltaToPlainText(String deltaJson) {
  try {
    final doc = quill.Document.fromJson(jsonDecode(deltaJson));
    return doc.toPlainText().trim();
  } catch (_) {
    return '';
  }
}

String plainTextToDelta(quill.Document doc) {
  try {
    return jsonEncode(doc.toDelta().toJson());
  } catch (_) {
    return '';
  }
}

quill.Document documentFromJsonOrEmpty(String? deltaJson) {
  try {
    if (deltaJson?.isNotEmpty ?? false) {
      return quill.Document.fromJson(jsonDecode(deltaJson!));
    }
  } catch (_) {}
  return quill.Document();
}

// config stuff --------------------------------------------------------------

// config quill simple toolbar nhanh với các nút hiển thị / không hiển thị (không điền cả hai list cùng lúc)
quill.QuillSimpleToolbarConfig buildToolbarConfig({
  List<String>? includeButtons,
  List<String>? excludeButtons,
}) {
  // Nếu có include thì ưu tiên include
  bool isVisible(String key) {
    if (includeButtons != null) {
      return includeButtons.contains(key);
    } else if (excludeButtons != null) {
      return !excludeButtons.contains(key);
    }
    // Nếu không có cả hai thì mặc định hiển thị hết
    return true;
  }

  return quill.QuillSimpleToolbarConfig(
    showFontFamily: isVisible('fontFamily'),
    showFontSize: isVisible('fontSize'),
    showColorButton: isVisible('color'),
    showBackgroundColorButton: isVisible('background'),
    showBoldButton: isVisible('bold'),
    showItalicButton: isVisible('italic'),
    showUnderLineButton: isVisible('underline'),
    showStrikeThrough: isVisible('strike'),
    showAlignmentButtons: isVisible('align'),
    showCodeBlock: isVisible('code'),
    showListBullets: isVisible('bullets'),
    showListNumbers: isVisible('numbers'),
    showUndo: isVisible('undo'),
    showRedo: isVisible('redo'),
    showClearFormat: isVisible('clear'),
    showDirection: isVisible('direction'),
    showHeaderStyle: isVisible('header'),
    showIndent: isVisible('indent'),
    showLink: isVisible('link'),
    showQuote: isVisible('quote'),
    showSearchButton: isVisible('search'),
  );
}

/// === WIDGETS ===

// Quill editor widget
class DefaultQuillEditor extends StatefulWidget {
  final quill.QuillController controller;
  final double padding;
  final String? hintText;

  const DefaultQuillEditor({
    super.key,
    required this.controller,
    this.padding = kPadding,
    this.hintText,
  });

  @override
  State<DefaultQuillEditor> createState() => _DefaultQuillEditorState();
}

class _DefaultQuillEditorState extends State<DefaultQuillEditor> {
  bool _showToolbar = true;
  bool _useFullToolbar = false;

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toggle controls
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                _showToolbar ? Icons.visibility_off : Icons.visibility,
              ),
              tooltip: _showToolbar ? 'Ẩn toolbar' : 'Hiện toolbar',
              onPressed: () => setState(() => _showToolbar = !_showToolbar),
            ),
            IconButton(
              icon: Icon(
                _useFullToolbar ? Icons.fullscreen_exit : Icons.fullscreen,
              ),
              tooltip: _useFullToolbar
                  ? 'Dùng toolbar đơn giản'
                  : 'Dùng toolbar đầy đủ',
              onPressed: () => setState(() {
                _useFullToolbar = !_useFullToolbar;
                _showToolbar = true;
              }),
            ),
          ],
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.all(widget.padding),
            child: quill.QuillEditor.basic(
              controller: widget.controller,
              focusNode: _focusNode,
              config: quill.QuillEditorConfig(
                // autoFocus: true,
                placeholder: widget.hintText ?? '',
              ),
            ),
          ),
        ),
        if (_showToolbar)
          _useFullToolbar
              ? quill.QuillSimpleToolbar(controller: widget.controller)
              : quill.QuillSimpleToolbar(
                  controller: widget.controller,
                  config: buildToolbarConfig(
                    includeButtons: [...textFormattingButtons],
                  ),
                ),
      ],
    );
  }
}
