# Database Setup untuk Aliya Divani Food Delivery App

## SQL untuk membuat tabel Orders di Supabase

Jalankan SQL berikut di Supabase SQL Editor:

```sql
-- Create orders table
CREATE TABLE public.orders (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  items TEXT[] NOT NULL,
  total DOUBLE PRECISION NOT NULL,
  status TEXT NOT NULL DEFAULT 'In Progress',
  date TEXT NOT NULL,
  image TEXT,
  delivery_time TEXT DEFAULT '25-35 mins',
  restaurant TEXT NOT NULL,
  payment_method TEXT NOT NULL,
  address TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create index untuk user_id untuk mempercepat query
CREATE INDEX idx_orders_user_id ON public.orders(user_id);

-- Create index untuk created_at untuk sorting
CREATE INDEX idx_orders_created_at ON public.orders(created_at DESC);

-- Set up RLS (Row Level Security) agar user hanya bisa lihat order mereka sendiri
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- Policy: Users dapat melihat order mereka sendiri
CREATE POLICY "Users can view their own orders"
  ON public.orders
  FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: Users dapat membuat order baru
CREATE POLICY "Users can create their own orders"
  ON public.orders
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users dapat update order mereka sendiri
CREATE POLICY "Users can update their own orders"
  ON public.orders
  FOR UPDATE
  USING (auth.uid() = user_id);

-- Policy: Users dapat delete order mereka sendiri (optional)
CREATE POLICY "Users can delete their own orders"
  ON public.orders
  FOR DELETE
  USING (auth.uid() = user_id);
```

## Struktur Tabel Orders

| Column | Type | Description |
|--------|------|-------------|
| id | TEXT | Order ID (e.g., ORD101, ORD102) - Primary Key |
| user_id | UUID | User ID dari auth.users - Foreign Key |
| items | TEXT[] | Array of items (e.g., ['Nasi Goreng x1', 'Soto Ayam x1']) |
| total | DOUBLE PRECISION | Total price dalam Rupiah |
| status | TEXT | Order status (In Progress, Delivered, Cancelled, etc.) |
| date | TEXT | Order date string (e.g., '22 January 2026') |
| image | TEXT | Image URL dari item pertama |
| delivery_time | TEXT | Estimasi waktu delivery |
| restaurant | TEXT | Nama restaurant |
| payment_method | TEXT | Metode pembayaran (Kartu Kredit, Transfer Bank, E-Wallet, Tunai) |
| address | TEXT | Alamat delivery |
| created_at | TIMESTAMP | Waktu order dibuat (auto-generated) |
| updated_at | TIMESTAMP | Waktu order terakhir diupdate (auto-generated) |

## Fitur Database yang Terintegrasi

### 1. **Order Creation (Checkout)**
- User melakukan checkout dengan memilih payment method
- OrderService.createOrderFromCart() membuat order baru
- Order disimpan ke Supabase dengan user_id dari authenticated user
- Order juga disimpan di in-memory cache untuk UI responsif

### 2. **Order Retrieval (Order History)**
- OrdersScreen memanggil OrderService.loadOrders()
- OrderService.loadOrders() mengambil semua order untuk user dari Supabase
- Diurutkan by created_at DESC (paling baru di atas)
- Data ditampilkan di UI

### 3. **Order Update Status**
- Admin/system dapat update status order (In Progress → Delivered, etc.)
- OrderService.updateOrderStatus() update baik di local cache dan Supabase
- Perubahan langsung terlihat di UI

### 4. **Row Level Security (RLS)**
- User hanya bisa lihat order mereka sendiri
- Mencegah data leakage antar user
- Secure by default di database level

## Testing Checklist

- [ ] Buat tabel orders di Supabase dengan SQL di atas
- [ ] Login dengan akun Supabase
- [ ] Tambahkan items ke cart
- [ ] Lakukan checkout (pilih payment method)
- [ ] Verifikasi order muncul di Orders screen
- [ ] Refresh page dan verifikasi order masih ada (data dari Supabase)
- [ ] Cek Supabase Dashboard untuk melihat order di tabel

## Migration dari Demo Data ke Production

Jika ingin migrasi sample orders dari local ke Supabase:

```dart
// Di OrderService constructor, panggil method ini
Future<void> _loadInitialData() async {
  final sampleOrders = [
    OrderModel(...),
    ...
  ];
  
  final userId = SupabaseService.getUserId();
  if (userId != null) {
    for (var order in sampleOrders) {
      await SupabaseService.client.from('orders').insert(order.toMap());
    }
  }
}
```

Tapi biasanya cukup start dengan data kosong - user akan membuat order saat checkout.
