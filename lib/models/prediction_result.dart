/// Model class for prediction results from the API
class PredictionResult {
  final String prediction;
  final double confidence;
  final Map<String, double>? allPredictions;

  PredictionResult({
    required this.prediction,
    required this.confidence,
    this.allPredictions,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    Map<String, double>? allPreds;
    if (json['all_predictions'] != null) {
      allPreds = {};
      (json['all_predictions'] as Map<String, dynamic>).forEach((key, value) {
        allPreds![key] = (value as num).toDouble();
      });
    }

    return PredictionResult(
      prediction: json['prediction'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      allPredictions: allPreds,
    );
  }

  /// Returns confidence as a percentage string (e.g., "95.5%")
  String get confidencePercentage =>
      '${(confidence * 100).toStringAsFixed(1)}%';
}
