import 'package:flutter/material.dart';

void main() => runApp(const KantinBuSariApp());

const Color kGreen = Color(0xFF247A4B);
const Color kCream = Color(0xFFF7F6F0);
const Color kInk = Color(0xFF202820);

class Food {
  final String name, category, description, imageUrl;
  final int price;
  final double rating;
  const Food(
    this.name,
    this.category,
    this.description,
    this.imageUrl,
    this.price,
    this.rating,
  );
}

const foods = <Food>[
  Food(
    'Nasi Goreng Spesial',
    'Makanan',
    'Nasi goreng gurih dengan telur, sayuran, dan kerupuk.',
    'assets/images/nasi_goreng.jpg',
    15000,
    4.9,
  ),
  Food(
    'Ayam Geprek Sambal Bawang',
    'Makanan',
    'Ayam crispy geprek dengan sambal bawang dan nasi hangat.',
    'assets/images/ayam_geprek.jpg',
    17000,
    4.8,
  ),
  Food(
    'Nasi Ayam Teriyaki',
    'Makanan',
    'Ayam teriyaki manis gurih disajikan bersama nasi putih.',
    'assets/images/ayam_teriyaki.jpg',
    18000,
    4.7,
  ),
  Food(
    'Mie Goreng',
    'Makanan',
    'Mie goreng berbumbu dengan sayuran dan telur.',
    'assets/images/mie_goreng.jpg',
    14000,
    4.7,
  ),
  Food(
    'Bakso Kuah',
    'Makanan',
    'Bakso sapi kenyal dengan kuah kaldu hangat.',
    'assets/images/mie_goreng.jpg',
    14000,
    4.8,
  ),
  Food(
    'Soto Ayam',
    'Makanan',
    'Soto ayam berkuah segar dengan suwiran ayam dan koya.',
    'assets/images/soto_ayam.jpg',
    13000,
    4.8,
  ),
  Food(
    'Nasi Padang Rendang',
    'Makanan',
    'Rendang kaya rempah dengan nasi dan sayur khas Padang.',
    'assets/images/rendang.jpg',
    22000,
    4.9,
  ),
  Food(
    'Ayam Bakar',
    'Makanan',
    'Ayam bakar berbumbu, nasi hangat, lalapan, dan sambal.',
    'assets/images/ayam_bakar.jpg',
    18000,
    4.9,
  ),
  Food(
    'Es Teh Manis',
    'Minuman',
    'Teh pilihan dengan es batu yang menyegarkan.',
    'assets/images/es_teh.jpg',
    5000,
    4.6,
  ),
  Food(
    'Es Jeruk',
    'Minuman',
    'Perasan jeruk segar yang disajikan dingin.',
    'assets/images/es_jeruk.jpg',
    7000,
    4.7,
  ),
  Food(
    'Jus Alpukat',
    'Minuman',
    'Jus alpukat creamy, dibuat saat dipesan.',
    'assets/images/jus_alpukat.jpg',
    10000,
    4.7,
  ),
  Food(
    'Kopi Susu',
    'Minuman',
    'Kopi susu dingin dengan rasa seimbang.',
    'assets/images/kopi_susu.jpg',
    10000,
    4.6,
  ),
];

class FoodPhoto extends StatelessWidget {
  final Food food;
  final double width, height;
  final double radius;
  const FoodPhoto({
    super.key,
    required this.food,
    required this.width,
    required this.height,
    this.radius = 14,
  });
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset(
      food.imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, synchronousLoaded) =>
          synchronousLoaded || frame != null
          ? child
          : Container(
              width: width,
              height: height,
              color: const Color(0xFFEAF2E9),
              child: const Center(
                child: SizedBox(
                  width: 28,
                  child: LinearProgressIndicator(value: 0.35),
                ),
              ),
            ),
      errorBuilder: (context, error, stack) => Container(
        width: width,
        height: height,
        color: const Color(0xFFEAF2E9),
        child: const Icon(Icons.restaurant, color: kGreen, size: 30),
      ),
    ),
  );
}

String rupiah(int n) =>
    'Rp${n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

class KantinBuSariApp extends StatefulWidget {
  const KantinBuSariApp({super.key});
  @override
  State<KantinBuSariApp> createState() => _KantinBuSariAppState();
}

class _KantinBuSariAppState extends State<KantinBuSariApp> {
  int tab = 0;
  final Map<String, int> cart = {};
  final Set<String> favorites = {};
  final List<OrderRecord> history = [];
  int get cartCount => cart.values.fold(0, (a, b) => a + b);
  int get total =>
      foods.fold(0, (sum, f) => sum + f.price * (cart[f.name] ?? 0));

  void add(Food food) =>
      setState(() => cart[food.name] = (cart[food.name] ?? 0) + 1);
  void changeQty(Food food, int delta) => setState(() {
    final next = (cart[food.name] ?? 0) + delta;
    if (next <= 0) {
      cart.remove(food.name);
    } else {
      cart[food.name] = next;
    }
  });

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        favorites: favorites,
        cart: cart,
        onAdd: add,
        onFavorite: (f) => setState(() {
          favorites.contains(f.name)
              ? favorites.remove(f.name)
              : favorites.add(f.name);
        }),
        onOrder: () => setState(() => tab = 1),
      ),
      OrderPage(
        cart: cart,
        onChange: changeQty,
        total: total,
        onBrowse: () => setState(() => tab = 0),
        onSuccess: (orderId) => setState(() {
          history.insert(
            0,
            OrderRecord(orderId, Map.of(cart), total, DateTime.now()),
          );
          cart.clear();
          tab = 3;
        }),
      ),
      FavoritesPage(
        favorites: favorites,
        cart: cart,
        onAdd: add,
        onFavorite: (f) => setState(() => favorites.remove(f.name)),
      ),
      HistoryPage(orders: history),
      ProfilePage(orderCount: cartCount, favoritesCount: favorites.length),
    ];
    return MaterialApp(
      title: 'Kantin Bu Sari',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kCream,
        colorScheme: ColorScheme.fromSeed(seedColor: kGreen, primary: kGreen),
        appBarTheme: const AppBarTheme(
          backgroundColor: kCream,
          foregroundColor: kInk,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: IndexedStack(index: tab, children: pages),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.restaurant_menu),
              label: 'Menu',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              label: 'Pesanan',
            ),
            const NavigationDestination(
              icon: Icon(Icons.favorite_border),
              label: 'Favorit',
            ),
            const NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'Riwayat',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class OrderRecord {
  final String id;
  final Map<String, int> items;
  final int total;
  final DateTime time;
  OrderRecord(this.id, this.items, this.total, this.time);
}

class FavoritesPage extends StatelessWidget {
  final Set<String> favorites;
  final Map<String, int> cart;
  final ValueChanged<Food> onAdd, onFavorite;
  const FavoritesPage({
    super.key,
    required this.favorites,
    required this.cart,
    required this.onAdd,
    required this.onFavorite,
  });
  @override
  Widget build(BuildContext context) {
    final items = foods.where((f) => favorites.contains(f.name)).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: [
        const Text(
          'Menu favorit',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 5),
        const Text(
          'Menu yang kamu simpan untuk nanti.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 18),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Icon(Icons.favorite_border, size: 48, color: kGreen),
                SizedBox(height: 10),
                Text('Belum ada menu favorit'),
              ],
            ),
          )
        else
          ...items.map(
            (f) => FoodCard(
              food: f,
              favorite: true,
              quantity: cart[f.name] ?? 0,
              onAdd: () => onAdd(f),
              onFavorite: () => onFavorite(f),
              onTap: () => showFoodDetail(context, f, () => onAdd(f)),
            ),
          ),
      ],
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<OrderRecord> orders;
  const HistoryPage({super.key, required this.orders});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text(
        'Riwayat pesanan',
        style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 5),
      const Text(
        'Riwayat tersimpan selama aplikasi berjalan.',
        style: TextStyle(color: Colors.black54),
      ),
      const SizedBox(height: 18),
      if (orders.isEmpty)
        const Padding(
          padding: EdgeInsets.all(28),
          child: Column(
            children: [
              Icon(Icons.receipt_long, size: 48, color: kGreen),
              SizedBox(height: 10),
              Text('Belum ada pesanan selesai'),
            ],
          ),
        ),
      ...orders.map(
        (o) => Card(
          color: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        o.id,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text(
                      '${o.time.day}/${o.time.month}/${o.time.year}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                const Divider(),
                ...o.items.entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      '${e.value} × ${foods.firstWhere((f) => f.name == e.key).name}',
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Selesai · Tunai/konfirmasi kasir',
                        style: TextStyle(color: kGreen),
                      ),
                    ),
                    Text(
                      rupiah(o.total),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: kGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

class HomePage extends StatefulWidget {
  final Set<String> favorites;
  final Map<String, int> cart;
  final ValueChanged<Food> onAdd, onFavorite;
  final VoidCallback onOrder;
  const HomePage({
    super.key,
    required this.favorites,
    required this.cart,
    required this.onAdd,
    required this.onFavorite,
    required this.onOrder,
  });
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final search = TextEditingController();
  String category = 'Semua';
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shown = foods
        .where(
          (f) =>
              (category == 'Semua' || f.category == category) &&
              '${f.name} ${f.description} ${f.category}'.toLowerCase().contains(
                search.text.toLowerCase(),
              ),
        )
        .toList();
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: kGreen,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.soup_kitchen,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KANTIN BU SARI',
                        style: TextStyle(
                          fontSize: 12,
                          color: kGreen,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Text(
                        'Makan enak, hati senang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: widget.onOrder,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  tooltip: 'Lihat pesanan',
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
          sliver: SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF247A4B), Color(0xFF155735)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'MENU HARI INI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Lapar? Yuk,\npilih favoritmu!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Masakan rumahan, dibuat segar setiap hari.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 14),
                        FilledButton.tonal(
                          onPressed: () => setState(() => category = 'Makanan'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: kGreen,
                          ),
                          child: const Text('Lihat makanan'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  FoodPhoto(
                    food: foods.first,
                    width: 76,
                    height: 90,
                    radius: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: TextField(
              controller: search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Cari menu favorit...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: search.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Hapus pencarian',
                        onPressed: () {
                          search.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kategori',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                TextButton(
                  onPressed: () => setState(() => category = 'Semua'),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: ['Semua', 'Makanan', 'Minuman', 'Camilan']
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(c),
                        selected: category == c,
                        onSelected: (_) => setState(() => category = c),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Menu pilihan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  '${shown.length} menu',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        if (shown.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: Text('Menu tidak ditemukan. Coba kata kunci lain.'),
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              final f = shown[i];
              return FoodCard(
                food: f,
                favorite: widget.favorites.contains(f.name),
                quantity: widget.cart[f.name] ?? 0,
                onAdd: () => widget.onAdd(f),
                onFavorite: () => widget.onFavorite(f),
                onTap: () => showFoodDetail(context, f, () => widget.onAdd(f)),
              );
            }, childCount: shown.length),
          ),
        ),
      ],
    );
  }
}

class FoodCard extends StatelessWidget {
  final Food food;
  final bool favorite;
  final int quantity;
  final VoidCallback onAdd, onFavorite, onTap;
  const FoodCard({
    super.key,
    required this.food,
    required this.favorite,
    required this.quantity,
    required this.onAdd,
    required this.onFavorite,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2E9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: FoodPhoto(food: food, width: 64, height: 72, radius: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    food.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Color(0xFFE9A23B),
                      ),
                      Text(
                        '${food.rating}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        food.category,
                        style: const TextStyle(fontSize: 11, color: kGreen),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    rupiah(food.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: kGreen,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onFavorite,
                  icon: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border,
                    color: favorite ? Colors.red : Colors.black45,
                  ),
                ),
                FilledButton(
                  onPressed: onAdd,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(42, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                  ),
                  child: Text(quantity > 0 ? '+ $quantity' : '+'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void showFoodDetail(BuildContext context, Food food, VoidCallback onAdd) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: kCream,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              width: 130,
              height: 125,
              decoration: BoxDecoration(
                color: const Color(0xFFE5EFE3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: FoodPhoto(food: food, width: 130, height: 125, radius: 24),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            food.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Icon(Icons.star, size: 18, color: Color(0xFFE9A23B)),
              Text(
                ' ${food.rating}  •  ${food.category}',
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            food.description,
            style: const TextStyle(height: 1.5, color: Colors.black87),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: Text(
                  rupiah(food.price),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: kGreen,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () {
                  onAdd();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${food.name} ditambahkan ke pesanan'),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Tambah'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class OrderPage extends StatefulWidget {
  final Map<String, int> cart;
  final void Function(Food, int) onChange;
  final int total;
  final VoidCallback onBrowse;
  final ValueChanged<String> onSuccess;
  const OrderPage({
    super.key,
    required this.cart,
    required this.onChange,
    required this.total,
    required this.onBrowse,
    required this.onSuccess,
  });
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final name = TextEditingController();
  final note = TextEditingController();
  final table = TextEditingController();
  String method = 'Bayar di kasir';
  String orderMode = 'Makan di tempat';
  @override
  void dispose() {
    name.dispose();
    note.dispose();
    table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = foods.where((f) => (widget.cart[f.name] ?? 0) > 0).toList();
    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 18),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pesanan saya',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 5),
                Text(
                  'Periksa menu dan lengkapi detail pesanan.',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
        if (items.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    const Text('🛍️', style: TextStyle(fontSize: 58)),
                    const SizedBox(height: 10),
                    const Text(
                      'Keranjang masih kosong',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Pilih makanan atau minuman dari menu terlebih dahulu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 15),
                    FilledButton.icon(
                      onPressed: widget.onBrowse,
                      icon: const Icon(Icons.restaurant_menu),
                      label: const Text('Pilih menu'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (items.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                final f = items[i];
                final qty = widget.cart[f.name] ?? 0;
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF2E9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: FoodPhoto(
                            food: f,
                            width: 55,
                            height: 55,
                            radius: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                rupiah(f.price),
                                style: const TextStyle(
                                  color: kGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => widget.onChange(f, -1),
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          '$qty',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () => widget.onChange(f, 1),
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: kGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: items.length),
            ),
          ),
        if (items.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail pemesan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nama pemesan',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: orderMode,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: 'Makan di tempat',
                            child: Text('Makan di tempat'),
                          ),
                          DropdownMenuItem(
                            value: 'Bungkus',
                            child: Text('Bungkus'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => orderMode = value ?? orderMode),
                      ),
                    ),
                  ),
                  if (orderMode == 'Makan di tempat') ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: table,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nomor meja',
                        prefixIcon: Icon(Icons.table_restaurant),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  TextField(
                    controller: note,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Catatan (opsional)',
                      hintText: 'Contoh: sambal dipisah',
                      prefixIcon: Icon(Icons.notes),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Metode pembayaran',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: method,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: 'Bayar di kasir',
                            child: Text('Bayar di kasir'),
                          ),
                          DropdownMenuItem(value: 'QRIS', child: Text('QRIS')),
                          DropdownMenuItem(
                            value: 'Tunai saat diambil',
                            child: Text('Tunai saat diambil'),
                          ),
                        ],
                        onChanged: (v) => setState(() => method = v ?? method),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Jumlah item'),
                            Text(
                              '${items.fold<int>(0, (s, f) => s + (widget.cart[f.name] ?? 0))} item',
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total pembayaran',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              rupiah(widget.total),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: kGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              if (name.text.trim().isEmpty ||
                                  (orderMode == 'Makan di tempat' &&
                                      table.text.trim().isEmpty)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Isi nama pemesan dan nomor meja.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              final orderId =
                                  'KS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
                              final summary = items
                                  .map(
                                    (f) => '${widget.cart[f.name]} × ${f.name}',
                                  )
                                  .join('\n');
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Konfirmasi pesanan'),
                                  content: Text(
                                    'Bukti pesanan $orderId\nNama: ${name.text.trim()}\n${orderMode == 'Makan di tempat' ? 'Meja: ${table.text.trim()}' : 'Pengambilan: Bungkus'}\n\n$summary\n\nTotal: ${rupiah(widget.total)}\nPembayaran: $method\nStatus: Menunggu konfirmasi kasir.${note.text.trim().isEmpty ? '' : '\nCatatan: ${note.text.trim()}'}\n\nPembayaran tidak diproses oleh aplikasi.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Periksa lagi'),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Pesanan dikonfirmasi untuk disampaikan ke kasir.',
                                            ),
                                          ),
                                        );
                                        name.clear();
                                        note.clear();
                                        table.clear();
                                        widget.onSuccess(orderId);
                                      },
                                      child: const Text('Konfirmasi'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Buat pesanan'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  final int orderCount, favoritesCount;
  const ProfilePage({
    super.key,
    required this.orderCount,
    required this.favoritesCount,
  });
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const SizedBox(height: 8),
      const Text(
        'Profil',
        style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: kGreen,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 31,
              backgroundColor: Colors.white24,
              child: Icon(Icons.restaurant, color: Colors.white, size: 32),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kantin Bu Sari',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Masakan rumahan setiap hari',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.shopping_bag_outlined,
              title: 'Item di keranjang',
              value: '$orderCount',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.favorite_border,
              title: 'Menu favorit',
              value: '$favoritesCount',
            ),
          ),
        ],
      ),
      const SizedBox(height: 22),
      const Text(
        'Informasi kantin',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 10),
      _InfoTile(
        icon: Icons.access_time,
        title: 'Jam operasional',
        subtitle: 'Senin–Jumat, 07.00–16.00',
      ),
      _InfoTile(
        icon: Icons.location_on_outlined,
        title: 'Lokasi',
        subtitle: 'Area kantin kampus',
      ),
      _InfoTile(
        icon: Icons.call_outlined,
        title: 'Kontak',
        subtitle: 'Hubungi petugas kantin saat jam buka',
      ),
      _InfoTile(
        icon: Icons.info_outline,
        title: 'Tentang aplikasi',
        subtitle: 'Pemesanan menu Kantin Bu Sari',
      ),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2E9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'Aplikasi ini merupakan prototipe pemesanan kantin. Data menu dan transaksi masih tersimpan sementara selama aplikasi berjalan.',
          style: TextStyle(color: kGreen, height: 1.4),
        ),
      ),
    ],
  );
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title, value;
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kGreen),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.black54, fontSize: 11),
        ),
      ],
    ),
  );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Colors.white,
    margin: const EdgeInsets.only(bottom: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: ListTile(
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2E9),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, color: kGreen),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
    ),
  );
}
