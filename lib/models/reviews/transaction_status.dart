/// Transaction status for reviews
enum TransactionStatus {
  done('done'),
  cancelled('cancelled'),
  noDeal('no_deal'),
  scam('scam');

  final String value;
  const TransactionStatus(this.value);

  static TransactionStatus fromString(String value) {
    return TransactionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TransactionStatus.noDeal,
    );
  }
}
