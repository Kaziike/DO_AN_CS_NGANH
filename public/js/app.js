/**
 * TECHSTORE - MAIN CLIENT APPLICATION (VIETTEL STORE THEME)
 */

// Global Toast Notification Helper
function showToast(message, type = 'success') {
  let container = document.getElementById('toastContainer');
  if (!container) {
    container = document.createElement('div');
    container.id = 'toastContainer';
    container.className = 'toast-container';
    document.body.appendChild(container);
  }

  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  const icon = type === 'success' ? 'fa-circle-check' : (type === 'error' ? 'fa-circle-xmark' : 'fa-circle-info');

  toast.innerHTML = `
    <i class="fa-solid ${icon} toast-icon"></i>
    <span>${message}</span>
  `;

  container.appendChild(toast);

  setTimeout(() => {
    toast.style.animation = 'slideInRight 0.3s reverse forwards';
    setTimeout(() => toast.remove(), 300);
  }, 3500);
}

// Global Application Controller
const App = {
  pageCategory: null,

  state: {
    category: 'all',
    brand: 'all',
    minPrice: null,
    maxPrice: null,
    minRating: null,
    cpu: null,
    gpu: null,
    ram: null,
    storage: null,
    screen: null,
    feature: null,
    connection: null,
    sort: 'newest',
    search: '',
    page: 1,
    limit: 12
  },
  categoriesList: [],

  currentUser: null,

  async init() {
    this.pageCategory = document.body.dataset.category || null;
    if (this.pageCategory) {
      this.state.category = this.pageCategory;
    }

    this.checkCurrentUser();
    this.bindSearch();
    this.bindFilters();
    this.bindAccordionFilters();
    this.bindFloatingControls();
    this.bindModals();
    this.bindCartDrawer();
    this.bindOrderTracking();
    this.startFlashsaleCountdown();
    this.renderMobileBottomNav();
    this.initCategoryScrollIndicator();

    Checkout.init();

    // Lắng nghe thay đổi từ Giỏ hàng để cập nhật Badge & Drawer
    Cart.onChange((summary) => this.renderCartUI(summary));
    this.renderCartUI(Cart.getSummary());

    // Tải danh mục và danh sách sản phẩm ban đầu
    await this.loadCategories();
    if (!this.pageCategory) {
      await this.loadFeaturedSlider();
      await this.loadFlashsaleProducts();
      await this.loadHomeShowcases();

      // Kiểm tra tham số ?search= từ URL nếu có
      const urlParams = new URLSearchParams(window.location.search);
      const initialSearch = urlParams.get('search');
      if (initialSearch) {
        const searchInput = document.getElementById('mainSearchInput');
        if (searchInput) searchInput.value = initialSearch;
        await this.submitSearch(initialSearch);
      }
    } else {
      await this.loadProducts();
    }
  },

  // Làm mới toàn bộ dữ liệu sản phẩm hiển thị trên trang hiện tại sau khi đặt hàng
  async refreshProductsData() {
    if (!this.pageCategory) {
      if (this.loadFeaturedSlider) await this.loadFeaturedSlider();
      if (this.loadFlashsaleProducts) await this.loadFlashsaleProducts();
      if (this.loadHomeShowcases) await this.loadHomeShowcases();
      if (this.loadProducts) await this.loadProducts();
    } else {
      if (this.loadProducts) await this.loadProducts();
    }
    const modal = document.getElementById('productDetailModal');
    if (this.activeProductId && modal && modal.classList.contains('active')) {
      await this.openProductModal(this.activeProductId);
    }
  },

  // 1. Kiểm tra trạng thái đăng nhập
  checkCurrentUser() {
    try {
      const saved = localStorage.getItem('techstore_user');
      this.currentUser = saved ? JSON.parse(saved) : null;
    } catch (e) {
      this.currentUser = null;
    }
    this.renderUserHeader();
  },

  renderUserHeader() {
    const container = document.getElementById('headerUserSlot');
    if (!container) return;

    if (this.currentUser) {
      container.innerHTML = `
        <div class="user-header-auth-group">
          <div class="user-menu-wrapper" id="userMenuWrapper">
            <button type="button" class="user-profile-btn" id="userProfileBtn" onclick="App.toggleUserDropdown(event)" title="Xem tài khoản">
              <img src="${this.currentUser.avatar || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80'}" alt="Avatar">
              <span class="user-profile-name">${this.currentUser.name}</span>
              <i class="fa-solid fa-angle-down" style="font-size: 0.72rem;"></i>
            </button>
            <div class="user-dropdown-menu" id="userDropdownMenu">
              <div style="padding: 10px 14px; border-bottom: 1px solid #f3f4f6; font-size: 0.8rem; color: #6b7280;">
                <div>Xin chào,</div>
                <strong style="color: #111; font-size: 0.88rem;">${this.currentUser.name}</strong>
                <div style="font-size: 0.75rem; color: #9ca3af; margin-top: 2px;">${this.currentUser.email || this.currentUser.phone}</div>
              </div>
              <button type="button" class="user-dropdown-item" onclick="App.openUserProfileModal(); App.closeUserDropdown();">
                <i class="fa-solid fa-id-card" style="color: var(--vt-red);"></i> Thông tin tài khoản
              </button>
              <button type="button" class="user-dropdown-item" onclick="App.openMyOrders(); App.closeUserDropdown();">
                <i class="fa-solid fa-truck-fast"></i> Đơn hàng của tôi
              </button>
              ${this.currentUser.role === 'admin' ? `
              <a href="/admin.html" class="user-dropdown-item" style="color: #4f46e5; font-weight: 700;">
                <i class="fa-solid fa-shield-halved"></i> Quản trị hệ thống
              </a>` : ''}
              <button type="button" class="user-dropdown-item logout" onclick="App.handleLogout();">
                <i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất
              </button>
            </div>
          </div>
          
        </div>
      `;
    } else {
      container.innerHTML = `
        <a href="/login.html" class="header-action-item" title="Đăng nhập / Đăng ký">
          <i class="fa-regular fa-circle-user"></i>
          <span>Đăng nhập</span>
        </a>
      `;
    }
  },

  toggleUserDropdown(e) {
    if (e) e.stopPropagation();
    const menu = document.getElementById('userDropdownMenu');
    if (menu) menu.classList.toggle('show');
  },

  closeUserDropdown() {
    const menu = document.getElementById('userDropdownMenu');
    if (menu) menu.classList.remove('show');
  },

  handleLogout() {
    localStorage.removeItem('techstore_user');
    this.currentUser = null;
    this.renderUserHeader();
    showToast('Đã đăng xuất thành công!', 'info');
    setTimeout(() => {
      window.location.reload();
    }, 250);
  },

  // 2. Flashsale Countdown Timer (14H - 22H)
  startFlashsaleCountdown() {
    const dayEl = document.getElementById('fsDays');
    const hourEl = document.getElementById('fsHours');
    const minEl = document.getElementById('fsMins');
    const secEl = document.getElementById('fsSecs');

    function update() {
      const now = new Date();
      // Target: 22:00 today
      const target = new Date();
      target.setHours(22, 0, 0, 0);

      // Nếu đã qua 22h, đếm ngược đến 22h ngày mai
      if (now.getTime() > target.getTime()) {
        target.setDate(target.getDate() + 1);
      }

      const diff = Math.max(0, target.getTime() - now.getTime());
      const hours = Math.floor((diff / (1000 * 60 * 60)) % 24);
      const minutes = Math.floor((diff / (1000 * 60)) % 60);
      const seconds = Math.floor((diff / 1000) % 60);

      if (dayEl) dayEl.textContent = '00';
      if (hourEl) hourEl.textContent = String(hours).padStart(2, '0');
      if (minEl) minEl.textContent = String(minutes).padStart(2, '0');
      if (secEl) secEl.textContent = String(seconds).padStart(2, '0');
    }

    update();
    setInterval(update, 1000);
  },

  // 2. Flash Sale từ SQL (Lưu trữ và quản lý hoàn toàn trên Database)
  async loadFlashsaleProducts() {
    const container = document.getElementById('flashsaleGrid');
    if (!container) return;

    try {
      const res = await fetch('/api/flash-sales');
      const data = await res.json();
      if (data.success && data.data && data.data.length > 0) {
        container.innerHTML = data.data.slice(0, 4).map((fs) => {
          const discount = fs.original_price > fs.flash_price ? Math.round(((fs.original_price - fs.flash_price) / fs.original_price) * 100) : 15;
          const isOutOfStock = fs.actual_stock <= 0 || fs.sold_count >= fs.flash_stock;
          return `
            <div class="product-card" style="box-shadow: 0 4px 12px rgba(0,0,0,0.06);">
              <div class="product-card-top">
                <div class="card-badges">
                  <span class="badge badge-sale">-${discount}%</span>
                  <span class="badge" style="background: #fef08a; color: #854d0e;">Đã bán ${fs.sold_count}/${fs.flash_stock}</span>
                  ${isOutOfStock ? `<span class="badge badge-stock" style="background: #ef4444; color: #fff;">Hết suất</span>` : ''}
                </div>
                <img src="${fs.image_url}" alt="${fs.name}" onclick="App.openProductModal(${fs.product_id})" style="cursor: pointer;">
                <button type="button" class="btn-quick-view" onclick="App.openProductModal(${fs.product_id})" title="Xem nhanh thông số">
                  <i class="fa-solid fa-eye"></i> Xem nhanh
                </button>
              </div>
              <div class="product-card-body">
                <div class="product-brand">${fs.brand}</div>
                <h4 class="product-name" onclick="App.openProductModal(${fs.product_id})">${fs.name}</h4>
                <div class="product-price-row">
                  <span class="current-price">${new Intl.NumberFormat('vi-VN').format(fs.flash_price)}₫</span>
                  <span class="original-price">${new Intl.NumberFormat('vi-VN').format(fs.original_price)}₫</span>
                </div>
                <div class="product-rating">
                  <i class="fa-solid fa-star"></i>
                  <strong>${fs.rating || 5}</strong>
                  <span style="color: #9ca3af; font-size: 0.75rem;">(${fs.reviews_count || 0})</span>
                  <span class="product-sold-tag"><i class="fa-solid fa-bolt" style="color: #eab308;"></i> Flash Sale</span>
                </div>
                <div class="product-card-footer">
                  ${isOutOfStock ? `
                    <button class="btn-card-cart disabled" disabled style="opacity: 0.55; cursor: not-allowed; background: #e5e7eb; color: #9ca3af; border-color: #d1d5db;">
                      <i class="fa-solid fa-ban"></i> Hết suất
                    </button>
                    <button class="btn-card-buy disabled" disabled style="opacity: 0.55; cursor: not-allowed; background: #9ca3af;">
                      Tạm hết
                    </button>
                  ` : `
                    <button class="btn-card-cart" onclick="App.handleAddToCart(${fs.product_id}, event)" title="Thêm vào giỏ">
                      <i class="fa-solid fa-cart-plus"></i> <span class="btn-card-cart-text">Thêm giỏ</span>
                    </button>
                    <button class="btn-card-buy" onclick="App.handleBuyNow(${fs.product_id})">
                      Mua ngay
                    </button>
                  `}
                </div>
              </div>
            </div>
          `;
        }).join('');
      }
    } catch (e) {
      console.error('Lỗi tải flashsale từ SQL:', e);
    }
  },

  // Helper dùng chung thiết lập tương tác cuộn Carousel Slider
  setupCarouselSlider(viewport, track, btnPrev, btnNext) {
    if (!viewport || !track) return;

    const updateArrowButtons = () => {
      if (!btnPrev || !btnNext) return;
      const maxScrollLeft = Math.max(0, track.scrollWidth - viewport.clientWidth);
      btnPrev.disabled = viewport.scrollLeft <= 5;
      btnNext.disabled = viewport.scrollLeft >= maxScrollLeft - 5;
    };

    const getScrollStep = () => {
      const firstCard = track.querySelector('.product-card');
      if (firstCard && firstCard.offsetWidth > 0) {
        // Cuộn 2 sản phẩm mỗi lần bấm lướt
        return (firstCard.offsetWidth + 16) * 2;
      }
      return viewport.clientWidth * 0.75;
    };

    if (btnPrev) {
      btnPrev.onclick = (e) => {
        e.preventDefault();
        viewport.scrollBy({ left: -getScrollStep(), behavior: 'smooth' });
        setTimeout(updateArrowButtons, 350);
      };
    }

    if (btnNext) {
      btnNext.onclick = (e) => {
        e.preventDefault();
        viewport.scrollBy({ left: getScrollStep(), behavior: 'smooth' });
        setTimeout(updateArrowButtons, 350);
      };
    }

    viewport.addEventListener('scroll', updateArrowButtons, { passive: true });
    updateArrowButtons();
    setTimeout(updateArrowButtons, 150);
    setTimeout(updateArrowButtons, 500);
  },

  // 2.1 Slider Sản phẩm nổi bật bán chạy tại trang index (Top 8 bán chạy - 4 hiển thị cùng lúc)
  async loadFeaturedSlider() {
    const track = document.getElementById('featuredProductsTrack');
    const viewport = document.getElementById('featuredCarouselViewport');
    const btnPrev = document.getElementById('btnFeaturedPrev');
    const btnNext = document.getElementById('btnFeaturedNext');
    if (!track || !viewport) return;

    try {
      // Gọi API lấy top 8 sản phẩm bán chạy nhất sắp xếp theo sold_count DESC
      const res = await fetch('/api/products?sort=sold&limit=8');
      const data = await res.json();
      if (data.success && data.data.products && data.data.products.length > 0) {
        track.innerHTML = data.data.products.map(p => this.renderProductCardHTML(p)).join('');
        this.setupCarouselSlider(viewport, track, btnPrev, btnNext);
      }
    } catch (e) {
      console.error('Lỗi tải slider sản phẩm nổi bật:', e);
    }
  },

  // 2.2 Tải các Showcase danh mục nổi bật trên trang chủ (Top 8 bán chạy - 4 hiển thị cùng lúc với nút lướt qua)
  async loadHomeShowcases() {
    const showcases = [
      { id: 'showcaseSmartphones', viewportId: 'viewportSmartphones', btnPrevId: 'btnSmartphonesPrev', btnNextId: 'btnSmartphonesNext', slug: 'smartphone' },
      { id: 'showcaseLaptops', viewportId: 'viewportLaptops', btnPrevId: 'btnLaptopsPrev', btnNextId: 'btnLaptopsNext', slug: 'laptop' },
      { id: 'showcaseSmartwatches', viewportId: 'viewportSmartwatches', btnPrevId: 'btnSmartwatchesPrev', btnNextId: 'btnSmartwatchesNext', slug: 'smartwatch' },
      { id: 'showcaseTablets', viewportId: 'viewportTablets', btnPrevId: 'btnTabletsPrev', btnNextId: 'btnTabletsNext', slug: 'tablet' },
      { id: 'showcaseAudio', viewportId: 'viewportAudio', btnPrevId: 'btnAudioPrev', btnNextId: 'btnAudioNext', slug: 'audio' },
      { id: 'showcaseGamingGear', viewportId: 'viewportGamingGear', btnPrevId: 'btnGamingGearPrev', btnNextId: 'btnGamingGearNext', slug: 'gaming-gear' },
      { id: 'showcaseComponents', viewportId: 'viewportComponents', btnPrevId: 'btnComponentsPrev', btnNextId: 'btnComponentsNext', slug: 'components' }
    ];

    for (const sc of showcases) {
      const track = document.getElementById(sc.id);
      const viewport = document.getElementById(sc.viewportId);
      const btnPrev = document.getElementById(sc.btnPrevId);
      const btnNext = document.getElementById(sc.btnNextId);
      if (!track || !viewport) continue;

      try {
        const res = await fetch(`/api/products?category=${sc.slug}&sort=sold&limit=8`);
        const data = await res.json();
        if (data.success && data.data.products && data.data.products.length > 0) {
          track.innerHTML = data.data.products.map(p => this.renderProductCardHTML(p)).join('');
          this.setupCarouselSlider(viewport, track, btnPrev, btnNext);
        }
      } catch (err) {
        console.error(`Lỗi tải showcase ${sc.id}:`, err);
      }
    }
  },

  // 3. Tải danh mục sản phẩm (Đồng bộ Menu chính + Filter Drawer)
  async loadCategories() {
    try {
      const res = await fetch('/api/categories');
      const data = await res.json();
      if (data.success) {
        this.categoriesList = data.data;
      }
    } catch (e) {
      console.error('Lỗi tải danh mục:', e);
    }
  },

  syncNavbarCategory() {
    const links = document.querySelectorAll('.vts-menu-link');
    links.forEach(l => {
      if (l.getAttribute('data-cat') === this.state.category) l.classList.add('active');
      else l.classList.remove('active');
    });
  },

  filterByCategory(slug) {
    this.state.category = slug;
    this.state.page = 1;
    this.syncNavbarCategory();

    this.renderActiveFilterTags();
    this.loadProducts();
    // 1. Nếu trang chuyên biệt có khu vực sản phẩm tổng hợp (catalogSection)
    const catalogEl = document.getElementById('catalogSection');
    if (catalogEl) {
      window.scrollTo({ top: catalogEl.offsetTop - 70, behavior: 'smooth' });
      return;
    }

    // 2. Nếu ở trang chủ index.html, tự động lướt xuống khối danh mục nổi bật tương ứng
    const showcaseSectionMap = {
      'smartphone': 'sectionSmartphones',
      'laptop': 'sectionLaptops',
      'smartwatch': 'sectionSmartwatches',
      'tablet': 'sectionTablets',
      'audio': 'sectionAudio',
      'gaming-gear': 'sectionGamingGear',
      'components': 'sectionComponents',
      'smartwatch-kids': 'sectionSmartwatches',
      'smartwacth-kid': 'sectionSmartwatches',
      'all': 'featuredSliderSection'
    };

    const targetSectionId = showcaseSectionMap[slug] || 'featuredSliderSection';
    const targetEl = document.getElementById(targetSectionId);
    if (targetEl) {
      window.scrollTo({ top: targetEl.offsetTop - 70, behavior: 'smooth' });
    }
  },

  // 4. Tải danh sách sản phẩm (Hỗ trợ 8 Skeleton Shimmer Cards hiện đại)
  async loadProducts() {
    const grid = document.getElementById('productsGrid');
    if (!grid) return;

    // Render 8 Skeleton Shimmer Cards thay vì spinner đơn giản
    grid.innerHTML = Array.from({ length: 8 }).map(() => `
      <div class="skeleton-card">
        <div class="skeleton-img skeleton-shimmer"></div>
        <div class="skeleton-text skeleton-shimmer" style="width: 40%; height: 12px; margin-bottom: 8px;"></div>
        <div class="skeleton-text skeleton-shimmer" style="width: 85%; height: 16px; margin-bottom: 12px;"></div>
        <div class="skeleton-text skeleton-shimmer" style="width: 60%; height: 20px; margin-bottom: 16px;"></div>
        <div style="display: flex; gap: 8px; margin-top: auto;">
          <div class="skeleton-btn skeleton-shimmer" style="flex: 1; height: 34px;"></div>
          <div class="skeleton-btn skeleton-shimmer" style="flex: 1; height: 34px;"></div>
        </div>
      </div>
    `).join('');

    try {
      const params = new URLSearchParams({
        category: this.state.category,
        brand: this.state.brand,
        sort: this.state.sort,
        page: this.state.page,
        limit: this.state.limit
      });

      if (this.state.minPrice) params.append('minPrice', this.state.minPrice);
      if (this.state.maxPrice) params.append('maxPrice', this.state.maxPrice);
      if (this.state.minRating) params.append('minRating', this.state.minRating);
      if (this.state.search) params.append('search', this.state.search);
      if (this.state.cpu) params.append('cpu', this.state.cpu);
      if (this.state.gpu) params.append('gpu', this.state.gpu);
      if (this.state.ram) params.append('ram', this.state.ram);
      if (this.state.storage) params.append('storage', this.state.storage);
      if (this.state.screen) params.append('screen', this.state.screen);
      if (this.state.feature) params.append('feature', this.state.feature);
      if (this.state.connection) params.append('connection', this.state.connection);
      if (this.state.component_type) params.append('component_type', this.state.component_type);

      const res = await fetch(`/api/products?${params.toString()}`);
      const data = await res.json();

      if (data.success) {
        this.renderProductsGrid(data.data.products);
        this.renderPagination(data.data);

        const countEl = document.getElementById('resultsCount');
        if (countEl) countEl.textContent = data.data.total;

        const searchCountBadge = document.getElementById('searchResultsCountBadge');
        if (searchCountBadge) searchCountBadge.textContent = `${data.data.total} sản phẩm`;
      }
    } catch (e) {
      grid.innerHTML = `<div style="grid-column: 1/-1; text-align: center; color: #dc2626; padding: 30px;">Lỗi khi tải dữ liệu sản phẩm.</div>`;
    }
  },

  renderProductCardHTML(p) {
    const discount = p.original_price > p.price ? Math.round(((p.original_price - p.price) / p.original_price) * 100) : 0;
    const formattedPrice = new Intl.NumberFormat('vi-VN').format(p.price) + '₫';
    const formattedOldPrice = p.original_price > p.price ? new Intl.NumberFormat('vi-VN').format(p.original_price) + '₫' : '';
    const isOutOfStock = p.stock <= 0;

    return `
      <div class="product-card" data-id="${p.id}">
        <div class="product-card-top">
          <div class="card-badges">
            ${discount > 0 ? `<span class="badge badge-sale">-${discount}%</span>` : ''}
            <span class="badge badge-installment">Trả góp 0%</span>
            ${isOutOfStock ? `<span class="badge badge-stock" style="background: #ef4444; color: #fff;">Hết hàng</span>` : ''}
          </div>
          <img src="${p.image_url}" alt="${p.name}" loading="lazy" onclick="App.openProductModal(${p.id})" style="cursor: pointer;">
          <!-- Nút Xem Nhanh hiển thị mượt mà khi hover -->
          <button type="button" class="btn-quick-view" onclick="App.openProductModal(${p.id})" title="Xem nhanh thông số & đánh giá">
            <i class="fa-solid fa-eye"></i> Xem nhanh
          </button>
        </div>

        <div class="product-card-body">
          <div class="product-brand">${p.brand}</div>
          <h4 class="product-name" onclick="App.openProductModal(${p.id})">${p.name}</h4>

          <div class="product-price-row">
            <span class="current-price">${formattedPrice}</span>
            ${formattedOldPrice ? `<span class="original-price">${formattedOldPrice}</span>` : ''}
          </div>

          <div class="product-rating">
            <i class="fa-solid fa-star"></i>
            <strong>${p.rating || 5}</strong>
            <span style="color: #9ca3af; font-size: 0.75rem;">(${p.reviews_count || 0})</span>
            ${p.sold_count > 0 ? `<span class="product-sold-tag"><i class="fa-solid fa-fire" style="color: #f97316; font-size: 0.7rem;"></i> Đã bán ${p.sold_count >= 1000 ? (p.sold_count / 1000).toFixed(1) + 'k' : p.sold_count}</span>` : ''}
          </div>

          <div class="product-card-footer">
            ${isOutOfStock ? `
              <button class="btn-card-cart disabled" disabled style="opacity: 0.55; cursor: not-allowed; background: #e5e7eb; color: #9ca3af; border-color: #d1d5db;" title="Sản phẩm đã hết hàng">
                <i class="fa-solid fa-ban"></i> Hết hàng
              </button>
              <button class="btn-card-buy disabled" disabled style="opacity: 0.55; cursor: not-allowed; background: #9ca3af;" title="Sản phẩm đã hết hàng">
                Tạm hết
              </button>
            ` : `
              <button class="btn-card-cart" onclick="App.handleAddToCart(${p.id}, event)" title="Thêm vào giỏ">
                <i class="fa-solid fa-cart-plus"></i> <span class="btn-card-cart-text">Thêm giỏ</span>
              </button>
              <button class="btn-card-buy" onclick="App.handleBuyNow(${p.id})">
                Mua ngay
              </button>
            `}
          </div>
        </div>
      </div>
    `;
  },

  renderProductsGrid(products) {
    const grid = document.getElementById('productsGrid');
    if (!grid) return;

    if (!products || products.length === 0) {
      grid.innerHTML = `
        <div style="grid-column: 1/-1; text-align: center; padding: 50px 20px; background: #fff; border-radius: 10px; border: 1px dashed #d1d5db;">
          <i class="fa-solid fa-box-open" style="font-size: 3rem; color: #9ca3af; margin-bottom: 12px;"></i>
          <h3 style="font-size: 1.15rem; margin-bottom: 6px;">Không tìm thấy sản phẩm phù hợp</h3>
          <p style="color: #6b7280; font-size: 0.88rem;">Hãy thử chọn thương hiệu hoặc mức giá khác.</p>
          <button class="btn-primary" style="margin-top: 16px;" onclick="App.resetFilters()">
            <i class="fa-solid fa-rotate-left"></i> Xóa tất cả bộ lọc
          </button>
        </div>
      `;
      return;
    }

    grid.innerHTML = products.map(p => this.renderProductCardHTML(p)).join('');
  },

  renderPagination({ page, totalPages }) {
    const wrap = document.getElementById('paginationWrapper');
    if (!wrap) return;

    if (totalPages <= 1) {
      wrap.innerHTML = '';
      return;
    }

    let html = '';
    if (page > 1) {
      html += `<button class="btn-secondary" style="padding: 6px 12px;" onclick="App.goToPage(${page - 1})"><i class="fa-solid fa-chevron-left"></i> Trước</button>`;
    }

    for (let i = 1; i <= totalPages; i++) {
      html += `<button class="${i === page ? 'btn-primary' : 'btn-secondary'}" style="padding: 6px 14px; min-width: 36px;" onclick="App.goToPage(${i})">${i}</button>`;
    }

    if (page < totalPages) {
      html += `<button class="btn-secondary" style="padding: 6px 12px;" onclick="App.goToPage(${page + 1})">Sau <i class="fa-solid fa-chevron-right"></i></button>`;
    }

    wrap.innerHTML = `<div style="display: flex; gap: 6px; justify-content: center; margin-top: 30px;">${html}</div>`;
  },

  goToPage(p) {
    this.state.page = p;
    this.loadProducts();
    const catalogEl = document.getElementById('catalogSection');
    if (catalogEl) {
      window.scrollTo({ top: catalogEl.offsetTop - 70, behavior: 'smooth' });
    } else {
      const searchEl = document.getElementById('searchResultsSection');
      if (searchEl) window.scrollTo({ top: searchEl.offsetTop - 70, behavior: 'smooth' });
    }
  },

  // 5. Bộ lọc Hybrid: Brand Chips + Toolbar Price Pills + Sort
  bindFilters() {
    // Sắp xếp
    const sortSelect = document.getElementById('sortSelect');
    if (sortSelect) {
      sortSelect.addEventListener('change', (e) => {
        this.state.sort = e.target.value;
        this.state.page = 1;
        this.loadProducts();
      });
    }

    // Quick Brand Chips
    const quickBrandChips = document.querySelectorAll('#quickBrandChips .brand-chip');
    quickBrandChips.forEach(chip => {
      chip.addEventListener('click', () => {
        quickBrandChips.forEach(c => c.classList.remove('active'));
        chip.classList.add('active');
        const brand = chip.getAttribute('data-brand');
        this.state.brand = brand;
        this.state.page = 1;

        this.renderActiveFilterTags();
        this.loadProducts();
      });
    });

    // Quick Price Pills
    const quickPricePills = document.querySelectorAll('#quickPricePills .price-pill');
    quickPricePills.forEach(pill => {
      pill.addEventListener('click', () => {
        quickPricePills.forEach(p => p.classList.remove('active'));
        pill.classList.add('active');

        const range = pill.getAttribute('data-range');
        if (range === 'all') {
          this.state.minPrice = null;
          this.state.maxPrice = null;
        } else {
          const [min, max] = range.split('-');
          this.state.minPrice = min ? Number(min) : null;
          this.state.maxPrice = max ? Number(max) : null;
        }

        this.state.page = 1;
        this.renderActiveFilterTags();
        this.loadProducts();
      });
    });

    // Spec Chips lọc cấu hình nhanh (CPU, GPU, RAM, Màn hình...)
    const specChips = document.querySelectorAll('.spec-filter-chip');
    specChips.forEach(chip => {
      chip.addEventListener('click', () => {
        const type = chip.getAttribute('data-spec-type');
        const val = chip.getAttribute('data-spec-val');
        const row = chip.closest('.spec-chips-row') || chip.parentElement;

        if (chip.classList.contains('active')) {
          if (val !== 'all') {
            chip.classList.remove('active');
            row.querySelector(`.spec-filter-chip[data-spec-type="${type}"][data-spec-val="all"]`)?.classList.add('active');
            this.state[type] = null;
          }
        } else {
          row.querySelectorAll(`.spec-filter-chip[data-spec-type="${type}"]`).forEach(c => c.classList.remove('active'));
          chip.classList.add('active');
          this.state[type] = (val === 'all') ? null : val;
        }

        this.state.page = 1;
        this.renderActiveFilterTags();
        this.loadProducts();
      });
    });

    // Nút xóa tất cả tag lọc
    const clearAllBtn = document.getElementById('btnClearAllFilters');
    if (clearAllBtn) {
      clearAllBtn.addEventListener('click', () => this.resetFilters());
    }
  },

  // 5c. Hiển thị thanh Active Filter Tags & Badge đếm
  renderActiveFilterTags() {
    const bar = document.getElementById('activeFilterTagsBar');
    const list = document.getElementById('activeFilterTagsList');
    const badge = document.getElementById('activeFilterBadge');
    if (!bar || !list) return;

    const tags = [];

    // Danh mục
    if (this.state.category && this.state.category !== 'all' && !this.pageCategory) {
      const catObj = this.categoriesList.find(c => c.slug === this.state.category);
      const catName = catObj ? catObj.name : this.state.category;
      tags.push({
        type: 'category',
        label: `Danh mục: ${catName}`,
        onRemove: () => {
          this.state.category = 'all';
          this.syncNavbarCategory();
        }
      });
    }

    // Thương hiệu
    if (this.state.brand && this.state.brand !== 'all') {
      tags.push({
        type: 'brand',
        label: `Thương hiệu: ${this.state.brand}`,
        onRemove: () => {
          this.state.brand = 'all';
          const quickChip = document.querySelector('#quickBrandChips .brand-chip[data-brand="all"]');
          if (quickChip) {
            document.querySelectorAll('#quickBrandChips .brand-chip').forEach(c => c.classList.remove('active'));
            quickChip.classList.add('active');
          }
        }
      });
    }

    // Cấu hình kỹ thuật (CPU, GPU, RAM, Ổ cứng, Màn hình, Tính năng, Kết nối)
    const specLabels = {
      cpu: 'CPU/Chip',
      gpu: 'Card đồ họa',
      ram: 'RAM',
      storage: 'Bộ nhớ/Ổ cứng',
      screen: 'Màn hình/Kích thước',
      feature: 'Tính năng',
      connection: 'Kết nối',
      component_type: 'Loại linh kiện'
    };
    ['cpu', 'gpu', 'ram', 'storage', 'screen', 'feature', 'connection', 'component_type'].forEach(type => {
      if (this.state[type]) {
        tags.push({
          type: type,
          label: `${specLabels[type]}: ${this.state[type]}`,
          onRemove: () => {
            this.state[type] = null;
            const barRow = document.querySelector(`.spec-filter-chip[data-spec-type="${type}"]`)?.closest('.spec-chips-row');
            if (barRow) {
              barRow.querySelectorAll(`.spec-filter-chip[data-spec-type="${type}"]`).forEach(c => c.classList.remove('active'));
              barRow.querySelector(`.spec-filter-chip[data-spec-type="${type}"][data-spec-val="all"]`)?.classList.add('active');
            }
          }
        });
      }
    });

    // Mức giá
    if (this.state.minPrice || this.state.maxPrice) {
      let priceLabel = 'Giá: ';
      if (this.state.minPrice && this.state.maxPrice) {
        priceLabel += `${new Intl.NumberFormat('vi-VN').format(this.state.minPrice)}₫ - ${new Intl.NumberFormat('vi-VN').format(this.state.maxPrice)}₫`;
      } else if (this.state.minPrice) {
        priceLabel += `Từ ${new Intl.NumberFormat('vi-VN').format(this.state.minPrice)}₫`;
      } else {
        priceLabel += `Dưới ${new Intl.NumberFormat('vi-VN').format(this.state.maxPrice)}₫`;
      }

      tags.push({
        type: 'price',
        label: priceLabel,
        onRemove: () => {
          this.state.minPrice = null;
          this.state.maxPrice = null;
          const defaultPill = document.querySelector('#quickPricePills .price-pill[data-range="all"]');
          if (defaultPill) {
            document.querySelectorAll('#quickPricePills .price-pill').forEach(p => p.classList.remove('active'));
            defaultPill.classList.add('active');
          }
        }
      });
    }

    // Đánh giá
    if (this.state.minRating) {
      tags.push({
        type: 'rating',
        label: `Đánh giá: Từ ${this.state.minRating} sao`,
        onRemove: () => {
          this.state.minRating = null;
        }
      });
    }

    // Tìm kiếm
    if (this.state.search) {
      tags.push({
        type: 'search',
        label: `Từ khóa: "${this.state.search}"`,
        onRemove: () => {
          this.state.search = '';
          const searchInput = document.getElementById('mainSearchInput');
          if (searchInput) searchInput.value = '';
        }
      });
    }

    // Cập nhật Badge đếm
    if (badge) {
      if (tags.length > 0) {
        badge.textContent = tags.length;
        badge.style.display = 'inline-flex';
      } else {
        badge.style.display = 'none';
      }
    }

    // Render bar
    if (tags.length > 0) {
      bar.style.display = 'flex';
      list.innerHTML = tags.map((t, idx) => `
        <span class="active-filter-tag" data-tag-idx="${idx}">
          <span>${t.label}</span>
          <button type="button" class="btn-remove-tag" data-tag-idx="${idx}">&times;</button>
        </span>
      `).join('');

      list.querySelectorAll('.btn-remove-tag').forEach(btn => {
        btn.addEventListener('click', (e) => {
          e.stopPropagation();
          const idx = Number(btn.getAttribute('data-tag-idx'));
          if (tags[idx] && tags[idx].onRemove) {
            tags[idx].onRemove();
            this.state.page = 1;
            this.renderActiveFilterTags();
            this.loadProducts();
          }
        });
      });
    } else {
      bar.style.display = 'none';
      list.innerHTML = '';
    }
  },

  resetFilters() {
    this.state.category = this.pageCategory || 'all';
    this.state.brand = 'all';
    this.state.minPrice = null;
    this.state.maxPrice = null;
    this.state.minRating = null;
    this.state.cpu = null;
    this.state.gpu = null;
    this.state.ram = null;
    this.state.storage = null;
    this.state.screen = null;
    this.state.feature = null;
    this.state.connection = null;
    this.state.component_type = null;
    this.state.sort = 'newest';
    this.state.search = '';
    this.state.page = 1;

    // Reset Top Navbar nếu ở trang chủ
    if (!this.pageCategory) {
      document.querySelectorAll('.vts-menu-link').forEach(b => b.classList.remove('active'));
      document.querySelector('.vts-menu-link[data-cat="all"]')?.classList.add('active');
    }

    // Reset Quick Brand Chips
    document.querySelectorAll('#quickBrandChips .brand-chip').forEach(b => b.classList.remove('active'));
    document.querySelector('#quickBrandChips .brand-chip[data-brand="all"]')?.classList.add('active');

    // Reset Quick Price Pills
    document.querySelectorAll('#quickPricePills .price-pill').forEach(p => p.classList.remove('active'));
    document.querySelector('#quickPricePills .price-pill[data-range="all"]')?.classList.add('active');

    // Reset Spec Chips
    ['cpu', 'gpu', 'ram', 'storage', 'screen', 'feature', 'connection', 'component_type'].forEach(type => {
      document.querySelectorAll(`.spec-filter-chip[data-spec-type="${type}"]`).forEach(c => c.classList.remove('active'));
      document.querySelector(`.spec-filter-chip[data-spec-type="${type}"][data-spec-val="all"]`)?.classList.add('active');
    });

    // Reset Search & Sort
    const searchInput = document.getElementById('mainSearchInput');
    if (searchInput) searchInput.value = '';
    const sortSelect = document.getElementById('sortSelect');
    if (sortSelect) sortSelect.value = 'newest';

    this.renderActiveFilterTags();
    this.loadProducts();
    showToast('Đã đặt lại toàn bộ bộ lọc', 'info');
  },

  // 5. Tìm kiếm trực tiếp thông minh (Live Search Dropdown) & Kết quả tìm kiếm
  ensureLiveSearchDropdown() {
    if (this.pageCategory) return null; // Chỉ áp dụng riêng cho trang chủ index.html
    let dropdown = document.getElementById('liveSearchDropdown');
    if (!dropdown) {
      const wrapper = document.querySelector('.search-wrapper');
      if (wrapper) {
        dropdown = document.createElement('div');
        dropdown.id = 'liveSearchDropdown';
        dropdown.className = 'live-search-dropdown';
        wrapper.appendChild(dropdown);
      }
    }
    return dropdown;
  },

  closeLiveSearch() {
    const dropdown = document.getElementById('liveSearchDropdown');
    if (dropdown) dropdown.classList.remove('show');
  },

  highlightSearchTerm(text, term) {
    if (!text || !term) return text || '';
    const regex = new RegExp(`(${term.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, 'gi');
    return text.replace(regex, '<span class="search-highlight">$1</span>');
  },

  async fetchLiveSearchResults(query) {
    const dropdown = this.ensureLiveSearchDropdown();
    if (!dropdown) return;

    dropdown.innerHTML = `
      <div style="padding: 20px; text-align: center; color: #6b7280; font-size: 0.84rem;">
        <i class="fa-solid fa-spinner fa-spin" style="margin-right: 8px; color: var(--vt-red);"></i> Đang tìm kiếm sản phẩm...
      </div>
    `;
    dropdown.classList.add('show');

    try {
      const res = await fetch(`/api/products?search=${encodeURIComponent(query)}&limit=5`);
      const data = await res.json();

      // Kiểm tra nếu người dùng đã gõ từ khóa khác trong lúc chờ fetch
      const currentInput = document.getElementById('mainSearchInput');
      if (currentInput && currentInput.value.trim() && currentInput.value.trim().toLowerCase() !== query.toLowerCase()) return;

      if (!data.success || !data.data || !data.data.products || data.data.products.length === 0) {
        dropdown.innerHTML = `
          <div class="live-search-empty">
            <i class="fa-solid fa-magnifying-glass"></i>
            <p>Không tìm thấy sản phẩm nào khớp với "<strong>${query}</strong>"</p>
            <small>Hãy thử tìm bằng từ khóa chung hơn như: iPhone, Laptop, Tablet, Tai nghe...</small>
          </div>
        `;
        return;
      }

      const products = data.data.products;
      const total = data.data.total;

      const itemsHtml = products.map(p => {
        const discount = p.original_price > p.price ? Math.round(((p.original_price - p.price) / p.original_price) * 100) : 0;
        const formattedPrice = new Intl.NumberFormat('vi-VN').format(p.price) + '₫';
        const formattedOldPrice = p.original_price > p.price ? new Intl.NumberFormat('vi-VN').format(p.original_price) + '₫' : '';
        const highlightedName = this.highlightSearchTerm(p.name, query);

        return `
          <div class="live-search-item" onclick="App.openProductModal(${p.id}); App.closeLiveSearch();">
            <img class="live-search-thumb" src="${p.image_url}" alt="${p.name}" onerror="this.src='https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=150&q=80';">
            <div class="live-search-info">
              <div class="live-search-name">${highlightedName}</div>
              <div class="live-search-meta">
                <span class="live-search-price">${formattedPrice}</span>
                ${formattedOldPrice ? `<span class="live-search-original-price">${formattedOldPrice}</span>` : ''}
                ${discount > 0 ? `<span class="live-search-discount">-${discount}%</span>` : ''}
                <span class="live-search-brand-tag">${p.brand || 'Chính hãng'}</span>
              </div>
            </div>
          </div>
        `;
      }).join('');

      dropdown.innerHTML = `
        <div class="live-search-header">
          <span>Gợi ý sản phẩm (${total})</span>
          <span style="font-size: 0.72rem; color: #9ca3af;">Bấm để xem nhanh</span>
        </div>
        <div class="live-search-list">
          ${itemsHtml}
        </div>
        <div class="live-search-footer">
          <button type="button" class="btn-live-search-all" onclick="App.handleSearchSubmit();">
            <span>Xem tất cả <strong>${total}</strong> kết quả cho "<em>${query}</em>"</span>
            <i class="fa-solid fa-arrow-right"></i>
          </button>
        </div>
      `;
    } catch (e) {
      console.error('Lỗi Live Search:', e);
      dropdown.innerHTML = `
        <div class="live-search-empty">
          <p style="color: #dc2626;">Lỗi kết nối khi tìm kiếm. Vui lòng thử lại.</p>
        </div>
      `;
    }
  },

  handleSearchSubmit() {
    const input = document.getElementById('mainSearchInput');
    const query = input ? input.value.trim() : '';
    if (!query) return;
    this.closeLiveSearch();
    this.submitSearch(query);
  },

  async submitSearch(query) {
    if (!query) return;
    this.closeLiveSearch();

    // 1. Nếu đang ở các trang danh mục chuyên biệt (tablet.html, laptop.html,...), chuyển hướng về trang chủ kèm param ?search=
    if (this.pageCategory) {
      window.location.href = `/?search=${encodeURIComponent(query)}`;
      return;
    }

    // 2. Nếu đang ở trang chủ index.html, hiển thị ngay khối #searchResultsSection
    const searchSection = document.getElementById('searchResultsSection');
    const labelEl = document.getElementById('searchKeywordLabel');
    if (labelEl) labelEl.textContent = `"${query}"`;

    if (searchSection) {
      searchSection.style.display = 'block';
    }

    const input = document.getElementById('mainSearchInput');
    if (input) input.value = query;

    this.state.search = query;
    this.state.category = 'all';
    this.state.brand = 'all';
    this.state.page = 1;

    // Cập nhật URL trình duyệt (không reload)
    window.history.replaceState(null, '', `/?search=${encodeURIComponent(query)}`);

    // Tải dữ liệu tìm kiếm
    await this.loadProducts();

    // Cuộn mượt mà đến vùng kết quả
    if (searchSection) {
      const topOffset = searchSection.getBoundingClientRect().top + window.scrollY - 70;
      window.scrollTo({ top: topOffset, behavior: 'smooth' });
    }
  },

  clearSearchMode() {
    const searchSection = document.getElementById('searchResultsSection');
    if (searchSection) searchSection.style.display = 'none';

    this.state.search = '';
    const input = document.getElementById('mainSearchInput');
    if (input) input.value = '';

    window.history.replaceState(null, '', window.location.pathname);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  },

  bindSearch() {
    const input = document.getElementById('mainSearchInput');
    if (!input) return;

    // Nếu ở các trang danh mục riêng biệt (smartphone, tablet, laptop, v.v.), giữ nguyên logic cũ 100%
    if (this.pageCategory) {
      let timeout = null;
      input.addEventListener('input', (e) => {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
          this.state.search = e.target.value.trim();
          this.state.page = 1;
          this.loadProducts();
        }, 350);
      });
      return;
    }

    // CHỈ ÁP DỤNG RIÊNG CHO TRANG CHỦ INDEX.HTML:
    let searchTimeout = null;
    input.addEventListener('input', (e) => {
      clearTimeout(searchTimeout);
      const query = e.target.value.trim();

      if (!query) {
        this.closeLiveSearch();
        return;
      }

      searchTimeout = setTimeout(() => {
        this.fetchLiveSearchResults(query);
      }, 220);
    });

    input.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault();
        this.handleSearchSubmit();
      } else if (e.key === 'Escape') {
        this.closeLiveSearch();
      }
    });

    const searchIcon = document.getElementById('mainSearchIcon') || input.parentElement?.querySelector('.search-icon');
    if (searchIcon) {
      searchIcon.addEventListener('click', (e) => {
        e.stopPropagation();
        this.handleSearchSubmit();
      });
    }

    // Đóng dropdown khi click ra ngoài
    document.addEventListener('click', (e) => {
      if (!e.target.closest('.search-wrapper')) {
        this.closeLiveSearch();
      }
    });
  },

  // 6. Chi tiết sản phẩm, Đánh giá (Khách đã mua) & Hỏi đáp (Cộng đồng)
  bindModals() {
    const modal = document.getElementById('productDetailModal');
    const closeBtn = document.getElementById('closeDetailModalBtn');

    if (closeBtn) {
      closeBtn.addEventListener('click', () => modal.classList.remove('active'));
    }

    modal?.addEventListener('click', (e) => {
      if (e.target === modal) modal.classList.remove('active');
    });

    const questionForm = document.getElementById('newQuestionForm');
    if (questionForm) {
      questionForm.addEventListener('submit', (e) => this.handleNewQuestionSubmit(e));
    }

    // Đóng user dropdown khi click ra ngoài
    document.addEventListener('click', (e) => {
      const wrapper = document.getElementById('userMenuWrapper');
      if (wrapper && !wrapper.contains(e.target)) {
        this.closeUserDropdown();
      }
    });
  },

  // Bộ lọc nâng cao accordion mở rộng từ trên xuống (Desktop) hoặc Bottom Sheet Modal (Mobile)
  bindAccordionFilters() {
    const btn = document.getElementById('btnToggleAdvancedFilters');
    const panel = document.getElementById('advancedFiltersPanel');
    if (!btn || !panel) return;

    // Đảm bảo nút đóng và footer áp dụng bộ lọc trên mobile được khởi tạo
    const headerRow = panel.querySelector('.panel-header-row');
    if (headerRow && !headerRow.querySelector('.btn-close-filter-sheet')) {
      const closeBtn = document.createElement('button');
      closeBtn.type = 'button';
      closeBtn.className = 'btn-close-filter-sheet';
      closeBtn.innerHTML = '&times;';
      closeBtn.title = 'Đóng bộ lọc';
      closeBtn.onclick = (e) => {
        e.stopPropagation();
        this.closeAdvancedFilterSheet();
      };
      headerRow.appendChild(closeBtn);
    }

    if (!panel.querySelector('.mobile-filter-footer')) {
      const mobileFooter = document.createElement('div');
      mobileFooter.className = 'mobile-filter-footer';
      mobileFooter.innerHTML = `
        <button type="button" class="btn-filter-sheet-reset" onclick="App.resetFilters()">
          <i class="fa-solid fa-rotate-left"></i> Đặt lại
        </button>
        <button type="button" class="btn-filter-sheet-apply" onclick="App.closeAdvancedFilterSheet()">
          <i class="fa-solid fa-check"></i> Xem kết quả
        </button>
      `;
      panel.appendChild(mobileFooter);
    }

    let backdrop = document.getElementById('filterBackdrop');
    if (!backdrop) {
      backdrop = document.createElement('div');
      backdrop.id = 'filterBackdrop';
      backdrop.className = 'filter-backdrop';
      document.body.appendChild(backdrop);
      backdrop.addEventListener('click', () => {
        this.closeAdvancedFilterSheet();
      });
    }

    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      const isOpen = panel.classList.toggle('open');
      btn.classList.toggle('active', isOpen);
      const icon = btn.querySelector('.toggle-icon');
      if (icon) {
        icon.className = isOpen ? 'fa-solid fa-chevron-up toggle-icon' : 'fa-solid fa-chevron-down toggle-icon';
      }
      if (backdrop) backdrop.classList.toggle('show', isOpen);
    });
  },

  closeAdvancedFilterSheet() {
    const btn = document.getElementById('btnToggleAdvancedFilters');
    const panel = document.getElementById('advancedFiltersPanel');
    const backdrop = document.getElementById('filterBackdrop');
    if (panel) panel.classList.remove('open');
    if (btn) btn.classList.remove('active');
    if (backdrop) backdrop.classList.remove('show');
    const icon = btn?.querySelector('.toggle-icon');
    if (icon) icon.className = 'fa-solid fa-chevron-down toggle-icon';

    if (window.innerWidth <= 768) {
      const catalog = document.getElementById('catalogSection') || document.querySelector('.catalog-card-wrapper');
      if (catalog) {
        catalog.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    }
  },

  switchInteractionTab(tab) {
    const btnReviews = document.getElementById('tabBtnReviews');
    const btnQuestions = document.getElementById('tabBtnQuestions');
    const contentReviews = document.getElementById('tabContentReviews');
    const contentQuestions = document.getElementById('tabContentQuestions');

    if (tab === 'reviews') {
      btnReviews?.classList.add('active');
      btnQuestions?.classList.remove('active');
      if (contentReviews) contentReviews.style.display = 'block';
      if (contentQuestions) contentQuestions.style.display = 'none';
    } else {
      btnQuestions?.classList.add('active');
      btnReviews?.classList.remove('active');
      if (contentQuestions) contentQuestions.style.display = 'block';
      if (contentReviews) contentReviews.style.display = 'none';
    }
  },

  async openProductModal(productId) {
    const modal = document.getElementById('productDetailModal');
    if (!modal) return;

    this.activeProductId = productId;

    // Reset về Tab Đánh giá
    this.switchInteractionTab('reviews');

    try {
      const res = await fetch(`/api/products/${productId}`);
      const data = await res.json();
      if (!data.success) throw new Error(data.message);

      const p = data.data;
      this.activeProduct = p;

      // Trích xuất cấu hình / biến thể (Variants)
      let variants = [];
      if (Array.isArray(p.variants) && p.variants.length > 0) {
        variants = p.variants;
      } else if (p.specifications && Array.isArray(p.specifications.variants) && p.specifications.variants.length > 0) {
        variants = p.specifications.variants;
      }
      this.activeProductVariants = variants;
      this.selectedVariant = variants.length > 0 ? variants[0] : null;

      // Danh mục, tên, mô tả
      const catEl = document.getElementById('detailCategory');
      if (catEl) catEl.textContent = p.category_name || p.brand;
      const titleEl = document.getElementById('detailTitle');
      if (titleEl) titleEl.textContent = p.name;
      const descEl = document.getElementById('detailDescription');
      if (descEl) descEl.textContent = p.short_description || '';
      const ratingEl = document.getElementById('detailRating');
      if (ratingEl) ratingEl.textContent = p.rating || 5;
      const rCountEl = document.getElementById('detailReviewCount');
      if (rCountEl) rCountEl.textContent = p.reviews_count || 0;

      // Giá và kho (Ưu tiên theo variant đầu tiên nếu có, đồng thời giới hạn bởi tổng tồn kho thực tế p.stock)
      const currentPrice = this.selectedVariant ? this.selectedVariant.price : p.price;
      const currentOriginal = this.selectedVariant ? (this.selectedVariant.original_price || 0) : p.original_price;
      const vStock = (this.selectedVariant && typeof this.selectedVariant.stock === 'number')
        ? Math.min(this.selectedVariant.stock, Number(p.stock))
        : Number(p.stock || 0);
      const currentStock = Math.max(0, vStock);

      const priceEl = document.getElementById('detailPrice');
      if (priceEl) priceEl.textContent = new Intl.NumberFormat('vi-VN').format(currentPrice) + '₫';
      const oldPriceEl = document.getElementById('detailOldPrice');
      if (oldPriceEl) {
        oldPriceEl.textContent = currentOriginal > currentPrice ? new Intl.NumberFormat('vi-VN').format(currentOriginal) + '₫' : '';
      }

      const stockEl = document.getElementById('detailStock');
      if (stockEl) {
        stockEl.textContent = currentStock > 0 ? `Còn hàng (${currentStock} máy)` : 'Tạm hết hàng';
        stockEl.style.color = currentStock > 0 ? '#059669' : '#dc2626';
      }

      const soldEl = document.getElementById('detailSoldCount');
      if (soldEl) {
        const sold = p.sold_count || 0;
        soldEl.textContent = sold > 0 ? `Đã bán ${sold >= 1000 ? (sold / 1000).toFixed(1) + 'k' : sold}` : 'Mới mở bán';
      }

      // Hình ảnh chính và thư viện ảnh nhiều demo
      let allImages = [];
      if (Array.isArray(p.images) && p.images.length > 0) {
        allImages = p.images;
      } else if (typeof p.images === 'string') {
        try { allImages = JSON.parse(p.images); } catch (e) { allImages = [p.images]; }
      } else if (p.specifications && Array.isArray(p.specifications.demo_images)) {
        allImages = p.specifications.demo_images;
      }
      if (!allImages.includes(p.image_url)) {
        allImages.unshift(p.image_url);
      }
      allImages = [...new Set(allImages.filter(Boolean))];

      const mainImg = document.getElementById('detailMainImg');
      if (mainImg) mainImg.src = allImages[0] || p.image_url;

      const thumbsContainer = document.getElementById('detailThumbnails');
      if (thumbsContainer) {
        thumbsContainer.innerHTML = allImages.map((img, idx) => `
          <div class="thumb-item ${idx === 0 ? 'active' : ''}" onclick="App.changeDetailImg('${img}', this)">
            <img src="${img}" alt="${p.name}">
          </div>
        `).join('');
      }

      // Render bộ chọn phiên bản / cấu hình (RAM/SSD/Bộ nhớ)
      this.renderProductVariantsSelector(variants, p);

      // Thông số kỹ thuật
      const specsTable = document.getElementById('detailSpecsTable');
      if (specsTable) {
        if (p.specifications && Object.keys(p.specifications).length > 0) {
          const specEntries = Object.entries(p.specifications).filter(([k]) => k !== 'variants' && k !== 'demo_images');
          if (specEntries.length > 0) {
            specsTable.innerHTML = specEntries.map(([key, val]) => `
              <tr>
                <td>${key}</td>
                <td><strong>${typeof val === 'object' ? JSON.stringify(val) : val}</strong></td>
              </tr>
            `).join('');
          } else {
            specsTable.innerHTML = '<tr><td colspan="2" style="text-align: center; color: #9ca3af;">Đang cập nhật thông số</td></tr>';
          }
        } else {
          specsTable.innerHTML = '<tr><td colspan="2" style="text-align: center; color: #9ca3af;">Đang cập nhật thông số</td></tr>';
        }
      }

      const qtyInput = document.getElementById('detailQtyInput');
      if (qtyInput) {
        qtyInput.value = 1;
        qtyInput.max = currentStock;
        qtyInput.onchange = () => {
          const activeStock = (this.selectedVariant && this.selectedVariant.stock !== undefined)
            ? Number(this.selectedVariant.stock)
            : Number(p.stock || 999);
          let val = Number(qtyInput.value) || 1;
          if (val < 1) val = 1;
          if (val > activeStock) {
            val = Math.max(1, activeStock);
            showToast(`Số lượng tối đa có thể chọn là ${activeStock} sản phẩm!`, 'info');
          }
          qtyInput.value = val;
        };
      }

      // Cập nhật trạng thái nút mua / thêm giỏ
      this.updateDetailActionButtons(currentStock);

      const addBtn = document.getElementById('detailAddCartBtn');
      const buyBtn = document.getElementById('detailBuyNowBtn');

      if (addBtn) {
        addBtn.onclick = () => {
          const activeStock = this.selectedVariant ? Math.min(Number(this.selectedVariant.stock), Number(p.stock)) : Number(p.stock || 0);
          if (activeStock <= 0) {
            showToast('Phiên bản này tạm thời đã hết hàng!', 'error');
            return;
          }
          let qty = Number(document.getElementById('detailQtyInput')?.value) || 1;
          if (qty > activeStock) {
            qty = activeStock;
            if (qtyInput) qtyInput.value = qty;
          }
          const resAdd = Cart.addItem(p, qty, this.selectedVariant);
          if (!resAdd.success) {
            showToast(resAdd.message, 'error');
            return;
          }
          const currentImg = document.getElementById('detailMainImg');
          if (currentImg) this.flyToCartAnimation(currentImg);
          const varLabel = this.selectedVariant ? ` (${this.selectedVariant.name})` : '';
          showToast(`Đã thêm ${qty} x "${p.name}${varLabel}" vào giỏ hàng!`);
        };
      }

      if (buyBtn) {
        buyBtn.onclick = () => {
          const activeStock = this.selectedVariant ? Math.min(Number(this.selectedVariant.stock), Number(p.stock)) : Number(p.stock || 0);
          if (activeStock <= 0) {
            showToast('Phiên bản này tạm thời đã hết hàng!', 'error');
            return;
          }
          let qty = Number(document.getElementById('detailQtyInput')?.value) || 1;
          if (qty > activeStock) {
            qty = activeStock;
            if (qtyInput) qtyInput.value = qty;
          }
          const resAdd = Cart.addItem(p, qty, this.selectedVariant);
          if (!resAdd.success) {
            showToast(resAdd.message, 'error');
            return;
          }
          modal.classList.remove('active');
          Checkout.openModal();
        };
      }

      // Tự động điền họ tên vào form câu hỏi nếu đã đăng nhập
      const qAuthorInput = document.getElementById('questionAuthorName');
      if (qAuthorInput) {
        qAuthorInput.value = this.currentUser ? this.currentUser.name : '';
      }

      // Tải danh sách đánh giá từ khách hàng đã mua
      this.loadProductReviews(p.id);

      // Kiểm tra quyền hạn đánh giá (chỉ tài khoản đã mua, cho phép cập nhật nếu đã đánh giá)
      this.checkAndRenderReviewPermission(p.id);

      // Tải danh sách hỏi đáp thảo luận về sản phẩm
      this.loadProductQuestions(p.id);

      modal.classList.add('active');
    } catch (e) {
      showToast('Không thể tải chi tiết sản phẩm: ' + e.message, 'error');
    }
  },

  renderProductVariantsSelector(variants, product) {
    let container = document.getElementById('detailVariantsContainer');
    if (!container) {
      const priceBox = document.querySelector('.detail-price-box');
      if (priceBox) {
        container = document.createElement('div');
        container.id = 'detailVariantsContainer';
        container.className = 'product-variants-container';
        priceBox.parentNode.insertBefore(container, priceBox.nextSibling);
      }
    }

    if (!container) return;

    if (!variants || variants.length === 0) {
      container.style.display = 'none';
      container.innerHTML = '';
      return;
    }

    container.style.display = 'block';
    container.innerHTML = `
      <div class="variants-label"><i class="fa-solid fa-layer-group"></i> Chọn cấu hình / Phiên bản:</div>
      <div class="variants-list">
        ${variants.map((v, i) => `
          <div class="variant-chip ${i === 0 ? 'active' : ''}" data-idx="${i}" onclick="App.selectProductVariant(${i})">
            <span class="variant-name">${v.name}</span>
            <span class="variant-price">${new Intl.NumberFormat('vi-VN').format(v.price)}₫</span>
          </div>
        `).join('')}
      </div>
    `;
  },

  selectProductVariant(idx) {
    if (!this.activeProduct || !this.activeProductVariants || !this.activeProductVariants[idx]) return;
    const variant = this.activeProductVariants[idx];
    this.selectedVariant = variant;

    // Cập nhật trạng thái class active
    const chips = document.querySelectorAll('#detailVariantsContainer .variant-chip');
    chips.forEach((c, i) => {
      c.classList.toggle('active', i === idx);
    });

    // Cập nhật giá bán hiển thị
    const priceEl = document.getElementById('detailPrice');
    if (priceEl) priceEl.textContent = new Intl.NumberFormat('vi-VN').format(variant.price) + '₫';

    const oldPriceEl = document.getElementById('detailOldPrice');
    if (oldPriceEl) {
      oldPriceEl.textContent = (variant.original_price && variant.original_price > variant.price)
        ? new Intl.NumberFormat('vi-VN').format(variant.original_price) + '₫' : '';
    }

    // Cập nhật tồn kho hiển thị (giới hạn bởi tổng tồn kho thực tế của sản phẩm)
    const stockEl = document.getElementById('detailStock');
    const vStock = (typeof variant.stock === 'number')
      ? Math.min(variant.stock, Number(this.activeProduct.stock))
      : Number(this.activeProduct.stock || 0);
    const currentStock = Math.max(0, vStock);
    if (stockEl) {
      stockEl.textContent = currentStock > 0 ? `Còn hàng (${currentStock} máy)` : 'Tạm hết hàng';
      stockEl.style.color = currentStock > 0 ? '#059669' : '#dc2626';
    }

    // Giới hạn số lượng chọn tối đa theo biến thể
    const qtyInput = document.getElementById('detailQtyInput');
    if (qtyInput) {
      qtyInput.max = currentStock;
      if (Number(qtyInput.value) > currentStock) {
        qtyInput.value = Math.max(1, currentStock);
      }
    }

    // Cập nhật disabled trạng thái nút mua
    this.updateDetailActionButtons(currentStock);
  },

  updateDetailActionButtons(stock) {
    const addBtn = document.getElementById('detailAddCartBtn');
    const buyBtn = document.getElementById('detailBuyNowBtn');
    const isOutOfStock = stock <= 0;

    if (addBtn) {
      addBtn.disabled = isOutOfStock;
      addBtn.classList.toggle('disabled', isOutOfStock);
      addBtn.innerHTML = isOutOfStock ? '<i class="fa-solid fa-ban"></i> Tạm hết hàng' : '<i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ';
    }
    if (buyBtn) {
      buyBtn.disabled = isOutOfStock;
      buyBtn.classList.toggle('disabled', isOutOfStock);
      buyBtn.innerHTML = isOutOfStock ? 'Hết hàng' : 'Mua ngay';
    }
  },

  changeDetailImg(url, el) {
    document.getElementById('detailMainImg').src = url;
    document.querySelectorAll('.thumb-item').forEach(t => t.classList.remove('active'));
    el.classList.add('active');
  },

  adjustDetailQty(delta) {
    const input = document.getElementById('detailQtyInput');
    if (!input) return;
    const vStock = (this.selectedVariant && this.selectedVariant.stock !== undefined) ? Number(this.selectedVariant.stock) : 999;
    const pStock = (this.activeProduct && this.activeProduct.stock !== undefined) ? Number(this.activeProduct.stock) : 999;
    const activeStock = Math.min(vStock, pStock);

    if (activeStock <= 0) {
      input.value = 1;
      if (typeof showToast === 'function') {
        showToast('Sản phẩm tạm thời đã hết hàng!', 'error');
      }
      return;
    }

    let val = Number(input.value) + delta;
    if (val < 1) val = 1;
    if (val > activeStock) {
      val = Math.max(1, activeStock);
      if (typeof showToast === 'function') {
        showToast(`Số lượng tối đa có thể chọn là ${activeStock} sản phẩm!`, 'info');
      }
    }
    input.value = val;
  },

  /**
   * Kiểm tra quyền hạn đánh giá của tài khoản hiện tại đối với sản phẩm
   */
  async checkAndRenderReviewPermission(productId) {
    const container = document.getElementById('reviewActionContainer');
    if (!container) return;

    if (!this.currentUser) {
      container.innerHTML = `
        <div class="review-locked-box">
          <div class="review-locked-icon"><i class="fa-solid fa-lock"></i></div>
          <div class="review-locked-content" style="flex: 1;">
            <h5>Đăng nhập để gửi đánh giá</h5>
            <p>Đánh giá chấm sao dành riêng cho khách hàng đã mua sản phẩm này tại hệ thống. Vui lòng đăng nhập để hệ thống xác thực đơn hàng của bạn.</p>
          </div>
          <a href="/login.html" class="btn-primary" style="padding: 8px 16px; font-size: 0.82rem; white-space: nowrap; text-decoration: none;">
            <i class="fa-solid fa-right-to-bracket"></i> Đăng nhập ngay
          </a>
        </div>
      `;
      return;
    }

    container.innerHTML = '<div style="color: #6b7280; font-size: 0.85rem; padding: 10px 0;"><i class="fa-solid fa-spinner fa-spin"></i> Đang xác thực đơn mua hàng...</div>';

    try {
      const q = new URLSearchParams({
        userId: this.currentUser.id || '',
        email: this.currentUser.email || '',
        phone: this.currentUser.phone || '',
        userName: this.currentUser.name || ''
      });
      const res = await fetch(`/api/products/${productId}/review-permission?${q}`);
      const data = await res.json();

      if (!data.success) throw new Error(data.message);

      const { hasPurchased, hasReviewed, existingReview, purchaseInfo } = data.data;

      if (!hasPurchased) {
        // Tài khoản chưa mua sản phẩm này
        container.innerHTML = `
          <div class="review-locked-box not-purchased">
            <div class="review-locked-icon"><i class="fa-solid fa-circle-info"></i></div>
            <div class="review-locked-content" style="flex: 1;">
              <h5>Tài khoản của bạn chưa mua sản phẩm này</h5>
              <p>Đánh giá và chấm sao chỉ dành cho khách hàng đã có đơn mua sản phẩm <strong>thực tế</strong> để đảm bảo sự trung thực và minh bạch.</p>
              <p style="margin-top: 6px; color: var(--vt-red); font-weight: 700; font-size: 0.84rem;">
                👉 Bạn chưa mua và cần tư vấn? Hãy bấm sang tab <button type="button" onclick="App.switchInteractionTab('questions')" style="background: none; border: none; padding: 0; text-decoration: underline; color: var(--vt-red); font-weight: 800; cursor: pointer; font-size: inherit; font-family: inherit;">Hỏi đáp người đã mua</button> để đặt câu hỏi trực tiếp cho những người đã trải nghiệm nhé!
              </p>
            </div>
          </div>
        `;
      } else {
        // Tài khoản ĐÃ MUA sản phẩm
        const initialRating = existingReview ? existingReview.rating : 5;
        const initialComment = existingReview ? existingReview.comment : '';
        const orderNotice = purchaseInfo ? ` (Mã đơn: ${purchaseInfo.order_code})` : '';

        container.innerHTML = `
          <form class="review-form" id="newReviewForm">
            <input type="hidden" id="reviewProductId" value="${productId}">
            <input type="hidden" id="selectedRatingInput" value="${initialRating}">

            ${hasReviewed ? `
              <div class="review-existing-badge">
                <i class="fa-solid fa-pen-to-square"></i>
                <div>
                  <strong>Bạn đã đánh giá sản phẩm này trước đó:</strong>
                  <span>Hệ thống cho phép bạn cập nhật lại số sao và nhận xét bất kỳ lúc nào (không tạo đánh giá trùng lặp).</span>
                </div>
              </div>
            ` : `
              <div class="review-verified-badge">
                <i class="fa-solid fa-certificate"></i>
                <span>Tài khoản xác thực: Bạn đã mua sản phẩm này tại TechStore${orderNotice}</span>
              </div>
            `}

            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px;">
              <div style="font-size: 0.85rem; font-weight: 700;">Chấm điểm sản phẩm:</div>
              <div class="star-rating-select" id="starRatingPicker">
                ${[1, 2, 3, 4, 5].map(star => `
                  <i class="${star <= initialRating ? 'fa-solid fa-star' : 'fa-regular fa-star'}" data-star="${star}"></i>
                `).join('')}
              </div>
            </div>

            <div style="margin-bottom: 8px; font-size: 0.85rem; color: #374151;">
              Người đánh giá: <strong>${this.currentUser.name}</strong> 
              <span style="color: #059669; font-weight: 700; font-size: 0.78rem;"><i class="fa-solid fa-check"></i> (Đã xác minh mua hàng)</span>
            </div>

            <textarea id="reviewCommentText" class="review-input-comment"
              placeholder="Chia sẻ trải nghiệm thực tế của bạn về máy, thời lượng pin, độ mượt, chế độ bảo hành..." required>${initialComment}</textarea>

            <button type="submit" class="btn-primary" style="padding: 8px 18px; font-size: 0.88rem;">
              <i class="fa-solid ${hasReviewed ? 'fa-rotate' : 'fa-paper-plane'}"></i>
              ${hasReviewed ? 'CẬP NHẬT ĐÁNH GIÁ CỦA BẠN' : 'GỬI ĐÁNH GIÁ XÁC THỰC'}
            </button>
          </form>
        `;

        // Gắn sự kiện chọn sao
        const starPicker = document.getElementById('starRatingPicker');
        if (starPicker) {
          const stars = starPicker.querySelectorAll('i');
          stars.forEach(star => {
            star.addEventListener('click', () => {
              const val = Number(star.getAttribute('data-star'));
              document.getElementById('selectedRatingInput').value = val;
              stars.forEach(s => {
                const sVal = Number(s.getAttribute('data-star'));
                s.className = sVal <= val ? 'fa-solid fa-star' : 'fa-regular fa-star';
              });
            });
          });
        }

        // Gắn submit form
        const form = document.getElementById('newReviewForm');
        if (form) {
          form.addEventListener('submit', (e) => this.handleReviewSubmit(e));
        }
      }
    } catch (err) {
      container.innerHTML = `<div style="color: #dc2626; font-size: 0.85rem;">Không thể kiểm tra quyền đánh giá: ${err.message}</div>`;
    }
  },

  /**
   * Tải danh sách đánh giá của sản phẩm và cập nhật điểm sao trung bình
   */
  async loadProductReviews(productId) {
    const list = document.getElementById('detailReviewsList');
    if (!list) return;

    list.innerHTML = '<div style="color: #6b7280; font-size: 0.85rem; padding: 10px 0;"><i class="fa-solid fa-spinner fa-spin"></i> Đang tải nhận xét...</div>';

    try {
      const res = await fetch(`/api/products/${productId}/reviews`);
      const data = await res.json();
      if (data.success) {
        const reviews = data.data || [];

        // Cập nhật số lượng trên Tab Badge & Overview Box
        const tabBadge = document.getElementById('tabReviewsCount');
        const countOverview = document.getElementById('detailTotalReviewsCount');
        const scoreOverview = document.getElementById('detailAvgRatingScore');
        const starsRow = document.getElementById('detailAvgStarsRow');

        if (tabBadge) tabBadge.textContent = reviews.length;
        if (countOverview) countOverview.textContent = reviews.length;

        // Tính trung bình số sao
        let avgRating = 5.0;
        if (reviews.length > 0) {
          const sum = reviews.reduce((acc, r) => acc + Number(r.rating || 5), 0);
          avgRating = (sum / reviews.length).toFixed(1);
        }

        if (scoreOverview) scoreOverview.textContent = avgRating;
        if (starsRow) {
          const rounded = Math.round(Number(avgRating));
          starsRow.innerHTML = [1, 2, 3, 4, 5].map(s =>
            `<i class="${s <= rounded ? 'fa-solid fa-star' : 'fa-regular fa-star'}"></i>`
          ).join('');
        }

        // Đồng thời cập nhật số sao trên header chi tiết sản phẩm
        const detailRating = document.getElementById('detailRating');
        const detailReviewCount = document.getElementById('detailReviewCount');
        if (detailRating) detailRating.textContent = avgRating;
        if (detailReviewCount) detailReviewCount.textContent = reviews.length;

        if (reviews.length > 0) {
          list.innerHTML = reviews.map(r => `
            <div style="background: #ffffff; border: 1px solid #e5e7eb; border-radius: 8px; padding: 14px; margin-bottom: 10px; box-shadow: 0 1px 2px rgba(0,0,0,0.03);">
              <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                <div style="display: flex; align-items: center; gap: 8px;">
                  <div style="width: 32px; height: 32px; border-radius: 50%; background: #fee2e2; color: var(--vt-red); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.85rem;">
                    ${(r.user_name || 'K').charAt(0).toUpperCase()}
                  </div>
                  <div>
                    <span style="font-weight: 800; font-size: 0.88rem; color: #111;">${r.user_name}</span>
                    <span class="badge-buyer" style="margin-left: 6px;"><i class="fa-solid fa-check"></i> Đã mua tại TechStore</span>
                  </div>
                </div>
                <div style="color: var(--accent-gold); font-size: 0.85rem;">
                  ${[1, 2, 3, 4, 5].map(s => `<i class="${s <= r.rating ? 'fa-solid fa-star' : 'fa-regular fa-star'}"></i>`).join('')}
                </div>
              </div>
              <p style="font-size: 0.88rem; color: #374151; line-height: 1.5; margin: 4px 0 6px;">${r.comment}</p>
              <div style="font-size: 0.72rem; color: #9ca3af; display: flex; align-items: center; gap: 12px;">
                <span><i class="fa-regular fa-clock"></i> ${new Date(r.created_at || Date.now()).toLocaleDateString('vi-VN')}</span>
                ${r.updated_at && r.updated_at !== r.created_at ? `<span style="color: #6b7280; font-style: italic;">(Đã cập nhật: ${new Date(r.updated_at).toLocaleDateString('vi-VN')})</span>` : ''}
              </div>
            </div>
          `).join('');
        } else {
          list.innerHTML = '<div style="color: #6b7280; font-size: 0.85rem; padding: 12px; background: #f9fafb; border-radius: 6px;">Chưa có nhận xét nào từ người đã mua. Hãy là khách hàng đầu tiên chia sẻ cảm nhận!</div>';
        }
      }
    } catch (e) {
      list.innerHTML = '<div style="color: #dc2626;">Lỗi tải nhận xét.</div>';
    }
  },

  /**
   * Xử lý gửi mới hoặc cập nhật đánh giá
   */
  async handleReviewSubmit(e) {
    e.preventDefault();
    const productId = document.getElementById('reviewProductId').value;
    const rating = document.getElementById('selectedRatingInput').value;
    const comment = document.getElementById('reviewCommentText').value.trim();

    if (!comment) {
      showToast('Vui lòng nhập nội dung đánh giá!', 'error');
      return;
    }

    if (!this.currentUser) {
      showToast('Vui lòng đăng nhập bằng tài khoản đã mua để đánh giá!', 'error');
      return;
    }

    try {
      const res = await fetch('/api/reviews', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          product_id: productId,
          user_id: this.currentUser.id,
          user_name: this.currentUser.name,
          user_email: this.currentUser.email,
          user_phone: this.currentUser.phone,
          rating,
          comment
        })
      });
      const data = await res.json();

      if (data.success) {
        showToast(data.message || 'Gửi đánh giá thành công!');
        // Tải lại danh sách đánh giá & quyền hạn
        await this.loadProductReviews(productId);
        await this.checkAndRenderReviewPermission(productId);
        // Tải lại danh sách sản phẩm trên trang chủ để cập nhật số sao trung bình trên thẻ sản phẩm
        this.loadProducts();
      } else {
        showToast(data.message || 'Không thể lưu đánh giá', 'error');
      }
    } catch (err) {
      showToast('Lỗi khi gửi đánh giá', 'error');
    }
  },

  /**
   * Tải danh sách câu hỏi & câu trả lời (Q&A)
   */
  async loadProductQuestions(productId) {
    const list = document.getElementById('detailQuestionsList');
    if (!list) return;

    list.innerHTML = '<div style="color: #6b7280; font-size: 0.85rem; padding: 10px 0;"><i class="fa-solid fa-spinner fa-spin"></i> Đang tải câu hỏi...</div>';

    try {
      const res = await fetch(`/api/products/${productId}/questions`);
      const data = await res.json();
      if (data.success) {
        const questions = data.data || [];
        const tabBadge = document.getElementById('tabQuestionsCount');
        if (tabBadge) tabBadge.textContent = questions.length;

        if (questions.length === 0) {
          list.innerHTML = '<div style="color: #6b7280; font-size: 0.85rem; padding: 12px; background: #f9fafb; border-radius: 6px;">Chưa có câu hỏi nào. Bạn có băn khoăn về sản phẩm này? Hãy đặt câu hỏi ở trên để người đã mua giải đáp cho bạn nhé!</div>';
          return;
        }

        list.innerHTML = questions.map(q => `
          <div class="qa-thread-item" id="qaThread_${q.id}">
            <div class="qa-question-header">
              <div class="qa-author-badge">
                <span>${q.user_name}</span>
                ${q.is_buyer ? `<span class="badge-buyer"><i class="fa-solid fa-check"></i> Đã mua sản phẩm</span>` : ''}
                ${q.is_admin ? `<span class="badge-admin"><i class="fa-solid fa-shield"></i> Quản trị viên</span>` : ''}
              </div>
              <div class="qa-time-text">
                <i class="fa-regular fa-clock"></i> ${new Date(q.created_at || Date.now()).toLocaleDateString('vi-VN')}
              </div>
            </div>
            <div class="qa-question-content">
              <strong>Hỏi:</strong> ${q.content}
            </div>

            <div>
              <button type="button" class="btn-qa-reply-toggle" onclick="App.toggleReplyBox(${q.id})">
                <i class="fa-regular fa-comment-dots"></i> Trả lời câu hỏi này
              </button>
            </div>

            <!-- Form trả lời ẩn/hiện -->
            <div class="qa-inline-reply-box" id="replyBox_${q.id}">
              <form onsubmit="App.handleReplySubmit(event, ${q.id}, ${productId})">
                <div style="font-size: 0.82rem; font-weight: 700; margin-bottom: 4px; color: #111;">
                  Viết câu trả lời cho "${q.user_name}":
                </div>
                <input type="text" class="form-control reply-author-input" placeholder="Họ và tên của bạn..." value="${this.currentUser ? this.currentUser.name : ''}" required style="margin-bottom: 6px; font-size: 0.82rem; padding: 6px 10px;">
                <textarea class="form-control reply-content-input" rows="2" placeholder="Chia sẻ câu trả lời hoặc kinh nghiệm của bạn..." required style="font-size: 0.85rem; padding: 6px 10px; margin-bottom: 6px;"></textarea>
                <div style="display: flex; gap: 6px;">
                  <button type="submit" class="btn-primary" style="padding: 5px 12px; font-size: 0.78rem;">
                    Gửi câu trả lời
                  </button>
                  <button type="button" class="btn-secondary" onclick="App.toggleReplyBox(${q.id})" style="padding: 5px 10px; font-size: 0.78rem;">
                    Hủy
                  </button>
                </div>
              </form>
            </div>

            <!-- Danh sách câu trả lời đã có -->
            ${(q.replies && q.replies.length > 0) ? `
              <div class="qa-replies-list">
                ${q.replies.map(rep => `
                  <div class="qa-reply-card">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
                      <div style="font-weight: 800; font-size: 0.82rem; color: #111; display: flex; align-items: center; gap: 6px;">
                        <span>${rep.user_name}</span>
                        ${rep.is_buyer ? `<span class="badge-buyer"><i class="fa-solid fa-check"></i> Đã mua sản phẩm</span>` : ''}
                        ${rep.is_admin ? `<span class="badge-admin"><i class="fa-solid fa-shield"></i> Quản trị viên</span>` : ''}
                      </div>
                      <span style="font-size: 0.72rem; color: #9ca3af;">${new Date(rep.created_at || Date.now()).toLocaleDateString('vi-VN')}</span>
                    </div>
                    <div style="font-size: 0.85rem; color: #4b5563; line-height: 1.4;">
                      <strong>Trả lời:</strong> ${rep.content}
                    </div>
                  </div>
                `).join('')}
              </div>
            ` : ''}
          </div>
        `).join('');
      }
    } catch (e) {
      list.innerHTML = '<div style="color: #dc2626;">Lỗi tải danh sách hỏi đáp.</div>';
    }
  },

  toggleReplyBox(questionId) {
    const box = document.getElementById(`replyBox_${questionId}`);
    if (box) box.classList.toggle('open');
  },

  async handleNewQuestionSubmit(e) {
    e.preventDefault();
    const productId = this.activeProductId;
    if (!productId) return;

    const nameInput = document.getElementById('questionAuthorName');
    const contentInput = document.getElementById('questionContentText');
    const content = contentInput.value.trim();
    const name = nameInput.value.trim();

    if (!content) {
      showToast('Vui lòng nhập nội dung câu hỏi!', 'error');
      return;
    }

    try {
      const res = await fetch(`/api/products/${productId}/questions`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          productId,
          user_id: this.currentUser ? this.currentUser.id : null,
          user_name: name || (this.currentUser ? this.currentUser.name : 'Khách hàng'),
          user_email: this.currentUser ? this.currentUser.email : '',
          user_phone: this.currentUser ? this.currentUser.phone : '',
          content,
          is_admin: this.currentUser?.role === 'admin'
        })
      });
      const data = await res.json();
      if (data.success) {
        showToast(data.message || 'Đã gửi câu hỏi thành công!');
        contentInput.value = '';
        this.loadProductQuestions(productId);
      } else {
        showToast(data.message || 'Lỗi khi gửi câu hỏi', 'error');
      }
    } catch (err) {
      showToast('Lỗi khi gửi câu hỏi', 'error');
    }
  },

  async handleReplySubmit(e, parentId, productId) {
    e.preventDefault();
    const form = e.target;
    const nameInput = form.querySelector('.reply-author-input');
    const contentInput = form.querySelector('.reply-content-input');
    const content = contentInput.value.trim();
    const name = nameInput.value.trim();

    if (!content) {
      showToast('Vui lòng nhập nội dung trả lời!', 'error');
      return;
    }

    try {
      const res = await fetch(`/api/products/${productId}/questions`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          productId,
          parent_id: parentId,
          user_id: this.currentUser ? this.currentUser.id : null,
          user_name: name || (this.currentUser ? this.currentUser.name : 'Khách hàng'),
          user_email: this.currentUser ? this.currentUser.email : '',
          user_phone: this.currentUser ? this.currentUser.phone : '',
          content,
          is_admin: this.currentUser?.role === 'admin'
        })
      });
      const data = await res.json();
      if (data.success) {
        showToast(data.message || 'Đã gửi câu trả lời thành công!');
        this.loadProductQuestions(productId);
      } else {
        showToast(data.message || 'Lỗi khi gửi trả lời', 'error');
      }
    } catch (err) {
      showToast('Lỗi gửi câu trả lời', 'error');
    }
  },

  // Hiệu ứng bay vào giỏ hàng Parabolic Fly-To-Cart Animation
  flyToCartAnimation(imgElement) {
    const cartBtn = document.getElementById('btnOpenCart');
    const badge = document.getElementById('cartCountBadge');
    if (!imgElement || !cartBtn) return;

    const imgRect = imgElement.getBoundingClientRect();
    const cartRect = cartBtn.getBoundingClientRect();

    const flyingImg = imgElement.cloneNode();
    flyingImg.className = 'fly-to-cart-item';
    flyingImg.style.top = `${imgRect.top}px`;
    flyingImg.style.left = `${imgRect.left}px`;
    flyingImg.style.width = `${imgRect.width}px`;
    flyingImg.style.height = `${imgRect.height}px`;

    document.body.appendChild(flyingImg);

    // Bắt buộc reflow layout
    void flyingImg.offsetWidth;

    // Di chuyển mượt mà tới nút giỏ hàng
    flyingImg.style.top = `${cartRect.top + 6}px`;
    flyingImg.style.left = `${cartRect.left + 6}px`;
    flyingImg.style.width = '24px';
    flyingImg.style.height = '24px';
    flyingImg.style.opacity = '0.15';
    flyingImg.style.transform = 'scale(0.3) rotate(360deg)';

    setTimeout(() => {
      flyingImg.remove();
      if (badge) {
        badge.classList.remove('cart-bump');
        void badge.offsetWidth;
        badge.classList.add('cart-bump');
      }
    }, 750);
  },

  async handleAddToCart(productId, event, chosenVariant = null) {
    if (event) event.stopPropagation();

    try {
      const res = await fetch(`/api/products/${productId}`);
      const data = await res.json();
      if (!data.success) throw new Error(data.message);

      const product = data.data;
      if (!chosenVariant && product.specifications && Array.isArray(product.specifications.variants) && product.specifications.variants.length > 0) {
        chosenVariant = product.specifications.variants[0];
      }

      const vStock = (chosenVariant && chosenVariant.stock !== undefined) ? Number(chosenVariant.stock) : Number(product.stock || 0);
      const checkStock = Math.min(vStock, Number(product.stock || 0));
      if (checkStock <= 0) {
        showToast('Sản phẩm này tạm thời đã hết hàng!', 'error');
        return;
      }

      const resAdd = Cart.addItem(product, 1, chosenVariant);
      if (!resAdd.success) {
        showToast(resAdd.message, 'error');
        return;
      }

      // Kích hoạt hiệu ứng bay vào giỏ hàng
      if (event && event.target) {
        const card = event.target.closest('.product-card');
        const img = card?.querySelector('.product-card-top img');
        if (img) this.flyToCartAnimation(img);
      }

      const varInfo = chosenVariant ? ` (${chosenVariant.name})` : '';
      showToast(`Đã thêm "${product.name}${varInfo}" vào giỏ hàng!`);
    } catch (e) {
      showToast(e.message || 'Lỗi khi thêm vào giỏ', 'error');
    }
  },

  async handleBuyNow(productId, chosenVariant = null) {
    try {
      const res = await fetch(`/api/products/${productId}`);
      const data = await res.json();
      if (!data.success) throw new Error(data.message);

      const product = data.data;
      if (!chosenVariant && product.specifications && Array.isArray(product.specifications.variants) && product.specifications.variants.length > 0) {
        chosenVariant = product.specifications.variants[0];
      }

      const vStock = (chosenVariant && chosenVariant.stock !== undefined) ? Number(chosenVariant.stock) : Number(product.stock || 0);
      const checkStock = Math.min(vStock, Number(product.stock || 0));
      if (checkStock <= 0) {
        showToast('Sản phẩm này tạm thời đã hết hàng!', 'error');
        return;
      }

      const resAdd = Cart.addItem(product, 1, chosenVariant);
      if (!resAdd.success) {
        showToast(resAdd.message, 'error');
        return;
      }

      Checkout.openModal();
    } catch (e) {
      showToast(e.message || 'Lỗi khi chọn mua ngay', 'error');
    }
  },

  // 7. Cart Drawer UI
  bindCartDrawer() {
    const drawer = document.getElementById('cartDrawer');
    const openBtn = document.getElementById('btnOpenCart');
    const closeBtn = document.getElementById('closeCartDrawerBtn');

    if (openBtn && drawer) {
      openBtn.addEventListener('click', (e) => {
        e.preventDefault();
        drawer.classList.add('open');
      });
    }
    if (closeBtn && drawer) {
      closeBtn.addEventListener('click', (e) => {
        e.preventDefault();
        drawer.classList.remove('open');
      });
    }

    if (drawer) {
      drawer.addEventListener('click', (e) => {
        if (e.target === drawer) {
          drawer.classList.remove('open');
        }
      });
    }

    const applyCouponBtn = document.getElementById('btnApplyCoupon');
    if (applyCouponBtn) {
      applyCouponBtn.addEventListener('click', async () => {
        const input = document.getElementById('couponCodeInput');
        const code = input?.value?.trim().toUpperCase();
        if (!code) {
          showToast('Vui lòng nhập mã giảm giá', 'error');
          return;
        }

        const summary = Cart.getSummary();
        try {
          const res = await fetch('/api/coupons/validate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ code, order_value: summary.rawSubtotal })
          });
          const data = await res.json();

          if (data.success) {
            Cart.setAppliedCoupon(data.data);
            showToast(data.message, 'success');
          } else {
            showToast(data.message, 'error');
          }
        } catch (e) {
          showToast('Lỗi khi kiểm tra mã', 'error');
        }
      });
    }
  },

  renderCartUI(summary) {
    const badge = document.getElementById('cartCountBadge');
    if (badge) badge.textContent = summary.totalCount;

    const mobileBadge = document.getElementById('mobileNavCartBadge');
    if (mobileBadge) mobileBadge.textContent = summary.totalCount;

    const list = document.getElementById('cartDrawerItemsList');
    if (!list) return;

    if (summary.items.length === 0) {
      list.innerHTML = `
        <div style="text-align: center; padding: 40px 10px; color: #6b7280;">
          <i class="fa-solid fa-cart-shopping" style="font-size: 2.5rem; margin-bottom: 12px; color: #d1d5db;"></i>
          <p>Giỏ hàng của bạn đang trống</p>
        </div>
      `;
    } else {
      list.innerHTML = summary.items.map(item => `
        <div class="cart-item-row">
          <div class="cart-item-img">
            <img src="${item.product_image}" alt="${item.product_name}">
          </div>
          <div class="cart-item-details">
            <h5 class="cart-item-name">
              ${item.product_name}
              ${item.variant_name ? `<span style="display:block; font-size:0.75rem; color:var(--vt-red); font-weight:700; margin-top:2px;">[${item.variant_name}]</span>` : ''}
            </h5>
            <div class="cart-item-price">${new Intl.NumberFormat('vi-VN').format(item.price)}₫</div>
            <div class="cart-item-qty-row">
              <div class="quantity-picker">
                <button class="quantity-btn" onclick="Cart.updateQuantity('${item.cart_key || item.product_id}', ${item.quantity - 1})">-</button>
                <span class="quantity-input">${item.quantity}</span>
                <button class="quantity-btn" onclick="Cart.updateQuantity('${item.cart_key || item.product_id}', ${item.quantity + 1}, ${item.stock})">+</button>
              </div>
              <span style="font-weight: 800; color: #111; font-size: 0.85rem;">
                ${new Intl.NumberFormat('vi-VN').format(item.subtotal)}₫
              </span>
            </div>
          </div>
          <button class="cart-item-remove" onclick="Cart.removeItem('${item.cart_key || item.product_id}')">
            <i class="fa-solid fa-trash-can"></i>
          </button>
        </div>
      `).join('');
    }

    const subtotalEl = document.getElementById('cartDrawerSubtotal') || document.getElementById('drawerSubtotal');
    const shippingEl = document.getElementById('cartDrawerShipping') || document.getElementById('drawerShipping');
    const discountEl = document.getElementById('cartDrawerDiscount') || document.getElementById('drawerDiscount');
    const totalEl = document.getElementById('cartDrawerFinalTotal') || document.getElementById('drawerTotal');

    if (subtotalEl) subtotalEl.textContent = new Intl.NumberFormat('vi-VN').format(summary.rawSubtotal) + '₫';
    if (shippingEl) shippingEl.textContent = summary.shippingFee === 0 ? 'Miễn phí' : new Intl.NumberFormat('vi-VN').format(summary.shippingFee) + '₫';
    if (discountEl) discountEl.textContent = '-' + new Intl.NumberFormat('vi-VN').format(summary.discountAmount) + '₫';
    if (totalEl) totalEl.textContent = new Intl.NumberFormat('vi-VN').format(summary.finalTotal) + '₫';
  },

  // 8. Tra cứu đơn hàng & Đơn hàng của tôi
  async openMyOrders() {
    const modal = document.getElementById('orderTrackingModal');
    if (modal) modal.classList.add('active');

    const input = document.getElementById('trackingInputCode');
    const resultContainer = document.getElementById('trackingResultContainer');
    if (!resultContainer) return;

    if (!this.currentUser) {
      if (input) input.value = '';
      resultContainer.innerHTML = `
        <div style="text-align: center; padding: 32px 20px;">
          <i class="fa-solid fa-arrow-right-to-bracket" style="font-size: 2.4rem; color: #9ca3af; margin-bottom: 12px; display: block;"></i>
          <h4 style="font-size: 1.05rem; font-weight: 700; color: #1f2937; margin-bottom: 6px;">Vui lòng đăng nhập</h4>
          <p style="font-size: 0.85rem; color: #6b7280; margin-bottom: 16px;">Đăng nhập để xem lịch sử và toàn bộ đơn hàng bạn đã đặt.</p>
          <a href="/login.html" class="btn-primary" style="display: inline-block; padding: 8px 22px; text-decoration: none; border-radius: 6px;">
            <i class="fa-regular fa-circle-user"></i> Đăng nhập ngay
          </a>
        </div>
      `;
      return;
    }

    const userPhone = this.currentUser.phone || '';
    const userEmail = this.currentUser.email || '';
    const userId = this.currentUser.id || '';

    if (input) {
      input.value = userPhone || userEmail || '';
    }

    resultContainer.innerHTML = '<div style="text-align: center; padding: 26px; color: #6b7280;"><i class="fa-solid fa-spinner fa-spin"></i> Đang tải toàn bộ đơn hàng của bạn...</div>';

    try {
      const queryParams = new URLSearchParams();
      if (userId) queryParams.set('userId', userId);
      if (userPhone) queryParams.set('phone', userPhone);
      if (userEmail) queryParams.set('email', userEmail);

      const res = await fetch(`/api/orders/user-orders?${queryParams.toString()}`);
      const data = await res.json();

      let orders = (data && data.success && Array.isArray(data.data)) ? data.data : [];

      // Fallback kiểm tra qua số điện thoại nếu query user-orders chưa trả về đơn
      if (orders.length === 0 && userPhone) {
        const trackRes = await fetch(`/api/orders/track/${encodeURIComponent(userPhone)}`);
        const trackData = await trackRes.json();
        if (trackData && trackData.success && Array.isArray(trackData.data)) {
          orders = trackData.data;
        }
      }

      if (orders.length > 0) {
        this.renderTrackingResults(orders, userPhone || userEmail, true);
      } else {
        resultContainer.innerHTML = `
          <div style="text-align: center; padding: 32px 20px; color: #6b7280;">
            <i class="fa-solid fa-box-open" style="font-size: 2.6rem; color: #d1d5db; margin-bottom: 12px; display: block;"></i>
            <h4 style="font-size: 1rem; font-weight: 700; color: #374151; margin-bottom: 6px;">Bạn chưa có đơn hàng nào</h4>
            <p style="font-size: 0.85rem; color: #9ca3af; margin-bottom: 16px;">Tài khoản này chưa có đơn hàng. Khám phá ngay các ưu đãi hot!</p>
            <a href="/" class="btn-primary" style="display: inline-block; padding: 8px 20px; text-decoration: none; border-radius: 6px;">
              <i class="fa-solid fa-cart-shopping"></i> Mua sắm ngay
            </a>
          </div>
        `;
      }
    } catch (err) {
      console.error('Lỗi tải đơn hàng của tôi:', err);
      resultContainer.innerHTML = '<div style="text-align: center; color: #dc2626; padding: 20px;">Lỗi tải dữ liệu đơn hàng. Vui lòng thử lại!</div>';
    }
  },

  bindOrderTracking() {
    const modal = document.getElementById('orderTrackingModal');
    const openBtn = document.getElementById('btnOpenTracking');
    const closeBtn = document.getElementById('closeTrackingModalBtn');
    const form = document.getElementById('orderTrackingForm');

    if (openBtn) {
      openBtn.addEventListener('click', () => {
        if (modal) modal.classList.add('active');
        if (this.currentUser && (this.currentUser.phone || this.currentUser.email)) {
          const input = document.getElementById('trackingInputCode');
          if (input && !input.value) {
            input.value = this.currentUser.phone || this.currentUser.email;
          }
        }
      });
    }

    if (closeBtn) closeBtn.addEventListener('click', () => modal?.classList.remove('active'));

    modal?.addEventListener('click', (e) => {
      if (e.target === modal) modal.classList.remove('active');
    });

    if (form) {
      form.addEventListener('submit', async (e) => {
        e.preventDefault();
        const code = document.getElementById('trackingInputCode').value.trim();
        if (!code) {
          showToast('Vui lòng nhập Mã đơn hàng hoặc Số điện thoại', 'error');
          return;
        }
        await this.trackOrdersByQuery(code);
      });
    }
  },

  async trackOrdersByQuery(code) {
    const resultContainer = document.getElementById('trackingResultContainer');
    if (!resultContainer) return;

    resultContainer.innerHTML = '<div style="text-align: center; padding: 24px; color: #6b7280;"><i class="fa-solid fa-spinner fa-spin"></i> Đang tra cứu danh sách đơn hàng...</div>';

    try {
      const res = await fetch(`/api/orders/track/${encodeURIComponent(code)}`);
      const data = await res.json();

      if (data.success && data.data) {
        const orders = Array.isArray(data.data) ? data.data : [data.data];
        this.renderTrackingResults(orders, code, false);
      } else {
        resultContainer.innerHTML = `
          <div style="text-align: center; color: #dc2626; padding: 22px; background: #fef2f2; border: 1px solid #fee2e2; border-radius: 8px; margin-top: 14px;">
            <i class="fa-solid fa-circle-exclamation" style="font-size: 1.6rem; margin-bottom: 8px; display: block;"></i>
            <div style="font-size: 0.92rem; font-weight: 700;">${data.message || 'Không tìm thấy đơn hàng nào!'}</div>
            <div style="font-size: 0.82rem; color: #6b7280; margin-top: 6px;">Vui lòng kiểm tra lại số điện thoại hoặc mã đơn hàng đã nhập.</div>
          </div>
        `;
      }
    } catch (err) {
      console.error('Lỗi tra cứu đơn hàng:', err);
      resultContainer.innerHTML = '<div style="text-align: center; color: #dc2626; padding: 18px;">Lỗi kết nối khi tra cứu. Vui lòng thử lại!</div>';
    }
  },

  renderTrackingResult(order) {
    this.renderTrackingResults(order ? [order] : [], order?.order_code || '', false);
  },

  renderTrackingResults(ordersData, query = '', isMyOrders = false) {
    const container = document.getElementById('trackingResultContainer');
    if (!container) return;

    const orders = Array.isArray(ordersData) ? ordersData : (ordersData ? [ordersData] : []);

    if (orders.length === 0) {
      container.innerHTML = `
        <div style="text-align: center; padding: 28px 16px; color: #6b7280;">
          <i class="fa-solid fa-box-open" style="font-size: 2.2rem; color: #d1d5db; margin-bottom: 10px; display: block;"></i>
          <p style="font-size: 0.9rem;">Không có đơn hàng nào để hiển thị.</p>
        </div>
      `;
      return;
    }

    const statusMeta = {
      pending: { label: 'Chờ xử lý', text: 'Chờ xác nhận', badgeClass: 'pending', icon: 'fa-clock' },
      confirmed: { label: 'Đã xác nhận', text: 'Đã duyệt', badgeClass: 'confirmed', icon: 'fa-box' },
      shipping: { label: 'Đang vận chuyển', text: 'Đang giao hàng', badgeClass: 'shipping', icon: 'fa-truck-fast' },
      completed: { label: 'Thành công', text: 'Giao thành công', badgeClass: 'completed', icon: 'fa-circle-check' },
      cancelled: { label: 'Đã hủy', text: 'Đã hủy', badgeClass: 'cancelled', icon: 'fa-ban' }
    };

    const statusSteps = [
      { key: 'pending', label: 'Đặt hàng' },
      { key: 'confirmed', label: 'Đã duyệt' },
      { key: 'shipping', label: 'Đang giao' },
      { key: 'completed', label: 'Thành công' }
    ];
    const statusOrderMap = { pending: 0, confirmed: 1, shipping: 2, completed: 3, cancelled: -1 };

    const summaryBadgeHtml = isMyOrders
      ? `<div class="tracking-summary-badge"><i class="fa-solid fa-boxes-packing"></i> Tất cả <strong>${orders.length}</strong> đơn hàng đã đặt của bạn${this.currentUser?.name ? ' (' + this.currentUser.name + ')' : ''}</div>`
      : `<div class="tracking-summary-badge"><i class="fa-solid fa-clipboard-check"></i> Tìm thấy <strong>${orders.length}</strong> đơn hàng cho số điện thoại / mã "<strong>${query}</strong>"</div>`;

    const cardsHtml = orders.map(order => {
      const currentIdx = statusOrderMap[order.order_status] ?? 0;
      const meta = statusMeta[order.order_status] || { label: order.order_status, badgeClass: 'confirmed', icon: 'fa-box' };
      const dateStr = order.created_at ? new Date(order.created_at).toLocaleString('vi-VN', {
        hour: '2-digit', minute: '2-digit', day: '2-digit', month: '2-digit', year: 'numeric'
      }) : '';

      let timelineHtml = `
        <div class="order-timeline">
          ${statusSteps.map((step, idx) => {
        let stepClass = '';
        if (currentIdx > idx) stepClass = 'completed';
        else if (currentIdx === idx) stepClass = 'current';

        return `
              <div class="timeline-step ${stepClass}">
                <div class="timeline-circle">
                  <i class="fa-solid ${currentIdx > idx ? 'fa-check' : (idx === 0 ? 'fa-file-invoice' : (idx === 1 ? 'fa-box' : (idx === 2 ? 'fa-truck-fast' : 'fa-house-chimney')))}"></i>
                </div>
                <span>${step.label}</span>
              </div>
            `;
      }).join('')}
        </div>
      `;

      if (order.order_status === 'cancelled') {
        timelineHtml = `
          <div style="background: #fef2f2; border: 1px solid #fca5a5; border-radius: 8px; padding: 10px 14px; text-align: center; color: #dc2626; font-weight: 700; margin: 12px 0;">
            <i class="fa-solid fa-ban"></i> Đơn hàng này đã bị hủy
          </div>
        `;
      }

      const rawSubtotal = (order.items || []).reduce((sum, it) => sum + (Number(it.subtotal) || (Number(it.price) * Number(it.quantity))), 0);
      const isPaid = order.payment_status === 'paid';

      const itemsHtml = (order.items || []).map(item => {
        const itemSubtotal = item.subtotal || (Number(item.price) * Number(item.quantity));
        const imgSrc = item.product_image || 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=150&q=80';
        return `
          <div class="tracking-item-row">
            <div class="tracking-item-img-wrap">
              <img src="${imgSrc}" alt="${item.product_name}" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=150&q=80';">
            </div>
            <div class="tracking-item-info">
              <div class="tracking-item-title">${item.product_name}</div>
              <div class="tracking-item-meta">${new Intl.NumberFormat('vi-VN').format(item.price)}₫ &times; <strong>${item.quantity}</strong></div>
            </div>
            <div class="tracking-item-subtotal">
              ${new Intl.NumberFormat('vi-VN').format(itemSubtotal)}₫
            </div>
          </div>
        `;
      }).join('');

      return `
        <div class="tracking-order-card">
          <div class="tracking-card-header">
            <div>
              <span class="tracking-order-code">${order.order_code}</span>
              ${dateStr ? `<span class="tracking-order-date"><i class="fa-regular fa-calendar-days"></i> ${dateStr}</span>` : ''}
            </div>
            <span class="tracking-status-badge ${meta.badgeClass}">
              <i class="fa-solid ${meta.icon}"></i> ${meta.label}
            </span>
          </div>

          <div class="tracking-card-body">
            ${timelineHtml}

            <div class="tracking-info-grid">
              <div><strong>Người nhận:</strong> ${order.customer_name} (${order.customer_phone})</div>
              <div><strong>Thanh toán:</strong> ${(order.payment_method || 'cod').toUpperCase()} (${isPaid ? '<span style="color:#059669; font-weight:700;">Đã thanh toán</span>' : '<span style="color:#d97706; font-weight:700;">Chưa thanh toán</span>'})</div>
              <div style="grid-column: 1 / -1;"><strong>Địa chỉ nhận:</strong> ${order.shipping_address}</div>
              ${order.notes ? `<div style="grid-column: 1 / -1; color: #6b7280;"><em>Ghi chú: ${order.notes}</em></div>` : ''}
            </div>

            <div class="tracking-items-box">
              <div style="font-size: 0.8rem; font-weight: 700; color: #6b7280; margin-bottom: 4px;">Danh sách sản phẩm:</div>
              ${itemsHtml || '<div style="font-size: 0.8rem; color: #9ca3af; padding: 4px 0;">Không có chi tiết sản phẩm</div>'}
            </div>

            <div class="tracking-card-footer">
              <div style="font-size: 0.8rem; color: #6b7280; line-height: 1.5;">
                <div>Tạm tính: <strong>${new Intl.NumberFormat('vi-VN').format(rawSubtotal)}₫</strong></div>
                <div>Phí vận chuyển: <strong>${order.shipping_fee > 0 ? (new Intl.NumberFormat('vi-VN').format(order.shipping_fee) + '₫') : 'Miễn phí'}</strong></div>
                ${Number(order.discount_amount) > 0 ? `<div style="color: #059669;">Giảm giá: <strong>-${new Intl.NumberFormat('vi-VN').format(order.discount_amount)}₫</strong></div>` : ''}
              </div>
              <div class="tracking-totals">
                <span class="tracking-total-amount">Tổng tiền: <strong>${new Intl.NumberFormat('vi-VN').format(order.total_amount)}₫</strong></span>
              </div>
            </div>
          </div>
        </div>
      `;
    }).join('');

    container.innerHTML = `
      ${summaryBadgeHtml}
      <div class="tracking-results-list">
        ${cardsHtml}
      </div>
    `;
  },

  // 8. Floating Controls: Back to top with circular progress & Quick Support Widget
  bindFloatingControls() {
    const btnBackToTop = document.getElementById('btnBackToTop');
    const progressCircle = document.getElementById('scrollProgressCircle');
    const radius = 19;
    const circumference = 2 * Math.PI * radius;

    if (progressCircle) {
      progressCircle.style.strokeDasharray = `${circumference} ${circumference}`;
      progressCircle.style.strokeDashoffset = `${circumference}`;
    }

    const updateScrollProgress = () => {
      const scrollTop = window.scrollY || document.documentElement.scrollTop;
      const scrollHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;

      if (btnBackToTop) {
        if (scrollTop > 280) {
          btnBackToTop.classList.add('show');
        } else {
          btnBackToTop.classList.remove('show');
        }
      }

      if (progressCircle && scrollHeight > 0) {
        const progress = Math.min(1, Math.max(0, scrollTop / scrollHeight));
        const offset = circumference - (progress * circumference);
        progressCircle.style.strokeDashoffset = `${offset}`;
      }
    };

    window.addEventListener('scroll', () => {
      this.closeUserDropdown();
      this.closeLiveSearch();
      updateScrollProgress();
    }, { passive: true });
    updateScrollProgress();

    if (btnBackToTop) {
      btnBackToTop.addEventListener('click', () => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
      });
    }

    // Floating Support Popup
    const btnSupport = document.getElementById('btnFloatingSupport');
    const supportPopup = document.getElementById('supportPopupMenu');

    if (btnSupport && supportPopup) {
      btnSupport.addEventListener('click', (e) => {
        e.stopPropagation();
        supportPopup.classList.toggle('open');
      });

      document.addEventListener('click', (e) => {
        if (!supportPopup.contains(e.target) && e.target !== btnSupport) {
          supportPopup.classList.remove('open');
        }
      });
    }
  },

  // 13. Mobile Bottom Navigation Bar (App Bar)
  renderMobileBottomNav() {
    let nav = document.getElementById('mobileBottomNav');
    if (!nav) {
      nav = document.createElement('nav');
      nav.id = 'mobileBottomNav';
      nav.className = 'mobile-bottom-nav';
      nav.setAttribute('aria-label', 'Thanh điều hướng di động');
      document.body.appendChild(nav);
    }

    const currentPath = window.location.pathname.toLowerCase();
    const isHome = currentPath === '/' || currentPath === '/index.html' || currentPath.endsWith('/index.html') || currentPath === '';
    const cartSummary = Cart.getSummary ? Cart.getSummary() : { totalCount: 0 };
    const cartCount = cartSummary.totalCount || 0;

    nav.innerHTML = `
      <a href="/" class="mobile-nav-item ${isHome ? 'active' : ''}">
        <i class="fa-solid fa-house"></i>
        <span>Trang chủ</span>
      </a>
      <button type="button" class="mobile-nav-item" id="mobileNavSearchBtn">
        <i class="fa-solid fa-magnifying-glass"></i>
        <span>Tìm kiếm</span>
      </button>
      <button type="button" class="mobile-nav-item" id="mobileNavCartBtn">
        <div class="mobile-nav-icon-wrap">
          <i class="fa-solid fa-bag-shopping"></i>
          <span class="mobile-nav-badge" id="mobileNavCartBadge">${cartCount}</span>
        </div>
        <span>Giỏ hàng</span>
      </button>
      <button type="button" class="mobile-nav-item" id="mobileNavUserBtn">
        <i class="fa-solid fa-user"></i>
        <span>Tài khoản</span>
      </button>
    `;

    // Event: Tìm kiếm
    const searchBtn = document.getElementById('mobileNavSearchBtn');
    if (searchBtn) {
      searchBtn.addEventListener('click', () => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
        const input = document.getElementById('mainSearchInput');
        if (input) {
          setTimeout(() => {
            input.focus();
            input.scrollIntoView({ behavior: 'smooth', block: 'center' });
          }, 350);
        }
      });
    }

    // Event: Giỏ hàng
    const cartBtn = document.getElementById('mobileNavCartBtn');
    if (cartBtn) {
      cartBtn.addEventListener('click', () => {
        const drawer = document.getElementById('cartDrawer');
        if (drawer) {
          drawer.classList.add('open');
        }
      });
    }

    // Event: Tài khoản (mở popup đầy đủ thông tin trên cả desktop và mobile)
    const userBtn = document.getElementById('mobileNavUserBtn');
    if (userBtn) {
      userBtn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        this.openUserProfileModal();
      });
    }
  },

  // Đồng bộ thanh trượt chỉ báo vị trí danh mục (Chuẩn demo.jpeg)
  initCategoryScrollIndicator() {
    const catGrid = document.querySelector('.categories-badges-grid');
    const thumb = document.getElementById('catScrollThumb');
    const track = document.querySelector('.cat-scroll-indicator-track');
    if (!catGrid || !thumb || !track) return;

    const updateThumb = () => {
      const maxScroll = catGrid.scrollWidth - catGrid.clientWidth;
      if (maxScroll > 0) {
        const scrollRatio = Math.min(1, Math.max(0, catGrid.scrollLeft / maxScroll));
        const maxThumbTranslate = track.clientWidth - thumb.clientWidth;
        thumb.style.transform = `translateX(${scrollRatio * maxThumbTranslate}px)`;
      } else {
        thumb.style.transform = 'translateX(0px)';
      }
    };

    catGrid.addEventListener('scroll', updateThumb, { passive: true });
    window.addEventListener('resize', updateThumb, { passive: true });
    setTimeout(updateThumb, 350);
  },

  // ==================== USER PROFILE MODAL ====================
  ensureUserProfileModal() {
    let modal = document.getElementById('userProfileModal');
    if (!modal) {
      modal = document.createElement('div');
      modal.className = 'modal-overlay';
      modal.id = 'userProfileModal';
      modal.addEventListener('click', (e) => {
        if (e.target === modal) this.closeUserProfileModal();
      });
      document.body.appendChild(modal);
    }
    return modal;
  },

  openUserProfileModal() {
    const modal = this.ensureUserProfileModal();
    const user = this.currentUser;

    if (user) {
      const isAdmin = user.role === 'admin';
      const roleBadge = isAdmin
        ? '<span class="badge-role-admin"><i class="fa-solid fa-shield-halved"></i> Quản Trị Viên</span>'
        : '<span class="badge-role-vip"><i class="fa-solid fa-user-check"></i> Khách Hàng</span>';
      
      const avatarUrl = user.avatar || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80';
      const joinedDate = user.created_at ? new Date(user.created_at).toLocaleDateString('vi-VN') : 'Mới tham gia';

      modal.innerHTML = `
        <div class="user-profile-modal-box">
          <div class="user-profile-modal-header">
            <h3><i class="fa-solid fa-circle-user" style="color: var(--vt-red);"></i> Thông Tin Tài Khoản</h3>
            <button class="modal-close-btn" onclick="App.closeUserProfileModal()">&times;</button>
          </div>
          <div class="user-profile-modal-body">
            <!-- Hero User Card -->
            <div class="user-modal-hero-card">
              <img src="${avatarUrl}" alt="Avatar" class="user-modal-avatar">
              <div class="user-modal-hero-info">
                <h4>${user.name || 'Người dùng TechStore'}</h4>
                <div>${roleBadge}</div>
                <div style="font-size: 0.74rem; color: #64748b; margin-top: 4px;">ID tài khoản: <strong>#${user.id || 1}</strong></div>
              </div>
            </div>

            <!-- Detailed Info Rows (Chỉ gồm các trường thực tế trong CSDL: id, name, email, phone, role, created_at) -->
            <div class="user-modal-info-list">
              <div class="user-modal-info-row">
                <i class="fa-solid fa-hashtag"></i>
                <span class="row-label">Mã tài khoản (ID)</span>
                <span class="row-value">#${user.id || 1}</span>
              </div>
              <div class="user-modal-info-row">
                <i class="fa-regular fa-user"></i>
                <span class="row-label">Họ và tên</span>
                <span class="row-value">${user.name || 'Chưa cập nhật'}</span>
              </div>
              <div class="user-modal-info-row">
                <i class="fa-regular fa-envelope"></i>
                <span class="row-label">Email</span>
                <span class="row-value">${user.email || 'Chưa cập nhật'}</span>
              </div>
              <div class="user-modal-info-row">
                <i class="fa-solid fa-phone"></i>
                <span class="row-label">Số điện thoại</span>
                <span class="row-value">${user.phone || 'Chưa cập nhật'}</span>
              </div>
              <div class="user-modal-info-row">
                <i class="fa-solid fa-shield-halved"></i>
                <span class="row-label">Vai trò</span>
                <span class="row-value">${user.role === 'admin' ? 'Quản trị viên (Admin)' : 'Khách hàng (User)'}</span>
              </div>
              <div class="user-modal-info-row">
                <i class="fa-regular fa-calendar-check"></i>
                <span class="row-label">Ngày tạo tài khoản</span>
                <span class="row-value">${joinedDate}</span>
              </div>
            </div>

            <!-- Action Buttons -->
            <div class="user-modal-actions">
              <button type="button" class="btn-user-action primary" onclick="App.closeUserProfileModal(); App.openMyOrders();">
                <i class="fa-solid fa-truck-fast"></i> Lịch sử đơn hàng của tôi
              </button>
              ${isAdmin ? `
              <a href="/admin.html" class="btn-user-action admin">
                <i class="fa-solid fa-shield-halved"></i> Truy cập Bảng Quản Trị Hệ Thống
              </a>` : ''}
              <button type="button" class="btn-user-action logout" onclick="App.closeUserProfileModal(); App.handleLogout();">
                <i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất tài khoản
              </button>
            </div>
          </div>
        </div>
      `;
    } else {
      // Guest User View
      modal.innerHTML = `
        <div class="user-profile-modal-box">
          <div class="user-profile-modal-header">
            <h3><i class="fa-solid fa-circle-user" style="color: var(--vt-red);"></i> Tài Khoản TechStore</h3>
            <button class="modal-close-btn" onclick="App.closeUserProfileModal()">&times;</button>
          </div>
          <div class="user-profile-modal-body">
            <div class="user-guest-hero">
              <div class="guest-icon"><i class="fa-regular fa-circle-user"></i></div>
              <h4>Chào mừng bạn đến với TechStore!</h4>
              <p>Đăng nhập hoặc tạo tài khoản mới để theo dõi đơn hàng và tận hưởng dịch vụ bảo hành chính hãng.</p>
            </div>

            <div class="guest-perks-list">
              <div class="guest-perk-item">
                <i class="fa-solid fa-circle-check"></i>
                <span>Theo dõi và tra cứu trạng thái đơn hàng mọi lúc mọi nơi</span>
              </div>
              <div class="guest-perk-item">
                <i class="fa-solid fa-circle-check"></i>
                <span>Giao hàng nhanh toàn quốc - Kiểm tra hàng trước khi thanh toán</span>
              </div>
              <div class="guest-perk-item">
                <i class="fa-solid fa-circle-check"></i>
                <span>Chính sách đổi mới 1 - 1 trong 30 ngày nếu có lỗi NSX</span>
              </div>
            </div>

            <div class="user-modal-actions">
              <a href="/login.html" class="btn-primary" style="display:flex;align-items:center;justify-content:center;gap:8px;padding:12px;border-radius:10px;text-decoration:none;font-weight:700;">
                <i class="fa-solid fa-arrow-right-to-bracket"></i> Đăng nhập ngay
              </a>
              <a href="/login.html#register" class="btn-user-action primary" style="margin-top:4px;">
                <i class="fa-solid fa-user-plus"></i> Đăng ký tài khoản mới
              </a>
            </div>
          </div>
        </div>
      `;
    }

    modal.classList.add('active');
    document.body.style.overflow = 'hidden';
  },

  closeUserProfileModal() {
    const modal = document.getElementById('userProfileModal');
    if (modal) {
      modal.classList.remove('active');
    }
    document.body.style.overflow = '';
  }
};

document.addEventListener('DOMContentLoaded', () => {
  App.init();
});
