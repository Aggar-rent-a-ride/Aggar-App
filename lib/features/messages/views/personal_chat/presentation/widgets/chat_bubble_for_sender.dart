import 'dart:io';
import 'dart:typed_data';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_file_extension.dart';
import 'package:aggar/core/helper/get_mini_type_file.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/model/message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gap/gap.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../../../../core/utils/app_styles.dart';

// Import the new file viewer screen
class ChatBubbleForSender extends StatefulWidget {
  const ChatBubbleForSender({super.key, required this.message, this.isfile});
  final Message message;
  final bool? isfile;

  @override
  State<ChatBubbleForSender> createState() => _ChatBubbleForSenderState();
}

class _ChatBubbleForSenderState extends State<ChatBubbleForSender> {
  String? mimeType;
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isfile == true) {
      loadMimeType();
    }
  }

  void loadMimeType() async {
    final type = await getFileMimeType(widget.message.message);
    if (mounted) {
      setState(() {
        mimeType = type;
      });
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true; // iOS doesn't need this

    // Request the appropriate permission based on Android version
    if (await Permission.storage.request().isGranted) {
      return true;
    }

    // Show a simple dialog if denied
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Required'),
          content:
              const Text('Storage permission is needed to download files.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }
    return false;
  }

  void _openFile() async {
    if (isDownloading) return;

    setState(() {
      isDownloading = true;
    });

    // Simple permission check
    if (!await _requestStoragePermission()) {
      setState(() {
        isDownloading = false;
      });
      return;
    }

    // Rest of the method remains the same...
    setState(() {
      isDownloading = true;
    });

    try {
      // Debug info
      debugPrint("Starting file download: ${widget.message.message}");

      final filePath = await _downloadFile(widget.message.message);

      debugPrint("Download result: $filePath");

      if (filePath != null && mounted) {
        // Verify file exists
        final file = File(filePath);
        final exists = await file.exists();

        if (!exists) {
          debugPrint("File doesn't exist at path: $filePath");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Downloaded file not found')),
            );
          }
          return;
        }

        debugPrint("File exists, size: ${await file.length()} bytes");

        // Navigate to file viewer screen instead of using OpenFile
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FileViewerScreen(
                filePath: filePath,
                fileName: context
                    .read<MessageCubit>()
                    .getFileName(widget.message.message),
                fileType: mimeType ?? 'other',
              ),
            ),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to download file')),
        );
      }
    } catch (e) {
      debugPrint("Error opening file: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
        });
      }
    }
  }

  // Move the download functionality here to simplify the code
  Future<String?> _downloadFile(String messagePath) async {
    try {
      final String fileUrl = "${EndPoint.baseUrl}$messagePath";
      debugPrint("Full URL: $fileUrl");

      // Create a standard Dio instance for this specific download
      final dio = Dio();
      final response = await dio.get(
        fileUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      if (response.statusCode != 200) {
        debugPrint("Server returned status code: ${response.statusCode}");
        return null;
      }

      // Data should be Uint8List
      final bytes = response.data as Uint8List;
      if (bytes.isEmpty) {
        debugPrint("Downloaded file is empty");
        return null;
      }

      // Get app's download directory
      final Directory directory = await getApplicationDocumentsDirectory();

      // Create a unique filename with proper extension
      final String extension =
          getFileExtension(mimeType ?? 'other', messagePath);
      final String fileName =
          'file_${DateTime.now().millisecondsSinceEpoch}$extension';
      final String filePath = '${directory.path}/$fileName';

      debugPrint("Saving to path: $filePath");

      // Write the file to disk
      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      return filePath;
    } catch (e, stackTrace) {
      debugPrint("Error downloading file: $e");
      debugPrint("Stack trace: $stackTrace");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.65;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        margin: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        decoration: BoxDecoration(
          color: context.theme.blue100_1,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 3,
              offset: Offset(0, 0),
            )
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
        ),
        child: widget.isfile == false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      widget.message.message,
                      style: AppStyles.medium18(context).copyWith(
                        color: context.theme.white100_1,
                      ),
                    ),
                  ),
                  IntrinsicWidth(
                    child: Row(
                      spacing: 5,
                      children: [
                        Text(
                          widget.message.time,
                          style: AppStyles.medium12(context).copyWith(
                            color: context.theme.gray100_1,
                          ),
                        ),
                        Icon(
                          size: 15,
                          Icons.done_all_rounded,
                          color: context.theme.green100_1,
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                spacing: 2,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: _openFile,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: mimeType == "image"
                              ? Image.network(
                                  "${EndPoint.baseUrl}${widget.message.message}",
                                  width: 240,
                                  height: 240,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 150,
                                  height: 150,
                                  color:
                                      context.theme.white100_2.withOpacity(0.2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _getFileIcon(mimeType),
                                        size: 50,
                                        color: context.theme.white100_1,
                                      ),
                                      const Gap(8),
                                      Text(
                                        context
                                            .read<MessageCubit>()
                                            .getFileName(
                                                widget.message.message),
                                        style: AppStyles.medium12(context)
                                            .copyWith(
                                          color: context.theme.white100_1,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        if (isDownloading)
                          Container(
                            width: mimeType == "image" ? 200 : 150,
                            height: mimeType == "image" ? 200 : 150,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Row(
                      spacing: 5,
                      children: [
                        Text(
                          widget.message.time,
                          style: AppStyles.medium12(context).copyWith(
                            color: context.theme.gray100_1,
                          ),
                        ),
                        Icon(
                          size: 15,
                          Icons.done_all_rounded,
                          color: context.theme.green100_1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  IconData _getFileIcon(String? mimeType) {
    switch (mimeType) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'word':
        return Icons.description_outlined;
      case 'excel':
        return Icons.table_chart_outlined;
      case 'powerpoint':
        return Icons.slideshow_outlined;
      case 'text':
        return Icons.text_snippet_outlined;
      case 'image':
        return Icons.image_outlined;
      default:
        return Icons.file_present_outlined;
    }
  }
}

class FileViewerScreen extends StatefulWidget {
  final String filePath;
  final String fileName;
  final String fileType;

  const FileViewerScreen({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.fileType,
  });

  @override
  State<FileViewerScreen> createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  void _loadFile() async {
    // Short delay to allow the screen transition
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fileName,
          style: AppStyles.medium16(context),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () => OpenFile.open(widget.filePath),
            tooltip: 'Open with external app',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildFileViewer(),
    );
  }

  Widget _buildFileViewer() {
    // Check file extension and file type
    final fileExtension = path.extension(widget.filePath).toLowerCase();

    // PDF viewer
    if (fileExtension == '.pdf' || widget.fileType == 'pdf') {
      return PDFView(
        filePath: widget.filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        pageSnap: true,
        onError: (error) {
          _showErrorAndFallback('Could not load PDF: $error');
        },
        onPageError: (page, error) {
          _showErrorAndFallback('Error on page $page: $error');
        },
      );
    }

    // Image viewer
    else if (['.jpg', '.jpeg', '.png', '.gif'].contains(fileExtension) ||
        widget.fileType == 'image') {
      return Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 3.0,
          child: Image.file(
            File(widget.filePath),
            errorBuilder: (context, error, stackTrace) {
              return _buildFallbackView();
            },
          ),
        ),
      );
    }

    // For other file types that we can't directly render in the app
    else {
      return _buildFallbackView();
    }
  }

  Widget _buildFallbackView() {
    IconData fileIcon = _getFileIcon(widget.fileType);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            fileIcon,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 20),
          Text(
            widget.fileName,
            style: AppStyles.medium16(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open with External App'),
            onPressed: () => OpenFile.open(widget.filePath),
          ),
        ],
      ),
    );
  }

  void _showErrorAndFallback(String errorMessage) {
    debugPrint(errorMessage);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'word':
        return Icons.description_outlined;
      case 'excel':
        return Icons.table_chart_outlined;
      case 'powerpoint':
        return Icons.slideshow_outlined;
      case 'text':
        return Icons.text_snippet_outlined;
      case 'image':
        return Icons.image_outlined;
      default:
        return Icons.file_present_outlined;
    }
  }
}
