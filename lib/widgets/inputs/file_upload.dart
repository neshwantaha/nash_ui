import 'package:flutter/material.dart';

import '../../animation/duration.dart';
import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';

/// Represents a chosen file in [FileUpload].
class UploadedFile {
  const UploadedFile({
    required this.name,
    required this.sizeInBytes,
    this.progress = 1.0,
    this.error,
    this.id,
  });

  /// File display name.
  final String name;

  /// File size in bytes.
  final int sizeInBytes;

  /// Upload progress from 0.0 to 1.0.
  final double progress;

  /// Optional error message.
  final String? error;

  /// Optional unique identifier.
  final String? id;

  /// Formatted human-readable file size (e.g. "2.4 MB").
  String get formattedSize {
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// File extension without dot.
  String get extension {
    final idx = name.lastIndexOf('.');
    return idx != -1 ? name.substring(idx + 1).toLowerCase() : '';
  }
}

/// A modern file upload / dropzone widget with dashed border, file list, and progress bars.
class FileUpload extends StatefulWidget {
  const FileUpload({
    super.key,
    this.onTap,
    this.files = const [],
    this.onFileRemoved,
    this.title = 'Click or drag files here to upload',
    this.subtitle = 'Supports PDF, PNG, JPG, DOCX up to 10MB',
    this.icon = Icons.cloud_upload_outlined,
    this.maxFiles,
    this.enabled = true,
  });

  /// Tap callback to trigger system file picker.
  final VoidCallback? onTap;

  /// List of currently attached / uploading files.
  final List<UploadedFile> files;

  /// Callback when the user clicks remove on a file.
  final ValueChanged<UploadedFile>? onFileRemoved;

  /// Primary upload instruction title.
  final String title;

  /// Secondary helper text specifying formats/limits.
  final String subtitle;

  /// Center icon.
  final IconData icon;

  /// Optional maximum allowed files.
  final int? maxFiles;

  /// Whether the dropzone is active.
  final bool enabled;

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dropzone box
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: widget.enabled ? widget.onTap : null,
            child: AnimatedContainer(
              duration: AppDuration.fast,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
              decoration: BoxDecoration(
                color: _isHovered
                    ? (isDark
                        ? scheme.primary.withValues(alpha: 0.08)
                        : scheme.primary.withValues(alpha: 0.04))
                    : (isDark
                        ? const Color(0xFF131322)
                        : const Color(0xFFF9F9FD)),
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(
                  color: _isHovered
                      ? scheme.primary
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.12)),
                  width: _isHovered ? 1.5 : 1.2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      size: 24,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Files List
        if (widget.files.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.files.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final file = widget.files[index];
              return _FileTile(
                file: file,
                isDark: isDark,
                scheme: scheme,
                onRemove: () => widget.onFileRemoved?.call(file),
              );
            },
          ),
        ],
      ],
    );
  }
}

class _FileTile extends StatelessWidget {
  const _FileTile({
    required this.file,
    required this.isDark,
    required this.scheme,
    required this.onRemove,
  });

  final UploadedFile file;
  final bool isDark;
  final ColorScheme scheme;
  final VoidCallback onRemove;

  IconData _iconForExt(String ext) {
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'webp':
        return Icons.image_rounded;
      case 'zip':
      case 'rar':
        return Icons.folder_zip_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = file.error != null;
    final isUploading = file.progress < 1.0 && !hasError;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF18182B) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: hasError
              ? AppColors.error
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                _iconForExt(file.extension),
                size: 24,
                color: hasError ? AppColors.error : scheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      hasError ? file.error! : file.formattedSize,
                      style: TextStyle(
                        fontSize: 11,
                        color: hasError
                            ? AppColors.error
                            : (isDark ? Colors.white38 : Colors.black45),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: onRemove,
                tooltip: 'Remove file',
              ),
            ],
          ),
          if (isUploading) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: file.progress,
                minHeight: 4,
                backgroundColor: isDark ? Colors.white12 : Colors.black12,
                color: scheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
