import 'dart:convert';

import 'package:cleancode/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    required int number,
    required String text,
  }) : super(number: number, text: text);

  NumberTriviaModel copyWith({
    int? number,
    String? text,
  }) {
    return NumberTriviaModel(
      number: number ?? this.number,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'number': number,
    };
  }

  factory NumberTriviaModel.fromMap(Map<String, dynamic> map) {
    return NumberTriviaModel(
      number: map['number']?.toInt() ?? 0,
      text: map['text'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NumberTriviaModel.fromJson(String source) =>
      NumberTriviaModel.fromMap(json.decode(source));

  @override
  String toString() => 'NumberTriviaModel(number: $number, text: $text)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NumberTriviaModel &&
        other.number == number &&
        other.text == text;
  }

  @override
  int get hashCode => number.hashCode ^ text.hashCode;
}
