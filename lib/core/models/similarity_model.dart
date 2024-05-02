class SimilarImagesModel {
  final int? numberOfSimilarImages;
  final List<String>? similarImages;

  SimilarImagesModel(
      {required this.numberOfSimilarImages, required this.similarImages});

  factory SimilarImagesModel.fromJson(Map<String, dynamic> json) {
    return SimilarImagesModel(
      numberOfSimilarImages: json['number of similar_images'],
      similarImages: List<String>.from(json['similar_images']),
    );
  }
}
