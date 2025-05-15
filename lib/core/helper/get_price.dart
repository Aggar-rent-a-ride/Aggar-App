String getPriceLabel(double? minPrice, double? maxPrice) {
  if (minPrice == null && maxPrice == null) {
    return "Pricing";
  }
  if (minPrice != null && maxPrice != null) {
    return "\$${minPrice.round()} - \$${maxPrice.round()}";
  }
  if (minPrice != null) {
    return "From \$${minPrice.round()}";
  }
  return "Up to \$${maxPrice!.round()}";
}
