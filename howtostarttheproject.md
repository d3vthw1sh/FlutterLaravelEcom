# How to Start the Project

## Prerequisites
- **Node.js** (for any JS tooling, optional)
- **Composer** (PHP dependency manager)
- **PHP >= 8.1** with extensions `openssl`, `pdo_mysql`, `mbstring`, `tokenizer`, `xml`, `ctype`, `json`
- **MySQL** (or another DB supported by Laravel)
- **Flutter SDK** (latest stable)
- **Android Studio** with an Android emulator (or iOS simulator)
- **Git**

## 1. Clone the repository (if not already)
```bash
git clone <repository-url> D:\FlutterLaravelecommercial\ecommercial
cd D:\FlutterLaravelecommercial\ecommercial
```

## 2. Backend (Laravel) Setup
```bash
# Navigate to backend folder
cd backend

# Install PHP dependencies
composer install

# Copy example env file and generate app key
cp .env.example .env
php artisan key:generate

# Configure database in .env (DB_DATABASE, DB_USERNAME, DB_PASSWORD)
# Then run migrations and seeders
php artisan migrate --seed

# Create a symbolic link for public storage (uploads)
php artisan storage:link

# Start the Laravel development server
php artisan serve --host=127.0.0.1 --port=8000
```
The API will be available at `http://127.0.0.1:8000`.

## 3. Frontend (Flutter) Setup
```bash
# From the project root go to the frontend folder
cd ..\frontend

# Get Flutter dependencies
flutter pub get

# (Optional) Run code generation if any
# flutter pub run build_runner build --delete-conflicting-outputs

# Launch the app on an Android emulator
flutter run
```
If you are using an Android emulator, the app will automatically map `localhost` to `10.0.2.2` (handled in `ApiConstants`).

## 4. Verify the Setup
1. Open a browser and navigate to `http://127.0.0.1:8000/api/products` – you should see a JSON list of products.
2. In the Flutter app, the product list screen should display product images (served from `backend/public/uploads`).
3. Use the Laravel route `GET /uploads/{filename}` (already defined) to fetch images.

## 5. Common Commands
- **Stop Laravel server:** Press `Ctrl+C` in the terminal where `php artisan serve` is running.
- **Stop Flutter app:** Press `q` in the console running `flutter run`.
- **Run tests (Laravel):** `php artisan test`
- **Run tests (Flutter):** `flutter test`

---

*These steps assume a fresh clone. If you already have the code locally, start from step 2.*

## Quick Run (like React Native)

Open two terminals (or two tabs) and run:

**Backend (Laravel)**
```powershell
cd D:\FlutterLaravelecommercial\ecommercial\backend
composer install   # only first time
php artisan serve --host=127.0.0.1 --port=8000
```

**Frontend (Flutter)**
```powershell
cd D:\FlutterLaravelecommercial\ecommercial\frontend
flutter pub get    # only first time
flutter run
```

*Both commands stay alive; press `Ctrl+C` to stop the Laravel server and `q` to quit the Flutter app.*
