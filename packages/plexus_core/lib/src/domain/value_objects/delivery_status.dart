/// The delivery status of a message.
enum DeliveryStatus {
  /// Message is queued locally, waiting to be sent.
  sending,

  /// Message has been sent to at least one transport.
  sent,

  /// Message has been delivered to the recipient's device.
  delivered,

  /// Recipient has read the message.
  read,

  /// Message failed to send after all retries.
  failed,
}

extension DeliveryStatusX on DeliveryStatus {
  String get label {
    switch (this) {
      case DeliveryStatus.sending:
        return 'Sending';
      case DeliveryStatus.sent:
        return 'Sent';
      case DeliveryStatus.delivered:
        return 'Delivered';
      case DeliveryStatus.read:
        return 'Read';
      case DeliveryStatus.failed:
        return 'Failed';
    }
  }
}
