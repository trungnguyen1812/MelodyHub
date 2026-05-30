# MelodyHub - Database Schema (DBML)

Tách thành **6 file** để vừa A4 khi in/export diagram.  
Chỉ bao gồm các bảng **thực sự đang được dùng** trong code.

---

## Danh sách file

| File | Nhóm | Bảng |
|------|------|------|
| `01_users_auth.dbml` | Users & Auth | users, roles, user_roles, personal_access_tokens, modules, permissions, role_permissions |
| `02_music_core.dbml` | Music Core | genres, artists, albums, songs, album_tracks, song_artists |
| `03_interactions.dbml` | Interactions | song_plays, song_likes, song_downloads, artist_followers, album_likes, comments, playlists, playlist_songs |
| `04_partner_payment.dbml` | Partner & Payment | partner_types, partners, partner_revenues, partner_payouts, subscription_plans, user_subscriptions, payments |
| `05_advertising.dbml` | Advertising | ad_priority_tiers, advertisements, ad_tracking |
| `06_copyright_notification.dbml` | Copyright & Notification | copyrights, copyright_reports, song_fingerprints, notifications |

---

## Cách dùng

Paste từng file vào **[dbdiagram.io](https://dbdiagram.io)** để render diagram.

### Lưu ý cross-reference giữa các nhóm

Một số bảng ở file sau tham chiếu đến bảng ở file trước:

```
02_music_core     → artists.partner_id  → partners  (file 04)
03_interactions   → song_plays          → songs, users, playlists
04_partner_payment → partners.user_id  → users      (file 01)
05_advertising    → advertisements.partner_id → partners (file 04)
06_copyright      → copyrights.partner_id     → partners (file 04)
```

Khi render **toàn bộ** thì paste tất cả 6 file vào 1 diagram (bỏ comment header).

---

## Bảng đã thiết kế nhưng chưa implement

> Không có trong DBML vì chưa có route/controller nào dùng đến.

- `comment_likes` — controller dùng cache thay thế
- `listening_history` — thay bằng `song_plays`
- `user_offline_songs`, `user_queues`, `user_preference`, `user_taste_profile`
- `user_followers`, `user_devices`, `login_histories`, `security_logs`
- `admin_activity_logs`, `api_logs`, `email_logs`, `email_templates`
- `recommendations`, `trending_songs`, `radio_stations`, `featured_contents`
- `daily_statistics`, `content_reports`, `coupon_codes`, `coupon_usages`
- `invoices`, `payment_methods`, `two_factor_auth`
- `menus`, `menu_roles`, `seo_meta`, `countries`
- `playlist_collaborators`, `playlist_followers`, `playlist_song_edits`
- `song_genres` (pivot)
