# 🎵 MelodyHub Backend — Laravel 12 API Documentation

## 🧱 Giới thiệu

Dự án **MelodyHub Backend** được xây dựng trên **Laravel 12**, theo mô hình **API-First Architecture**.  
Mục tiêu: tách biệt rõ ràng giữa **xử lý HTTP**, **nghiệp vụ**, và **truy cập dữ liệu** để dễ mở rộng, test và bảo trì.

---

## ⚙️ Cấu trúc thư mục tổng thể

```
Backend/
├── app/
│   ├── Helpers/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   ├── Requests/
│   │   │   └── User/
│   │   └── Resources/
│   ├── Models/
│   ├── Providers/
│   ├── Repositories/
│   └── Services/
│
├── bootstrap/
│   ├── cache/
│   ├── app.php
│   └── providers.php
│
├── config/
├── database/
├── public/
├── resources/
├── routes/
├── storage/
├── tests/
├── vendor/
└── .editorconfig
```

---

## 📂 Giải thích chi tiết thư mục

### `app/`
Chứa toàn bộ code ứng dụng.

#### 🔹 `Helpers/`
- Dành cho **hàm tiện ích hoặc class helper**.
- Hai cách sử dụng:
  - Hàm toàn cục → khai báo trong `composer.json`:
    ```json
    "files": ["app/Helpers/helpers.php"]
    ```
  - Class helper → autoload:
    ```json
    "App\\Helpers\\": "app/Helpers/"
    ```

#### 🔹 `Http/Controllers/Api/`
- Nơi định nghĩa **endpoint API**.  
- Controller **chỉ nên điều phối**, không chứa logic nghiệp vụ.

#### 🔹 `Http/Requests/`
- Chứa **class validate request input**.

#### 🔹 `Http/Resources/`
- Định nghĩa **format JSON trả về**.

#### 🔹 `Models/`
- Đại diện cho các bảng trong DB (Eloquent ORM).

#### 🔹 `Repositories/`
- Chứa các lớp thao tác trực tiếp với DB.

#### 🔹 `Services/`
- Chứa **business logic** (nghiệp vụ chính).

#### 🔹 `Providers/`
- Đăng ký **service container** hoặc binding interface → implementation.

---

### `bootstrap/`
- Là nơi **khởi tạo ứng dụng**.  
- Laravel 12 đã bỏ `Kernel.php`; thay vào đó cấu hình được đặt ở `bootstrap/app.php`.

#### 🔸 `app.php`
- Đăng ký middleware, routes, commands, exception handlers.

#### 🔸 `providers.php`
- Danh sách các provider được load tự động.

---

### Các thư mục khác

| Thư mục | Vai trò |
|----------|----------|
| `config/` | File cấu hình ứng dụng |
| `database/` | Migration, Seeder, Factory |
| `public/` | File public (index.php, assets) |
| `resources/` | View, ngôn ngữ, template email |
| `routes/` | `api.php`, `web.php`, `console.php` |
| `storage/` | Log, cache, upload |
| `tests/` | Unit và Feature test |
| `vendor/` | Thư viện Composer |

---

## ⚡ Autoload cấu hình chuẩn (`composer.json`)

```json
"autoload": {
    "psr-4": {
        "App\\": "app/",
        "App\\Helpers\\": "app/Helpers/",
        "Database\\Factories\\": "database/factories/",
        "Database\\Seeders\\": "database/seeders/"
    },
    "files": [
        "app/Helpers/helpers.php"
    ]
}
```

Sau khi sửa, chạy:
```bash
composer dump-autoload
```

---

## 🧠 Quy ước viết API

| Tầng | Vai trò | Không nên làm |
|------|----------|----------------|
| **Controller** | Gọi service, trả JSON | Không viết logic DB |
| **Service** | Xử lý nghiệp vụ | Không gọi request hoặc response |
| **Repository** | Truy cập dữ liệu | Không xử lý nghiệp vụ |
| **Model** | Đại diện bảng DB | Không chứa nghiệp vụ |
| **Request / Resource** | Chuẩn hoá input / output | Không truy cập DB |

---

## 🧰 Lệnh Artisan hữu ích

| Lệnh | Mục đích |
|------|-----------|
| `php artisan migrate` | Chạy migration |
| `php artisan migrate:fresh` | Xoá toàn DB và tạo lại |
| `php artisan make:model Song -mcr` | Tạo model + migration + controller + resource |
| `php artisan make:request StoreUserRequest` | Tạo form request |
| `php artisan make:resource UserResource` | Tạo resource JSON |
| `php artisan key:generate` | Tạo APP_KEY mới |
| `php artisan optimize:clear` | Xoá cache config, route, view |

---

## 🧩 Gợi ý tiếp theo

- Triển khai **Sanctum hoặc JWT** cho xác thực API.
- Tạo **Global Exception Handler** trong `bootstrap/app.php`.
- Sử dụng **Service Container binding** trong `AppServiceProvider` cho Repository pattern.

---

**Tác giả:** Nguyen Trung  
**Framework:** Laravel 12  
**Cấu trúc:** API-Oriented Clean Architecture  
