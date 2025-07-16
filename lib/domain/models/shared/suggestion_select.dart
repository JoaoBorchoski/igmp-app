class SuggestionModelSelect {
  String value;
  String label;

  SuggestionModelSelect({
    required this.value,
    required this.label,
  });

  factory SuggestionModelSelect.fromJson(Map<String, dynamic> json) {
    return SuggestionModelSelect(
      value: json['value'],
      label: json['label'],
    );
  }
}
