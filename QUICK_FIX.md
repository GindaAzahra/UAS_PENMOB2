# 🔧 QUICK FIX - ORDER TIDAK MASUK

## Masalah yang Ditemukan

Dari console log, order tidak tersimpan ke Supabase. Kemungkinan masalah:
1. **RLS Policy belum di-setup** - user tidak bisa insert
2. **Foreign Key Error** - restaurant_id tidak valid

## ✅ Solusi yang Sudah Dilakukan

1. **UpdateOrderService** - `restaurantId` sekarang bisa `null`
2. **Better Error Logging** - tambah print statement untuk debug
3. **CheckoutScreen** - ubah restaurantId ke `null` (not required)

## 🔧 STEP PENTING: SETUP RLS DI SUPABASE

**COPY-PASTE SQL INI KE SUPABASE SQL EDITOR:**

```sql
-- 1. Enable RLS pada tabel orders
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- 2. DROP policy yang mungkin sudah ada
DROP POLICY IF EXISTS "Users can view their own orders" ON public.orders;
DROP POLICY IF EXISTS "Users can create their own orders" ON public.orders;  
DROP POLICY IF EXISTS "Users can update their own orders" ON public.orders;
DROP POLICY IF EXISTS "Users can delete their own orders" ON public.orders;

-- 3. CREATE policy untuk SELECT (view)
CREATE POLICY "Users can view their own orders"
  ON public.orders
  FOR SELECT
  USING (auth.uid() = user_id);

-- 4. CREATE policy untuk INSERT (create)
CREATE POLICY "Users can create their own orders"
  ON public.orders
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- 5. CREATE policy untuk UPDATE
CREATE POLICY "Users can update their own orders"
  ON public.orders
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- 6. CREATE policy untuk DELETE
CREATE POLICY "Users can delete their own orders"
  ON public.orders
  FOR DELETE
  USING (auth.uid() = user_id);
```

**LANGKAH:**
1. Buka https://supabase.com/dashboard
2. Pilih project "GindaAzahra's Project"
3. Buka tab **SQL Editor**
4. Klik **+ New Query**
5. Copy-paste SQL di atas
6. Klik **Run** (tombol hijau)
7. Tunggu sampai berhasil ✅

## 📋 Setelah Setup RLS

1. Refresh browser aplikasi Flutter
2. Login lagi
3. Buat order:
   - Tambah items ke cart
   - Buka Checkout
   - Klik Bayar
   - Lihat "Pesanan Berhasil!" dialog
4. Buka Orders screen - order seharusnya muncul! ✅
5. Refresh page - order masih ada ✅
6. Check Supabase Dashboard -> Table `orders` -> lihat data ✅

## 🐛 Debug Tips

Kalau masih gamasuk, lakukan ini:

1. **Buka Console (DevTools F12)**
   - Lihat console log untuk error message
   - Cari pesan dengan "[OrderService]" atau "[CheckoutScreen]"

2. **Check Supabase RLS Status**
   - Supabase Dashboard → Table Editor
   - Pilih tabel `orders`
   - Klik tab **RLS** (atau Security)
   - Lihat apakah policies sudah ada dan enabled

3. **Test RLS Policy**
   - Supabase Dashboard → SQL Editor
   - Run query test:
   ```sql
   SELECT * FROM public.orders;
   ```
   - Kalau error 42501 (permission denied), berarti RLS policy issue

4. **Check Insert Error Detail**
   - Dari console log, cari "[OrderService] Error saving to Supabase: ..."
   - Copy error message lengkapnya
   - Ini akan memberitahu masalah pasti apa

## 📝 Files yang Diupdate

- `lib/services/order_service.dart` - Better error handling, restaurantId nullable
- `lib/screens/checkout_screen.dart` - restaurantId set to null

---

**Langkah paling penting: SETUP RLS!** Ini yang kemungkinan besar masalahnya. 🎯
