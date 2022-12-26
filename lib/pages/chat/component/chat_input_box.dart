import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/database/model/messages_table.dart';
import 'package:hnh_flutter/pages/chat/component/video_player_widget.dart';
import 'package:hnh_flutter/utils/controller.dart';
import 'package:hnh_flutter/view_models/chat_vm.dart';
import 'package:image_picker/image_picker.dart';

import '../../../custom_style/colors.dart';
import '../../../database/model/attachments_table.dart';
import '../../../voice_record_animation/audio_encoder_type.dart';
import '../../../voice_record_animation/screen/social_media_recorder.dart';
import 'camera_view.dart';

typedef onAttachmentMessageCallBack = void Function(dynamic);

class ChatInputBox extends StatefulWidget {
   ChatInputBox(
      {Key? key,
      required this.attachmentInsertedCallback,
      required this.onTextMessageSent,
      required this.item
      })
      : super(key: key);

  final onAttachmentMessageCallBack attachmentInsertedCallback;


  final ValueChanged<MessagesTable> onTextMessageSent;
  final CustomMessageObject item;

  @override
  _ChatInputBoxState createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends State<ChatInputBox> {
  var iconSendMsg = Icons.keyboard_voice;
  TextEditingController inputMessageBox = TextEditingController();
  bool isVoiceMessage = true;
  bool hideTextBoxView = false;
  bool showEmoji = false;
  bool isMine = true;
  FocusNode focusNode = FocusNode();
  ChatViewModel chatViewModel = ChatViewModel();

  List<String> menus = [
    "Document",
    "Camera",
    "Gallery",
    "Audio",
    "Location",
    "Contact"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          showEmoji = false;
        });
      }
    });
    inputMessageBox.addListener(msgInputBoxAction);
  }

  msgInputBoxAction() {
    if (inputMessageBox.text.isNotEmpty) {
      setState(() {
        iconSendMsg = Icons.send;
        isVoiceMessage = false;
      });
    } else {
      setState(() {
        iconSendMsg = Icons.mic;
        isVoiceMessage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return bottomBox();
  }

  Widget bottomBox() {
    return Container(
      margin: const EdgeInsets.all(3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              hideTextBoxView
                  ? const Center()
                  : Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35.0),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 1,
                              color: Colors.grey)
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                showEmoji ? Icons.keyboard : Icons.mood,
                                color: Colors.grey,
                              ),
                              onPressed: () => callEmoji()),
                          Expanded(
                            child: TextField(
                              focusNode: focusNode,
                              controller: inputMessageBox,
                              maxLines: 3,
                              minLines: 1,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                  hintText: "Message",
                                  hintStyle:
                                  TextStyle(color: Colors.grey),
                                  border: InputBorder.none),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.attach_file,
                                color: Colors.grey),
                            onPressed: () => callAttachFile(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo_camera,
                                color: Colors.grey),
                            onPressed: () => callCamera(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: primaryColor, shape: BoxShape.circle),
                      child: InkWell(
                        onTap: () {

                          sentMessage(ChatMessageType.text);
                        },
                        child: Icon(
                          iconSendMsg,
                          color: Colors.white,
                        ),
                      )),
                  const SizedBox(width: 5),
                ],
              ),
              isVoiceMessage
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      //padding: const EdgeInsets.only(top: 140, left: 4, right: 4),
                      padding: const EdgeInsets.only(
                          top: 7, left: 7, right: 7),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SocialMediaRecorder(
                          cancelText: "Cancel",
                          slideToCancelText: "Slide to cancel",
                          recordIconWhenLockBackGroundColor: primaryColor,

                          recordIcon: Container(
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle),
                              child: Icon(
                                iconSendMsg,
                                color: Colors.white,
                              )),
                          sendRequestFunction: (soundFile) {
                            setState(() {
                              hideTextBoxView = false;
                            });

                            sentMessage(ChatMessageType.audio, attachmentURl: soundFile.path);
                          },
                          encode: AudioEncoderType.AAC,
                          hideBottomView: (bool) {
                            setState(() {
                              hideTextBoxView = bool;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              )
                  : const Center(),
            ],
          ),
          showEmoji ? emojiContainer() : Container(),
        ],
      ),
    );
  }

  void callEmoji() {
    if (!showEmoji) {
      focusNode.unfocus();
      focusNode.canRequestFocus = false;
    }

    setState(() {
      showEmoji = !showEmoji;
    });
  }

  void callAttachFile() {

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (builder) => attachmentMenuBox());
    focusNode.unfocus();
  }

  void callCamera() {
    focusNode.unfocus();
    pickImageFile(ImageSource.camera, (value) {
      Get.to(() =>
          CameraViewPage(
            path: value.path,
            callBack: () {
              sentMessage(
                  ChatMessageType.image, attachmentURl: value.path);
            },
          ));
    });
  }



  Widget emojiContainer() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        textEditingController: inputMessageBox,
        // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
        config: Config(
          columns: 7,
          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
          // Issue: https://github.com/flutter/flutter/issues/28894
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          initCategory: Category.RECENT,
          bgColor: Color(0xFFF2F2F2),
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          iconColorSelected: Colors.blue,
          backspaceColor: Colors.blue,
          skinToneDialogBgColor: Colors.white,
          skinToneIndicatorColor: Colors.grey,
          enableSkinTones: true,
          showRecentsTab: true,
          recentsLimit: 28,
          noRecents: const Text(
            'No Recents',
            style: TextStyle(fontSize: 20, color: Colors.black26),
            textAlign: TextAlign.center,
          ),
          // Needs to be const Widget
          loadingIndicator: const SizedBox.shrink(),
          // Needs to be const Widget
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL,
        ),
      ),
    );
  }

  Widget attachmentMenuBox() {
    return Container(
      height: 278,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, menus[0]),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, menus[1]),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, menus[2]),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, menus[3]),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, menus[4]),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, menus[5]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {
        Get.back();
        if (text.contains(menus[0])) {
          pickFile(FileType.video, (value) {
            Get.to(() =>
                VideoPlayerScreen(path: value.path.toString(), onPathGet: (videoPath) {
                  sentMessage(
                      ChatMessageType.video, attachmentURl: value.path);
                }));
          });

        } else if (text.contains(menus[1])) {
          pickImageFile(ImageSource.camera, (value) {
            Get.to(() =>
                CameraViewPage(
                  path: value.path,
                  callBack: () {
                    sentMessage(
                        ChatMessageType.image, attachmentURl: value.path);
                  },
                ));
          });
        } else if (text.contains(menus[2])) {
          pickImageFile(ImageSource.gallery, (value) {
            Get.to(() =>
                CameraViewPage(
                  path: value.path,
                  callBack: () {
                    sentMessage(
                        ChatMessageType.image, attachmentURl: value.path);
                  },
                ));
          });
        } else if (text.contains(menus[3])) {
          pickFile(FileType.audio, (value) {

            sentMessage(
                ChatMessageType.audio, attachmentURl: value.path);
          });
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  pickFile(FileType type, ValueChanged<PlatformFile> imageFiles) async {
    final result =
    await FilePicker.platform.pickFiles(allowMultiple: true, type: type);

    if (result != null) {
      final file = result!.files.first;
      imageFiles(file);
    }
  }

  pickImageFile(ImageSource type, ValueChanged<File> imageFiles) async {
    final XFile? pickedImage =
    await ImagePicker().pickImage(source: type, imageQuality: 60);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      imageFiles(imageFile);
    }
  }

  void sentMessage(ChatMessageType type, {String? attachmentURl}) async {

    switch (type) {
      case ChatMessageType.text:
        chatViewModel
            .insertMessagesData(
            msg: inputMessageBox.text,
            customMessageObject: widget.item,
            isMine: isMine)
            .then((value) {
          inputMessageBox.clear();

          widget.onTextMessageSent(value);
        });
        break;
      case ChatMessageType.image:
      case ChatMessageType.audio:
      case ChatMessageType.video:
      var msgData = await chatViewModel.insertMessagesData(
          msg: type.name,
          hasAttachment: true,
          customMessageObject: widget.item,
          isMine: isMine);

      var attachmentData = AttachmentsTable(attachmentType: type.name, attachmentUrl: attachmentURl);
      var data = await chatViewModel.insertAttachmentsData(
          attachmentData, widget.item.receiverid, (msgID) {
        msgData.id = msgID;
        widget.onTextMessageSent(msgData);
      });
      widget.attachmentInsertedCallback(data);




        break;
    }
  }
}

