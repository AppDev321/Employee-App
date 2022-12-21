import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/database/model/attachments_table.dart';
import 'package:hnh_flutter/pages/chat/component/audio_chat_bubble.dart';
import 'package:hnh_flutter/view_models/chat_vm.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../custom_style/colors.dart';
import '../../../repository/model/request/socket_message_model.dart';
import '../../../utils/controller.dart';
import '../../../view_models/download_status_manager.dart';
import '../../../websocket/service/socket_service.dart';

class AttachmentWidget extends StatefulWidget {
  AttachmentWidget({Key? key, required this.item, required this.isDonwload})
      : super(key: key);
  final AttachmentsTable item;
  final bool isDonwload;

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  var path = '';
  var id = 0;
  Widget view = Container();
  double width = Get.mediaQuery.size.width / 5;
  double height = Get.mediaQuery.size.height / 5.5;
  bool isDownload = false;

  @override
  void initState() {
    isDownload = widget.isDonwload;
    id = widget.item.id!;
    path = isDownload
        ? widget.item.serverFileUrl.toString()
        : widget.item.attachmentUrl.toString();

    setState(() {
      if (widget.item.attachmentType == ChatMessageType.image.name ||
          widget.item.attachmentType == ChatMessageType.video.name) {
        view = SizedBox(height: height, width: width);
      } else {
        double width = Get.mediaQuery.size.width / 5;
        double height = 2;
        view = SizedBox(height: height, width: width);
      }
    });

    if (isDownload == false) {
      handleUploadFileManager(widget.item.attachmentType!);
    } else {
      handleDownloadManager(widget.item.attachmentType!);
    }
    super.initState();
  }

  void handleDownloadManager(attachmentType) {
    var downloadMgr = DownloadManager();
    downloadMgr.downloadFile(
      id,
      path,
      (downloadCompleted) {
        if (downloadCompleted == true) {
          if (mounted) {
            setState(() {
              if (attachmentType == ChatMessageType.image.name) {
                view = showImageContainer(
                    context, widget.item.attachmentUrl ?? path);
              } else if (attachmentType == ChatMessageType.audio.name) {
                view =
                    AudioBubble(filepath: widget.item.attachmentUrl.toString());
              }
            });
          }
        }
      },
      (progress) {
        setState(() {
          if (attachmentType == ChatMessageType.image.name) {
            view = showBlurImage(path, progress, true);
          } else if (attachmentType == ChatMessageType.audio.name) {
            view = CircularPercentIndicator(
              radius: 30.0,
              lineWidth: 3.0,
              percent: 1.0,
              center: Text(
                "${(progress).round()}%",
                style: const TextStyle(color: Colors.black, fontSize: 10),
              ),
              progressColor: primaryColor,
              backgroundColor: Colors.grey,
              circularStrokeCap: CircularStrokeCap.round,
            );
          }
        });
      },
      (storagePath) async {
        path = storagePath;
        var downloadData =
            await downloadMgr.getSingleDownloadRecord(widget.item.id!);
        widget.item.downloadID = downloadData!.id;
        widget.item.attachmentUrl = path;
        var chatModel = ChatViewModel();
        await chatModel.updateAttachment(widget.item);
      },
    );
  }

  void handleUploadFileManager(attachmentType) {
    var downloadMgr = DownloadManager();
    downloadMgr.uploadFile(id, path, context, (isUploaded) {
      if (mounted) {
        if (isUploaded == true) {
          setState(() {
            if (attachmentType == ChatMessageType.image.name) {
              view = showImageContainer(context, path);
            } else if (attachmentType == ChatMessageType.video.name) {
              view = AudioBubble(filepath: path);
            } else if (attachmentType == ChatMessageType.audio.name) {
              view = AudioBubble(filepath: path);
            }
          });
        } else {
          setState(() {
            if (attachmentType == ChatMessageType.image.name) {
              view = showBlurImage(path, 0, true);
            } else if (attachmentType == ChatMessageType.audio.name) {
              //   view =  AudioBubble(filepath:path);
            }
          });
        }
      }
    }, (progress) {
      setState(() {
        if (attachmentType == ChatMessageType.image.name) {
          view = showBlurImage(path, progress, true);
        } else if (attachmentType == ChatMessageType.audio.name) {
          view = CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 3.0,
            percent: 1.0,
            center: Text(
              "${(progress).round()}%",
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            progressColor: primaryColor,
            backgroundColor: Colors.grey,
            circularStrokeCap: CircularStrokeCap.round,
          );
        }
      });
    }, (uploadUrl) async {
      var downloadData =
          await downloadMgr.getSingleDownloadRecord(widget.item.id!);
      widget.item.downloadID = downloadData!.id;
      widget.item.serverFileUrl = uploadUrl;
      var chatModel = ChatViewModel();
      var attachmentTable = await chatModel.updateAttachment(widget.item);
      var msgTable =
          await chatModel.getSingleMessageRecord(widget.item.messageID!);

      //After upload completed
      SocketService socketService = SocketService();
      final Map<String, dynamic> data = Map<String, dynamic>();
      data['messageTable'] = msgTable;
      data['attachmentTable'] = attachmentTable;
      var message = SocketMessageModel(
          type: SocketMessageType.SendAttachment.displayTitle,
          sendTo: '${msgTable!.receiverID}',
          sendFrom: '${msgTable!.senderID}',
          data: data);
      socketService.sendMessageToWebSocket(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: view,
    );
  }

  Widget showBlurVideo(String imageURL, double progress,
      [bool isNetworkImage = false]) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          isNetworkImage == false
              ? Image.file(
                  File(path),
                  fit: BoxFit.cover,
                )
              : Image.network(
                  imageURL,
                  fit: BoxFit.cover,
                ),
          ClipRRect(
            // Clip it cleanly.
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.grey.withOpacity(0.1),
                alignment: Alignment.center,
                child: CircularPercentIndicator(
                  radius: 30.0,
                  lineWidth: 3.0,
                  percent: 1.0,
                  center: Text(
                    "${(progress).round()}%",
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  progressColor: primaryColor,
                  backgroundColor: Colors.grey,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showBlurImage(String imageURL, double progress,
      [bool isNetworkImage = false]) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          isNetworkImage == false
              ? Image.file(
                  File(path),
                  fit: BoxFit.cover,
                )
              : Image.network(
                  imageURL,
                  fit: BoxFit.cover,
                ),
          ClipRRect(
            // Clip it cleanly.
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.grey.withOpacity(0.1),
                alignment: Alignment.center,
                child: CircularPercentIndicator(
                  radius: 30.0,
                  lineWidth: 3.0,
                  percent: 1.0,
                  center: Text(
                    "${(progress).round()}%",
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  progressColor: primaryColor,
                  backgroundColor: Colors.grey,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showImageContainer(BuildContext context, String path) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (buildContext) =>
                Controller().imageDialog("", path, buildContext));
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Card(
          margin: EdgeInsets.all(1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.file(
            File(path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
