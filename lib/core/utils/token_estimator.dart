class TokenEstimator {
  TokenEstimator._();

  static int estimate(String text) => (text.length / 4).ceil();

  static int estimateMessages(List<Map<String, String>> messages) {
    return messages.fold<int>(
      0,
      (sum, m) => sum + estimate(m['content'] ?? ''),
    );
  }

  static List<Map<String, String>> truncateToFit({
    required List<Map<String, String>> messages,
    required int maxTokens,
    int reserveForResponse = 500,
  }) {
    final budget = maxTokens - reserveForResponse;
    if (budget <= 0) return [];

    var total = 0;
    final result = <Map<String, String>>[];

    for (final msg in messages.reversed) {
      final cost = estimate(msg['content'] ?? '');
      if (total + cost > budget) break;
      total += cost;
      result.insert(0, msg);
    }

    return result;
  }
}
