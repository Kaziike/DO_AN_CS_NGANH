/**
 * TECHSTORE - ADMIN DASHBOARD SCRIPT
 */

const Admin = {
  currentTab: 'orders',
  orders: [],
  products: [],
  flashSales: [],
  categories: [],
  currentUser: null,

  async init() {
    // 1. Phân quyền: Kiểm tra người dùng có quyền Admin không
    const savedUser = localStorage.getItem('techstore_user');
    let user = null;
    try {
      user = savedUser ? JSON.parse(savedUser) : null;
    } catch (e) {
      user = null;
    }

    if (!user || user.role !== 'admin') {
      alert('Truy cập bị từ chối! Trang quản trị chỉ dành riêng cho tài khoản Quản Trị Viên (Admin).');
      window.location.href = '/login.html?redirect=/admin.html';
      return;
    }

    this.currentUser = user;
    this.renderAdminProfile();

    this.bindTabs();
    this.bindOrderEvents();
    this.bindProductEvents();
    this.bindFlashSaleEvents();

    await this.loadStats();
    await this.loadCategories();
    await this.loadOrders();
    await this.loadProducts();
    await this.loadFlashSales();
  },

  renderAdminProfile() {
    const nameEl = document.getElementById('adminUserName');
    if (nameEl && this.currentUser) {
      nameEl.textContent = this.currentUser.name || 'Quản Trị Viên';
    }
  },

  logout() {
    if (confirm('Bạn có chắc chắn muốn đăng xuất khỏi trang quản trị?')) {
      localStorage.removeItem('techstore_user');
      window.location.href = '/login.html';
    }
  },

  getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      'x-user-role': this.currentUser ? this.currentUser.role : 'admin',
      'x-user-id': this.currentUser ? this.currentUser.id : ''
    };
  },

  // 1. Chuyển Tab
  bindTabs() {
    const tabs = document.querySelectorAll('.admin-tab-btn');
    tabs.forEach(tab => {
      tab.addEventListener('click', () => {
        tabs.forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        const target = tab.getAttribute('data-tab');
        this.currentTab = target;

        document.getElementById('ordersSection').style.display = target === 'orders' ? 'block' : 'none';
        document.getElementById('productsSection').style.display = target === 'products' ? 'block' : 'none';
        const fsSection = document.getElementById('flashsalesSection');
        if (fsSection) {
          fsSection.style.display = target === 'flashsales' ? 'block' : 'none';
        }
      });
    });
  },

  // 2. Tải Thống kê hệ thống
  async loadStats() {
    try {
      const res = await fetch('/api/stats', { headers: this.getAuthHeaders() });
      const data = await res.json();
      if (data.success) {
        const s = data.data;
        document.getElementById('statTotalRevenue').textContent = new Intl.NumberFormat('vi-VN').format(s.totalRevenue) + 'đ';
        document.getElementById('statTotalOrders').textContent = s.totalOrders;
        document.getElementById('statTotalProducts').textContent = s.totalProducts;
        document.getElementById('statTotalReviews').textContent = s.totalReviews;

        // DB Status Pill
        const pill = document.getElementById('adminDbStatusPill');
        if (pill) {
          if (s.dbMode === 'mysql') {
            pill.className = 'db-status-pill mysql';
            pill.innerHTML = '<i class="fa-solid fa-database"></i> MySQL: Đang kết nối';
          } else {
            pill.className = 'db-status-pill fallback';
            pill.innerHTML = '<i class="fa-solid fa-server"></i> Local Storage Mode';
          }
        }
      }
    } catch (e) {
      console.error('Lỗi khi tải thống kê:', e);
    }
  },

  async loadCategories() {
    try {
      const res = await fetch('/api/categories');
      const data = await res.json();
      if (data.success) {
        this.categories = data.data;
        const select = document.getElementById('prodCategorySelect');
        if (select) {
          select.innerHTML = this.categories.map(c => `<option value="${c.id}">${c.name}</option>`).join('');
        }
      }
    } catch (e) {
      console.error(e);
    }
  },

  // 3. Quản lý Đơn hàng
  async loadOrders() {
    const tbody = document.getElementById('adminOrdersTableBody');
    if (!tbody) return;

    tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 24px;">Đang tải danh sách đơn hàng...</td></tr>';

    try {
      const res = await fetch('/api/orders', { headers: this.getAuthHeaders() });
      const data = await res.json();
      if (data.success) {
        this.orders = data.data;
        this.renderOrdersTable(this.orders);
      }
    } catch (e) {
      tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; color: #ef4444;">Lỗi khi tải đơn hàng</td></tr>';
    }
  },

  renderOrdersTable(orders) {
    const tbody = document.getElementById('adminOrdersTableBody');
    if (!tbody) return;

    if (!orders || orders.length === 0) {
      tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 30px; color: #94a3b8;">Chưa có đơn hàng nào</td></tr>';
      return;
    }

    tbody.innerHTML = orders.map(o => {
      const dateStr = new Date(o.created_at).toLocaleDateString('vi-VN', { hour: '2-digit', minute: '2-digit' });
      return `
        <tr>
          <td><strong style="color: #38bdf8;">${o.order_code}</strong></td>
          <td>
            <div style="font-weight: 600; color: #f8fafc;">${o.customer_name}</div>
            <div style="font-size: 0.78rem; color: #94a3b8;">${o.customer_phone}</div>
          </td>
          <td>${dateStr}</td>
          <td><strong style="color: #38bdf8;">${new Intl.NumberFormat('vi-VN').format(o.total_amount)}đ</strong></td>
          <td>
            <span class="status-badge status-${o.payment_status}">
              ${o.payment_status === 'paid' ? 'Đã thanh toán' : 'Chưa thanh toán'}
            </span>
            <div style="font-size: 0.75rem; color: #94a3b8; text-transform: uppercase; margin-top: 2px;">
              ${o.payment_method}
            </div>
          </td>
          <td>
            <span class="status-badge status-${o.order_status}">
              ${o.order_status}
            </span>
          </td>
          <td>
            <button class="btn-action-sm" onclick="Admin.openOrderStatusModal('${o.order_code}')">
              <i class="fa-solid fa-pen-to-square"></i> Cập nhật
            </button>
          </td>
        </tr>
      `;
    }).join('');
  },

  bindOrderEvents() {
    // Lọc đơn hàng theo trạng thái
    const statusFilter = document.getElementById('orderStatusFilter');
    if (statusFilter) {
      statusFilter.addEventListener('change', (e) => {
        const val = e.target.value;
        if (val === 'all') {
          this.renderOrdersTable(this.orders);
        } else {
          const filtered = this.orders.filter(o => o.order_status === val);
          this.renderOrdersTable(filtered);
        }
      });
    }

    // Modal cập nhật trạng thái đơn
    const form = document.getElementById('updateOrderStatusForm');
    if (form) {
      form.addEventListener('submit', async (e) => {
        e.preventDefault();
        const code = document.getElementById('updateOrderCode').value;
        const order_status = document.getElementById('newOrderStatus').value;
        const payment_status = document.getElementById('newPaymentStatus').value;

        try {
          const res = await fetch(`/api/orders/${code}/status`, {
            method: 'PATCH',
            headers: this.getAuthHeaders(),
            body: JSON.stringify({ order_status, payment_status })
          });
          const data = await res.json();
          if (data.success) {
            alert('Cập nhật trạng thái đơn hàng thành công!');
            document.getElementById('orderStatusModal').classList.remove('active');
            await this.loadStats();
            await this.loadOrders();
          }
        } catch (err) {
          alert('Lỗi cập nhật đơn hàng');
        }
      });
    }
  },

  openOrderStatusModal(orderCode) {
    const order = this.orders.find(o => o.order_code === orderCode);
    if (!order) return;

    document.getElementById('updateOrderCode').value = order.order_code;
    document.getElementById('modalOrderCodeDisplay').textContent = order.order_code;
    document.getElementById('newOrderStatus').value = order.order_status;
    document.getElementById('newPaymentStatus').value = order.payment_status;

    document.getElementById('orderStatusModal').classList.add('active');
  },

  // 4. Quản lý Sản phẩm
  async loadProducts() {
    const tbody = document.getElementById('adminProductsTableBody');
    if (!tbody) return;

    tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 24px;">Đang tải danh sách sản phẩm...</td></tr>';

    try {
      const res = await fetch('/api/products?limit=100');
      const data = await res.json();
      if (data.success) {
        this.products = data.data.products;
        this.renderProductsTable(this.products);
      }
    } catch (e) {
      tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; color: #ef4444;">Lỗi tải sản phẩm</td></tr>';
    }
  },

  renderProductsTable(products) {
    const tbody = document.getElementById('adminProductsTableBody');
    if (!tbody) return;

    if (!products || products.length === 0) {
      tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 30px; color: #94a3b8;">Không có sản phẩm nào</td></tr>';
      return;
    }

    tbody.innerHTML = products.map(p => `
      <tr>
        <td style="width: 60px;">
          <img src="${p.image_url}" alt="${p.name}" style="width: 48px; height: 48px; object-fit: cover; border-radius: 6px;">
        </td>
        <td>
          <div style="font-weight: 700; color: #f8fafc; max-width: 280px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
            ${p.name}
          </div>
          <span style="font-size: 0.78rem; color: #38bdf8; text-transform: uppercase;">${p.brand}</span>
        </td>
        <td>${p.category_name || 'Công nghệ'}</td>
        <td><strong style="color: #38bdf8;">${new Intl.NumberFormat('vi-VN').format(p.price)}đ</strong></td>
        <td>
          <span style="font-weight: 700; color: ${p.stock > 10 ? '#10b981' : (p.stock > 0 ? '#f59e0b' : '#ef4444')};">
            ${p.stock}
          </span>
        </td>
        <td>
          <i class="fa-solid fa-star" style="color: #f59e0b;"></i> ${p.rating} (${p.reviews_count})
        </td>
        <td>
          <div style="display: flex; gap: 6px;">
            <button class="btn-action-sm" onclick="Admin.openEditProductModal(${p.id})">
              <i class="fa-solid fa-pen"></i>
            </button>
            <button class="btn-action-sm btn-delete-sm" onclick="Admin.deleteProduct(${p.id})">
              <i class="fa-solid fa-trash"></i>
            </button>
          </div>
        </td>
      </tr>
    `).join('');
  },

  bindProductEvents() {
    // Nút mở modal thêm mới
    const addBtn = document.getElementById('btnOpenAddProduct');
    if (addBtn) {
      addBtn.addEventListener('click', () => {
        document.getElementById('productFormModalTitle').textContent = 'Thêm sản phẩm mới';
        document.getElementById('productForm').reset();
        document.getElementById('editProductId').value = '';
        document.getElementById('productModal').classList.add('active');
      });
    }

    // Submit form thêm/sửa sản phẩm
    const form = document.getElementById('productForm');
    if (form) {
      form.addEventListener('submit', async (e) => {
        e.preventDefault();
        const id = document.getElementById('editProductId').value;
        const name = document.getElementById('prodName').value.trim();
        const category_id = document.getElementById('prodCategorySelect').value;
        const brand = document.getElementById('prodBrand').value.trim();
        const price = Number(document.getElementById('prodPrice').value);
        const original_price = Number(document.getElementById('prodOriginalPrice').value) || price;
        const stock = Number(document.getElementById('prodStock').value) || 10;
        const image_url = document.getElementById('prodImageUrl').value.trim();
        const short_description = document.getElementById('prodShortDesc').value.trim();
        const featured = document.getElementById('prodFeatured').checked ? 1 : 0;

        let specifications = {};
        try {
          const rawSpecs = document.getElementById('prodSpecs').value.trim();
          if (rawSpecs) specifications = JSON.parse(rawSpecs);
        } catch (err) {
          alert('Định dạng thông số JSON không hợp lệ! Vui lòng nhập chuẩn {"CPU": "...", "RAM": "..."}');
          return;
        }

        const rawImages = document.getElementById('prodImages')?.value?.trim() || '';
        const extraImages = rawImages ? rawImages.split('\n').map(s => s.trim()).filter(Boolean) : [];
        const allImages = Array.from(new Set([image_url, ...extraImages]));

        const payload = {
          name,
          category_id,
          brand,
          price,
          original_price,
          stock,
          image_url,
          images: allImages,
          short_description,
          featured,
          specifications
        };

        try {
          const url = id ? `/api/products/${id}` : '/api/products';
          const method = id ? 'PUT' : 'POST';

          const res = await fetch(url, {
            method,
            headers: this.getAuthHeaders(),
            body: JSON.stringify(payload)
          });
          const data = await res.json();

          if (data.success) {
            alert(id ? 'Cập nhật sản phẩm thành công!' : 'Thêm sản phẩm mới thành công!');
            document.getElementById('productModal').classList.remove('active');
            await this.loadStats();
            await this.loadProducts();
          } else {
            alert(data.message || 'Lỗi lưu sản phẩm');
          }
        } catch (err) {
          alert('Lỗi kết nối tới server khi lưu sản phẩm');
        }
      });
    }

    // Tìm kiếm sản phẩm trong admin
    const searchInput = document.getElementById('adminProductSearch');
    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        const q = e.target.value.toLowerCase().trim();
        const filtered = this.products.filter(p => 
          p.name.toLowerCase().includes(q) || 
          p.brand.toLowerCase().includes(q)
        );
        this.renderProductsTable(filtered);
      });
    }
  },

  openEditProductModal(id) {
    const p = this.products.find(item => item.id == id);
    if (!p) return;

    document.getElementById('productFormModalTitle').textContent = 'Chỉnh sửa thông tin sản phẩm';
    document.getElementById('editProductId').value = p.id;
    document.getElementById('prodName').value = p.name;
    document.getElementById('prodCategorySelect').value = p.category_id;
    document.getElementById('prodBrand').value = p.brand;
    document.getElementById('prodPrice').value = p.price;
    document.getElementById('prodOriginalPrice').value = p.original_price;
    document.getElementById('prodStock').value = p.stock;
    document.getElementById('prodImageUrl').value = p.image_url;
    document.getElementById('prodShortDesc').value = p.short_description || '';
    document.getElementById('prodFeatured').checked = p.featured == 1;
    document.getElementById('prodSpecs').value = JSON.stringify(p.specifications || {}, null, 2);

    const imagesInput = document.getElementById('prodImages');
    if (imagesInput) {
      const extra = Array.isArray(p.images) ? p.images.filter(img => img !== p.image_url) : [];
      imagesInput.value = extra.join('\n');
    }

    document.getElementById('productModal').classList.add('active');
  },

  async deleteProduct(id) {
    if (!confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi hệ thống?')) return;

    try {
      const res = await fetch(`/api/products/${id}`, {
        method: 'DELETE',
        headers: this.getAuthHeaders()
      });
      const data = await res.json();
      if (data.success) {
        alert('Xóa sản phẩm thành công!');
        await this.loadStats();
        await this.loadProducts();
      }
    } catch (e) {
      alert('Lỗi khi xóa sản phẩm');
    }
  },

  // 5. QUẢN LÝ FLASHSALE (DỮ LIỆU TỪ MYSQL)
  async loadFlashSales() {
    const tbody = document.getElementById('adminFlashSalesTableBody');
    if (!tbody) return;

    tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; padding: 24px;">Đang tải danh sách Flash Sale từ MySQL...</td></tr>';

    try {
      const res = await fetch('/api/flash-sales');
      const data = await res.json();
      if (data.success) {
        this.flashSales = data.data || [];
        this.renderFlashSalesTable(this.flashSales);
      }
    } catch (e) {
      console.error('Lỗi khi tải Flash Sales:', e);
      tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: #ef4444;">Lỗi khi tải danh sách Flash Sale từ cơ sở dữ liệu!</td></tr>';
    }
  },

  renderFlashSalesTable(items) {
    const tbody = document.getElementById('adminFlashSalesTableBody');
    if (!tbody) return;

    if (!items || items.length === 0) {
      tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; padding: 30px; color: #94a3b8;">Chưa có sản phẩm nào trong chương trình Flash Sale</td></tr>';
      return;
    }

    tbody.innerHTML = items.map(item => {
      const sold = item.sold_count || 0;
      const stock = item.flash_stock || 10;
      const pct = Math.min(100, Math.round((sold / stock) * 100));
      const formattedFlashPrice = new Intl.NumberFormat('vi-VN').format(item.flash_price);
      const original = item.original_price || item.price;
      const formattedOriginalPrice = new Intl.NumberFormat('vi-VN').format(original);

      return `
        <tr>
          <td><strong>#FS-${item.id}</strong></td>
          <td>
            <img src="${item.image_url}" alt="${item.name}" style="width: 48px; height: 48px; object-fit: contain; border-radius: 8px; background: #0f172a; border: 1px solid rgba(255,255,255,0.06);">
          </td>
          <td>
            <strong style="color: #f8fafc; font-size: 0.92rem;">${item.name}</strong>
            <div style="font-size: 0.8rem; color: #94a3b8; margin-top: 2px;">Hãng: ${item.brand || 'Khác'}</div>
          </td>
          <td>
            <span style="color: #ef4444; font-weight: 700; font-size: 1rem;">${formattedFlashPrice}₫</span>
          </td>
          <td>
            <span style="text-decoration: line-through; color: #94a3b8; font-size: 0.88rem;">${formattedOriginalPrice}₫</span>
          </td>
          <td style="min-width: 140px;">
            <div style="display: flex; justify-content: space-between; font-size: 0.78rem; margin-bottom: 4px; color: #cbd5e1;">
              <span>Đã bán: <b>${sold}</b>/${stock}</span>
              <span><b>${pct}%</b></span>
            </div>
            <div style="width: 100%; height: 6px; background: rgba(255,255,255,0.1); border-radius: 99px; overflow: hidden;">
              <div style="width: ${pct}%; height: 100%; background: linear-gradient(90deg, #f59e0b, #ef4444); border-radius: 99px;"></div>
            </div>
          </td>
          <td>
            <span class="badge" style="background: rgba(16, 185, 129, 0.15); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.3); padding: 4px 10px; border-radius: 99px; font-size: 0.78rem;">
              <i class="fa-solid fa-bolt"></i> Đang mở bán
            </span>
          </td>
          <td>
            <button class="btn-action delete" title="Xóa khỏi Flash Sale" onclick="Admin.deleteFlashSale(${item.id})">
              <i class="fa-solid fa-trash"></i>
            </button>
          </td>
        </tr>
      `;
    }).join('');
  },

  bindFlashSaleEvents() {
    const btnOpen = document.getElementById('btnOpenAddFlashSale');
    const modal = document.getElementById('addFlashSaleModal');
    const form = document.getElementById('addFlashSaleForm');
    const select = document.getElementById('fsProductSelect');
    const priceInput = document.getElementById('fsPriceInput');

    if (btnOpen && modal) {
      btnOpen.addEventListener('click', () => {
        // Populate select list with available products
        if (select) {
          select.innerHTML = '<option value="">-- Chọn sản phẩm công nghệ --</option>' + 
            this.products.map(p => {
              const formattedPrice = new Intl.NumberFormat('vi-VN').format(p.price);
              return `<option value="${p.id}" data-price="${p.price}">${p.name} (${p.brand}) - Giá gốc: ${formattedPrice}₫</option>`;
            }).join('');
        }
        form.reset();
        modal.classList.add('active');
      });
    }

    if (select && priceInput) {
      select.addEventListener('change', () => {
        const selectedOpt = select.options[select.selectedIndex];
        if (selectedOpt && selectedOpt.dataset.price) {
          const original = Number(selectedOpt.dataset.price);
          // Gợi ý giảm 15%
          priceInput.value = Math.round(original * 0.85);
        }
      });
    }

    if (form) {
      form.addEventListener('submit', async (e) => {
        e.preventDefault();
        const productId = select.value;
        const flashPrice = Number(document.getElementById('fsPriceInput').value);
        const flashStock = Number(document.getElementById('fsStockInput').value) || 20;

        if (!productId || !flashPrice) {
          alert('Vui lòng chọn sản phẩm và nhập giá Flash Sale hợp lệ!');
          return;
        }

        try {
          const res = await fetch('/api/flash-sales', {
            method: 'POST',
            headers: this.getAuthHeaders(),
            body: JSON.stringify({
              product_id: productId,
              flash_price: flashPrice,
              flash_stock: flashStock
            })
          });

          const data = await res.json();
          if (data.success) {
            alert('Đã thêm sản phẩm vào chương trình Flash Sale thành công!');
            modal.classList.remove('active');
            form.reset();
            await this.loadFlashSales();
          } else {
            alert('Thất bại: ' + (data.message || 'Không thể lưu Flash Sale'));
          }
        } catch (err) {
          console.error(err);
          alert('Lỗi kết nối máy chủ khi lưu Flash Sale');
        }
      });
    }
  },

  async deleteFlashSale(id) {
    if (!confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi chương trình Flash Sale?')) return;

    try {
      const res = await fetch(`/api/flash-sales/${id}`, {
        method: 'DELETE',
        headers: this.getAuthHeaders()
      });
      const data = await res.json();
      if (data.success) {
        alert('Đã xóa thành công!');
        await this.loadFlashSales();
      } else {
        alert('Không thể xóa: ' + (data.message || 'Lỗi server'));
      }
    } catch (e) {
      console.error(e);
      alert('Lỗi khi xóa Flash Sale');
    }
  }
};

document.addEventListener('DOMContentLoaded', () => {
  Admin.init();
});
