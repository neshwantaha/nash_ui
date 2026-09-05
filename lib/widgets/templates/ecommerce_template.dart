import '../../nash_ui.dart';

/// A single product inside a [EcommerceTemplate].
class Product {
  const Product({
    required this.title,
    required this.price,
    this.subtitle,
    this.imageUrl,
    this.oldPrice,
    this.discount,
    this.rating,
    this.onTap,
    this.onAddToCart,
    this.onFavorite,
  });

  /// Product name.
  final String title;

  /// Current price.
  final String price;

  /// Optional subtitle.
  final String? subtitle;

  /// Image URL.
  final String? imageUrl;

  /// Original (strike-through) price.
  final String? oldPrice;

  /// Discount badge.
  final String? discount;

  /// Rating (0–5).
  final double? rating;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Add-to-cart callback.
  final VoidCallback? onAddToCart;

  /// Favorite toggle callback.
  final VoidCallback? onFavorite;
}

/// A complete e-commerce template.
///
/// Shows a gradient promo hero, category chips and a responsive product grid
/// built from [ProductCard].
class EcommerceTemplate extends StatelessWidget {
  const EcommerceTemplate({
    super.key,
    required this.products,
    this.title = 'Shop',
    this.bannerTitle = 'Summer Sale',
    this.bannerSubtitle = 'Up to 40% off selected items',
    this.bannerLabel = 'Shop now',
    this.oBannerTap,
    this.categories = const <String>[],
    this.onCategorySelected,
    this.onSearch,
    this.onCart,
    this.onFavorite,
    this.gridColumns,
    this.appBar,
    this.favorite = false,
  });

  /// Products to display.
  final List<Product> products;

  /// App bar title.
  final String title;

  /// Promo banner heading.
  final String bannerTitle;

  /// Promo banner subtitle.
  final String bannerSubtitle;

  /// Promo banner call-to-action text.
  final String bannerLabel;

  /// Promo banner tap callback.
  final VoidCallback? oBannerTap;

  /// Category chips.
  final List<String> categories;

  /// Called when a category chip is tapped.
  final ValueChanged<String>? onCategorySelected;

  /// Search action.
  final VoidCallback? onSearch;

  /// Cart action.
  final VoidCallback? onCart;

  /// Favorite toggle callback (passed to each product).
  final VoidCallback? onFavorite;

  /// Number of grid columns (auto-computed when null).
  final int? gridColumns;

  /// Custom app bar.
  final PreferredSizeWidget? appBar;

  /// Initial favorite state for all products.
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final int columns = gridColumns ?? _columnsFor(context);

    return Scaffold(
      appBar: appBar ??
          AppBar(
            title: title,
            actions: <Widget>[
              if (onSearch != null)
                IconButton(
                  onPressed: onSearch,
                  icon: const Icon(Icons.search_rounded),
                  tooltip: 'Search',
                ),
              if (onCart != null)
                IconButton(
                  onPressed: onCart,
                  icon: const Icon(Icons.shopping_cart_outlined),
                  tooltip: 'Cart',
                ),
            ],
          ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                gradient: AppGradients.sunset,
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: oBannerTap,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        bannerTitle,
                        style: textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: AppFontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bannerSubtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          bannerLabel,
                          style: textTheme.labelLarge?.copyWith(
                            color: scheme.primary,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (categories.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (final String category in categories)
                    Padding(
                      padding: EdgeInsets.only(
                          right:
                              category == categories.last ? 0 : AppSpacing.sm),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: false,
                        onSelected: (bool _) =>
                            onCategorySelected?.call(category),
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Featured',
            style: textTheme.titleLarge
                ?.copyWith(fontWeight: AppFontWeight.semibold),
          ),
          const SizedBox(height: AppSpacing.sm),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              mainAxisExtent: 340,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              final Product product = products[index];
              return ProductCard(
                title: product.title,
                price: product.price,
                subtitle: product.subtitle,
                imageUrl: product.imageUrl,
                oldPrice: product.oldPrice,
                discount: product.discount,
                rating: product.rating,
                onTap: product.onTap,
                onAddToCart: product.onAddToCart,
                onFavorite: product.onFavorite ?? onFavorite,
                favorite: favorite,
              );
            },
          ),
        ],
      ),
    );
  }

  int _columnsFor(BuildContext context) {
    final double w = MediaQuery.sizeOf(context).width;
    if (w >= 1100) return 4;
    if (w >= 700) return 3;
    if (w >= 480) return 2;
    return 2;
  }
}
