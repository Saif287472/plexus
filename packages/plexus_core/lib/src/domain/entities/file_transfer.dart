/// A file transfer record, tracking the lifecycle of a sent or received file.
class FileTransfer {
  /// Unique transfer ID.
  final String transferId;

  /// Conversation this transfer belongs to.
  final int conversationId;

  /// Original file name.
  final String fileName;

  /// File size in bytes.
  final int fileSize;

  /// MIME type of the file.
  final String mimeType;

    /// Encrypted local path to the stored file chunk(s).
  final String localPath;

  /// Current transfer status.
  final TransferStatus status;

  /// Direction of the transfer.
  final TransferDirection direction;

  /// Progress from 0.0 to 1.0.
  final double progress;

  /// Unix milliseconds when created.
  final int createdAt;

  /// Unix milliseconds when completed, or null.
  final int? completedAt;

  const FileTransfer({
    required this.transferId,
    required this.conversationId,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
    required this.localPath,
    required this.status,
    required this.direction,
    this.progress = 0.0,
    required this.createdAt,
    this.completedAt,
  });

  FileTransfer copyWith({
    String? transferId,
    int? conversationId,
    String? fileName,
    int? fileSize,
    String? mimeType,
    String? localPath,
    TransferStatus? status,
    TransferDirection? direction,
    double? progress,
    int? createdAt,
    int? completedAt,
  }) {
    return FileTransfer(
      transferId: transferId ?? this.transferId,
      conversationId: conversationId ?? this.conversationId,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      localPath: localPath ?? this.localPath,
      status: status ?? this.status,
      direction: direction ?? this.direction,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() => 'FileTransfer(transferId: $transferId, status: $status)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FileTransfer && other.transferId == transferId;

  @override
  int get hashCode => transferId.hashCode;
}

enum TransferStatus {
  pending,
  transferring,
  completed,
  failed,
  cancelled,
}

enum TransferDirection {
  sent,
  received,
}
