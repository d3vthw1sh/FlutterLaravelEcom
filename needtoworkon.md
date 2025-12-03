# Work To Do - Chronological Order

Based on dependency order and what needs to be built first, here's the work in **chronological order** (what to build first to last).

---

## **Phase 1: Core Product Display & Navigation** 🔴 CRITICAL ✅ COMPLETE

_These are foundational - everything else depends on them_

- ✅ Fix product images display - DONE
  - ✅ Product images seeded and mapped to local assets (`UpdateProductImagesSeeder` re-run)
- ✅ Fix product route navigation - DONE
- ✅ **Product Detail Screen** - DONE

  - ✅ Display full product info (name, brand, price, description, stock)
  - ✅ Image carousel (view multiple images)
  - ✅ Add to Cart button

- [ ] **Cart Management System** - DONE
  - ✅ Add items to cart (implemented via AddToCart event)
  - ✅ Display cart items with proper UI
  - ✅ Quantity adjustment (+ / -) with proper styling
  - ✅ Remove items with delete icon
  - ✅ Calculate and display totals (per item and grand total)
  - ✅ Cart persistence (using SharedPreferences)
  - ✅ Empty cart state with "Continue Shopping" button
  - ✅ Checkout button at bottom

---

## **Phase 2: User Authentication** 🔴 CRITICAL

_Needed before checkout and orders_

- ✅ **Improve Auth Screens** - DONE

  - ✅ Login form validation & error handling
  - ✅ Registration form validation & error handling
  - ✅ Forgot password flow
  - ✅ Proper error messages from API
  - ✅ Loading states
  - ✅ Fixed login crash (mapped backend `name` -> frontend `username` in `User.fromJson`)
  - ✅ Fixed registration crash & navigation (replaced `Navigator` with `GoRouter` and navigate to `/products`)

- ✅ **Auth State Management** - DONE
  - ✅ Token storage & retrieval
  - ✅ Auto-login on app restart
  - ✅ Logout functionality
  - ✅ Session timeout handling

---

## **Phase 3: Checkout & Orders** 🔴 CRITICAL

_Can't proceed without Phase 1 & 2_

- ✅ **Checkout Screen** - DONE

  - ✅ User info form (auto-fill from profile if logged in)
  - ✅ Shipping address form
  - ✅ Order summary
  - ✅ Shipping cost calculation

- [ ] **Order Creation**

  - ✅ Send order to backend (via Stripe session)
  - Reduce product stock
  - Save order in database
  - Return order confirmation

- ✅ **Order Success/Failure Screens** - DONE
  - ✅ Success screen with order details
  - ✅ Failure screen with retry option

---

## **Phase 4: User Dashboard** 🟠 HIGH

_Works independently from Phase 3_

- [ ] **User Profile Screen**

  - Display user info
  - Edit profile
  - Change password
  - Logout

- [ ] **Order History Screen**
  - List user's past orders
  - Show order status
  - Order details view
  - Order cancellation (if applicable)

---

## **Phase 5: Product Features** 🟠 HIGH

_Can be worked on parallel with Phase 4_

- [ ] **Product Reviews System**

  - Display reviews on product detail
  - Show rating/star display
  - Submit review form
  - Review list with pagination

- [ ] **Search Functionality** ⭐ HIGH PRIORITY
  - Search icon in app bar opens search screen
  - Search products by name
  - Filter by brand, category, price range
  - Display search results
  - Backend: `/api/products/search` endpoint

---

## **Phase 6: Admin Features** 🟠 HIGH

_Depends on auth being solid_

- [x] **Admin Console** - DONE
  - ✅ Role-based access (check if user is admin)
  - ✅ User management (list, delete, promote to admin)
    - ✅ Added `/api/users` endpoint for listing all users
    - ✅ Added `/api/users/{id}` DELETE endpoint for user deletion
    - ✅ Updated admin_bloc to handle users response (wrapped in `{ users: [...] }`)
    - ✅ Users tab displays user list with avatars, email, admin badge, delete action
  - [ ] Product management (add, edit, delete products)
  - [ ] Order management (view all orders, mark delivered, delete)

---

## **Phase 7: Payment Integration** 🟡 MEDIUM

_Can be done in parallel but after basic checkout works_

- [ ] **Stripe Setup**
  - Get Stripe API keys
  - Backend: Configure Stripe
  - Backend: Create checkout session endpoint
  - Flutter: Integrate Stripe payment
  - Handle payment success/failure webhooks

---

## **Phase 8: Polish & Optimization** 🟡 MEDIUM

- [ ] **Error Handling & User Feedback**

  - Proper error messages (not generic ones)
  - Toast notifications for actions
  - Dialogs for confirmations
  - Loading indicators on all screens

- [ ] **Data Persistence**

  - Local storage for cart (SharedPreferences)
  - Cache products list
  - Offline mode awareness

- [ ] **App Configuration**

  - Fix Android app ID (`com.example.myapp` → proper ID)
  - App icons and splash screen
  - App name and branding

- [ ] **Theme & UI Polish**
  - Dark mode implementation
  - Consistent spacing/padding
  - Animations & transitions
  - Typography refinement

---

## **Phase 9: Testing & Documentation** 🟢 LOW

- [ ] **Backend Testing**

  - Unit tests for models
  - Feature tests for API endpoints
  - Integration tests

- [ ] **Frontend Testing**

  - Widget tests
  - Integration tests

- [ ] **Documentation**
  - Update setup guide
  - API documentation
  - Code comments

---

## **Dependency Graph**

```
Phase 1 (Product Display) ✅ COMPLETE
    ↓
Phase 2 (Auth) ← NEXT
    ↓
Phase 3 (Checkout & Orders)
    ↓
├─ Phase 4 (User Dashboard) ← Can start while Phase 3 in progress
└─ Phase 5 (Products Features) ← Can start while Phase 3 in progress
    ↓
Phase 6 (Admin)
    ↓
Phase 7 (Payment)
    ↓
Phase 8 (Polish)
    ↓
Phase 9 (Testing & Docs)
```

---

## **Recommended Implementation Order**

1. ✅ **Product Detail Screen** - DONE
2. ✅ **Cart System** - DONE
3. **Next:** Better Auth validation - needed for checkout
4. **Then:** Checkout & Order flow
5. **Then:** User Dashboard features in parallel
6. **Then:** Search & Reviews
7. **Then:** Admin console
8. **Then:** Payment integration
9. **Finally:** Polish and testing

need to work on
+order history screen at profile tab

