class Money {
  const Money(this.amount);

  final num amount;
}

class PhoneNumber {
  const PhoneNumber(this.value);

  final String value;
}

class BusinessDate {
  const BusinessDate(this.value);

  final DateTime value;
}

class BusinessTime {
  const BusinessTime({required this.hour, required this.minute});

  final int hour;
  final int minute;
}
