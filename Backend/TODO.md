✅ Đã fix `getAllArtists()`:
- Thêm `Request $request` param
- Filter `where('partner_id')` khi có `?partner_id=123`
- Validate `partner_id > 0`, trả 422 nếu invalid
- Không có `partner_id` → lấy tất cả artists (giữ tương thích)
- Response format giữ nguyên `ArtistResource::collection()`
