import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/images/user_image.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:provider/provider.dart';

class ChatInput extends StatefulWidget {
  final Function(String, File) onSubmitted;
  // final Function() onFocus;

  const ChatInput({
    Key key,
    @required this.onSubmitted,
    // @required this.onFocus,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> with TickerProviderStateMixin {
  TextEditingController editingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool get isTexting => editingController.text.length != 0;
  File _image;

  @override
  void initState() {
    super.initState();
    editingController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    // focusNode.addListener(() {
    //   print("Has focus: ${focusNode.hasFocus}");
    //   widget.onFocus();
    // });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);

    return Container(
      color: ConstantColors.PRIMARY.withOpacity(0.90),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 1.0,
          bottom: 10.0,
          left: 15.0,
          right: 15.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 6.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    print('Attachment pressed');
                    await getImage();
                    // setState(() {
                    //   _hasImage = _image == null;
                    // });
                  },
                  child: Image.asset(
                    'assets/images/attachment-button.png',
                    height: 25.0,
                    width: 25.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 50),
                vsync: this,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(
                      color: ConstantColors.UNDERLINE,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      _image == null
                          ? Container()
                          : Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 8.0,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.file(
                                        _image,
                                        width: 140.0,
                                      ),
                                      Positioned(
                                        left: 115.0,
                                        top: 5.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _image = null;
                                            });
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Icon(
                                                Icons.cancel,
                                                color: Colors.grey[600],
                                                size: 20.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      _image == null ? Container() : Underline(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 0.0,
                                horizontal: 12.0,
                              ),
                              child: TextField(
                                focusNode: focusNode,
                                // textInputAction: TextInputAction.send,
                                controller: editingController,
                                onSubmitted: sendMessage,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'SF Pro Text',
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: _image == null
                                      ? 'Write a message...'
                                      : 'Add a comment or Send',
                                  hintStyle: TextStyle(
                                    color: ConstantColors.CHAT_TIMESTAMP,
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 6.0,
                                bottom: 5.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (_image != null) {}
                                  sendMessage(editingController.text);
                                },
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Image.asset(
                                    'assets/images/send-button.png',
                                    height: 25.0,
                                    width: 25.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage(String text) {
    if (!isTexting && _image == null) {
      return;
    }

    if (_image != null) {
      widget.onSubmitted('', _image);
      setState(() {
        _image = null;
      });
    }

    if (text != null && text != '') {
      widget.onSubmitted(text, _image);
      editingController.text = '';
    }

    // focusNode.unfocus();
  }
}
