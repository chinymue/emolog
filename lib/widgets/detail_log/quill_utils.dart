import 'dart:convert'; // Để dùng jsonDecode
import 'package:emolog/l10n/app_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart'
    as quill; // Để dùng quill.Document
import 'package:flutter/material.dart';
import '../../utils/constant.dart';

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

String jsonFromDoc(quill.Document doc) {
  try {
    return jsonEncode(doc.toDelta().toJson());
  } catch (_) {
    return '';
  }
}

quill.Document docFromJson(String? deltaJson) {
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
  final String? initialContent;
  final void Function(String doc) onContentChanged;

  const DefaultQuillEditor({
    super.key,
    this.initialContent,
    required this.onContentChanged,
  });

  @override
  State<DefaultQuillEditor> createState() => _DefaultQuillEditorState();
}

class _DefaultQuillEditorState extends State<DefaultQuillEditor> {
  bool _showToolbar = true;
  bool _useFullToolbar = false;

  late final quill.QuillController _controller;

  @override
  void initState() {
    super.initState();
    final doc = docFromJson(widget.initialContent);
    _controller = quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );

    _controller.addListener(() {
      widget.onContentChanged(jsonFromDoc(_controller.document));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              tooltip: _showToolbar ? l10n.toolbarShow : l10n.toolbarHidden,
              onPressed: () => setState(() => _showToolbar = !_showToolbar),
            ),
          ],
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.all(kPaddingLarge),
            child: quill.QuillEditor.basic(
              controller: _controller,
              config: quill.QuillEditorConfig(
                placeholder: l10n.logPlaceHolderNeutral,
              ),
            ),
          ),
        ),
        if (_showToolbar)
          SizedBox(
            height: kToolbarHeight,
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _useFullToolbar
                        ? quill.QuillSimpleToolbar(controller: _controller)
                        : quill.QuillSimpleToolbar(
                            controller: _controller,
                            config: buildToolbarConfig(
                              includeButtons: [...textFormattingButtons],
                            ),
                          ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _useFullToolbar
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                  tooltip: _useFullToolbar
                      ? l10n.toolbarBasic
                      : l10n.toolbarFull,
                  onPressed: () => setState(() {
                    _useFullToolbar = !_useFullToolbar;
                    _showToolbar = true;
                  }),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
