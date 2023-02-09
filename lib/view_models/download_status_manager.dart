import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:hnh_flutter/repository/retrofit/multipart_request.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../database/dao/download_status_dao.dart';
import '../database/database_single_instance.dart';
import '../database/model/attachment_file_status_table.dart';
import '../utils/controller.dart';

class DownloadManager {
  Future<DownloadStatusTable?> getSingleDownloadRecord(int attachmentID) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final downloadDao = db?.downloadTableDAO as DownloadTableDAO;
    return await downloadDao.getDownloadRecord(attachmentID);
  }

  Future<void> insertDownloadRecord(DownloadStatusTable item,
      {bool isUpdateRecord = false}) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final downloadDao = db?.downloadTableDAO as DownloadTableDAO;
    if (isUpdateRecord) {
      await downloadDao.updateDownloadRecord(item);
    } else {
      await downloadDao.insertDownloadRecord(item);
    }
  }

  uploadFile(
    int attachmentId,
    String attachmentURl,
    BuildContext context,
    Function(bool) isCompleted,
    Function(double) progress,
    Function(String) uploadUrl,
  ) async {
    var downloadRecord = await getSingleDownloadRecord(attachmentId);
    if (downloadRecord != null) {
      if (downloadRecord.isCompleted == false) {
        checkAttachmentStatus(attachmentId, attachmentURl, context, isCompleted,
            progress, uploadUrl);
      } else {
        isCompleted(true);
      }
    } else {
      var data = DownloadStatusTable(
          attachmentId: attachmentId,
          type: "upload",
          percentage: 0,
          isCompleted: false,
          fileSize: 0);
      await insertDownloadRecord(data);
      checkAttachmentStatus(attachmentId, attachmentURl, context, isCompleted,
          progress, uploadUrl);
    }
  }

  checkAttachmentStatus(
    int attachmentId,
    String attachmentURl,
    BuildContext context,
    Function(bool) isUploadCompleted,
    Function(double) percent,
    Function(String) uploadUrl,
  ) {
    uploadFileToServer(context, File(attachmentURl.toString()),
        (uploadStatus) async {
      var downloadRecord = await getSingleDownloadRecord(attachmentId);
      if (downloadRecord != null) {
        downloadRecord.isCompleted = uploadStatus;
        await insertDownloadRecord(downloadRecord, isUpdateRecord: true);
      }
      isUploadCompleted(uploadStatus);
    }, (url) async {
      uploadUrl(url);
    }, (percentage) async {
      var downloadRecord =
          await getSingleDownloadRecord(attachmentId) as DownloadStatusTable;
      if (downloadRecord != null) {
        downloadRecord.percentage = percentage*100;
        await insertDownloadRecord(downloadRecord, isUpdateRecord: true);
      }
      percent(percentage);
    });
  }

  uploadFileToServer(
      BuildContext context,
      File filePath,
      ValueChanged<bool> isUploadCompleted,
      ValueChanged<String> fileUrl,
      ValueChanged<double> percentage,
      {bool isReturnPath = true,
      bool showUploadAlertMsg = true}) async {
    isUploadCompleted(false);

    var stream = http.ByteStream(DelegatingStream.typed(filePath.openRead()));
    var length = await filePath.length();
    var uri = Uri.parse("${Controller.appBaseURL}/media-upload");
    Controller controller = Controller();
    String? userToken = await controller.getAuthToken();

    final request = MultipartRequest(
      'POST',
      uri,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        percentage(progress);
      },
    );

    request.headers['Authorization'] = "Bearer $userToken";
    request.headers['Content-Type'] = "application/json";
    request.headers['Accept'] = "application/json";

    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(filePath.path));
    request.files.add(multipartFile);
    // request.fields['type']=requestType;

    Controller().printLogs(request.fields.toString());
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
    //  Controller().printLogs("response = $value");
      final parsedJson = jsonDecode(value);
      Controller().printLogs("parsedJson = $parsedJson");
      isUploadCompleted(true);
      if (parsedJson['code'].toString() == "200") {
        var data = parsedJson['data'];
        if (data != null) {
          var convertedURL = data['original_complete_url'];
          if (isReturnPath) {
            fileUrl(convertedURL);
          }
        }
      } else {
        if (showUploadAlertMsg == true) {
          var error = parsedJson['errors'][0]['message'];
          if (error != null) {
            Controller().showToastMessage(context, error);
          } else {
            Controller().showToastMessage(context,
                "There is some issue in uploading please try again later");
          }
        }
      }
    });
  }


  /// *******************************************
  ///
  ///  Download File mechanism
  ///
  ///
  ///


  downloadFile(
      int attachmentId,
      String attachmentURl,

      Function(bool) isCompleted,
      Function(double) progress,
      Function(String) uploadUrl,
      ) async {
    var downloadRecord = await getSingleDownloadRecord(attachmentId);
    if (downloadRecord != null) {
      if (downloadRecord.isCompleted == false) {
        checkDownloadStatus(attachmentId, attachmentURl,  isCompleted,
            progress, uploadUrl);
      } else {
        isCompleted(true);

      }
    } else {
      var data = DownloadStatusTable(
          attachmentId: attachmentId,
          type: "download",
          percentage: 0,
          isCompleted: false,
          fileSize: 0);
      await insertDownloadRecord(data);
      checkDownloadStatus(attachmentId, attachmentURl, isCompleted,
          progress, uploadUrl);
    }
  }



  checkDownloadStatus(
      int attachmentId,
      String downloadURl,
      Function(bool) isUploadCompleted,
      Function(double) percent,
      Function(String) filePath,
      ) {
    downloadFileFrom(downloadURl,  (storagePath)  {
      filePath(storagePath);
    },
            (uploadStatus) async {
          var downloadRecord = await getSingleDownloadRecord(attachmentId);
          if (downloadRecord != null) {
            downloadRecord.percentage=100;
            downloadRecord.isCompleted = uploadStatus;
            await insertDownloadRecord(downloadRecord, isUpdateRecord: true);
          }
          isUploadCompleted(uploadStatus);
        },
            (percentage) async {
          var downloadRecord =
          await getSingleDownloadRecord(attachmentId) as DownloadStatusTable;
          if (downloadRecord != null) {
            downloadRecord.percentage = percentage;
            await insertDownloadRecord(downloadRecord, isUpdateRecord: true);
          }
          percent(percentage);
        });
  }


  downloadFileFrom(
      String url,
      ValueChanged<String> fileUrl,
      ValueChanged<bool> isDownloadCompleted,
      ValueChanged<double> percentage) async {
    var httpClient = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    var response = httpClient.send(request);
    String dir = (await getApplicationDocumentsDirectory()).path;

    List<List<int>> chunks = [];
    int downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {

        chunks.add(chunk);
        downloaded += chunk.length;
        percentage(downloaded / r.contentLength! * 100);
      }, onDone: () async {
        percentage(downloaded / r.contentLength! * 100);
        isDownloadCompleted(true);

        String filename = url.split(Platform.pathSeparator).last;
        File file = File('$dir/$filename');
        final Uint8List bytes = Uint8List(r.contentLength!);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await file.writeAsBytes(bytes);
        fileUrl(file.path);
        return;
      });
    });
  }
}
