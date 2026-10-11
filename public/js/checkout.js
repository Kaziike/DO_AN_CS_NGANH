/**
 * TECHSTORE - CHECKOUT FLOW CONTROLLER
 */

const Checkout = {
  init() {
    const checkoutModal = document.getElementById('checkoutModal');
    const checkoutForm = document.getElementById('checkoutForm');
    const btnOpenCheckout = document.getElementById('btnOpenCheckout');

    if (btnOpenCheckout) {
      btnOpenCheckout.addEventListener('click', () => {
        const summary = Cart.getSummary();
        if (summary.items.length === 0) {
          showToast('Giỏ hàng của bạn đang trống!', 'error');
          return;
        }
        // Đóng giỏ hàng drawer nếu đang mở
        const drawer = document.getElementById('cartDrawer');
        if (drawer) drawer.classList.remove('open');
        this.openModal();
      });
    }

    // Hỗ trợ tất cả các nút đóng checkout
    const closeButtons = document.querySelectorAll('#closeCheckoutBtn, #closeCheckoutModalBtn, .close-checkout-btn');
    closeButtons.forEach(btn => {
      btn.addEventListener('click', () => this.closeModal());
    });

    // Cho phép click ngoài overlay để đóng
    if (checkoutModal) {
      checkoutModal.addEventListener('click', (e) => {
        if (e.target === checkoutModal) this.closeModal();
      });
    }

    // Cho phép bấm phím ESC để thoát modal
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') this.closeModal();
    });

    // Lựa chọn phương thức thanh toán
    const pmCards = document.querySelectorAll('.payment-method-card');
    pmCards.forEach(card => {
      card.addEventListener('click', () => {
        pmCards.forEach(c => c.classList.remove('active'));
        card.classList.add('active');
        const radio = card.querySelector('input[type="radio"]');
        if (radio) radio.checked = true;
      });
    });

    // Submit form đặt hàng
    if (checkoutForm) {
      checkoutForm.addEventListener('submit', (e) => this.handleSubmit(e));
    }

    // Đồng bộ thay đổi khi giỏ hàng được cập nhật
    if (typeof Cart !== 'undefined' && Cart.onChange) {
      Cart.onChange(() => {
        const modal = document.getElementById('checkoutModal');
        if (modal && modal.classList.contains('active')) {
          this.renderOrderSummary();
        }
      });
    }
  },

  openModal() {
    const summary = Cart.getSummary();
    const modal = document.getElementById('checkoutModal');
    if (!modal) return;

    if (summary.items.length === 0) {
      showToast('Giỏ hàng của bạn đang trống!', 'error');
      return;
    }

    // Tự động điền thông tin nếu người dùng đã đăng nhập
    if (typeof App !== 'undefined' && App.currentUser) {
      const nameInput = document.getElementById('customerName');
      const phoneInput = document.getElementById('customerPhone');
      const emailInput = document.getElementById('customerEmail');
      const addressInput = document.getElementById('customerAddress') || document.getElementById('shippingAddress');

      if (nameInput && !nameInput.value) nameInput.value = App.currentUser.name || '';
      if (phoneInput && !phoneInput.value) phoneInput.value = App.currentUser.phone || '';
      if (emailInput && !emailInput.value) emailInput.value = App.currentUser.email || '';
      if (addressInput && !addressInput.value && App.currentUser.address) addressInput.value = App.currentUser.address;
    }

    this.renderOrderSummary();
    modal.classList.add('active');
  },

  renderOrderSummary() {
    const summary = Cart.getSummary();
    const orderItemsContainer = document.getElementById('checkoutOrderItems');
    if (!orderItemsContainer) return;

    if (summary.items.length === 0) {
      this.closeModal();
      showToast('Giỏ hàng của bạn đang trống!', 'info');
      return;
    }

    // Render danh sách sản phẩm với nút tăng/giảm và nút xóa
    orderItemsContainer.innerHTML = summary.items.map(item => `
      <div class="checkout-item-row">
        <img src="${item.product_image}" alt="${item.product_name}" class="checkout-item-img">
        <div class="checkout-item-details">
          <div class="checkout-item-name" title="${item.product_name}">${item.product_name}</div>
          ${item.variant_name ? `<div class="checkout-item-variant"><i class="fa-solid fa-microchip"></i> ${item.variant_name}</div>` : ''}
          <div class="checkout-item-bottom">
            <div class="quantity-picker" style="height: 26px; padding: 1px;">
              <button type="button" class="quantity-btn" style="width: 22px; height: 22px; font-size: 0.78rem;" onclick="Checkout.changeItemQty('${item.cart_key || item.product_id}', ${item.quantity - 1})">-</button>
              <span class="quantity-input" style="width: 26px; font-size: 0.8rem; font-weight: 800;">${item.quantity}</span>
              <button type="button" class="quantity-btn" style="width: 22px; height: 22px; font-size: 0.78rem;" onclick="Checkout.changeItemQty('${item.cart_key || item.product_id}', ${item.quantity + 1}, ${item.stock})">+</button>
            </div>
            <div class="checkout-item-price">${new Intl.NumberFormat('vi-VN').format(item.subtotal)}₫</div>
          </div>
        </div>
        <button type="button" class="checkout-item-remove-btn" onclick="Checkout.removeItem('${item.cart_key || item.product_id}')" title="Xóa sản phẩm">
          <i class="fa-solid fa-trash-can"></i>
        </button>
      </div>
    `).join('');

    // Đảm bảo có container mã giảm giá trong phần tổng kết đơn hàng
    let couponWrapper = document.getElementById('checkoutCouponWrapper');
    if (!couponWrapper) {
      couponWrapper = document.createElement('div');
      couponWrapper.id = 'checkoutCouponWrapper';
      couponWrapper.className = 'checkout-coupon-wrapper';
      orderItemsContainer.parentNode.insertBefore(couponWrapper, orderItemsContainer.nextSibling);
    }

    if (summary.coupon) {
      couponWrapper.innerHTML = `
        <div class="checkout-applied-coupon">
          <div style="color: #065f46; display: flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-ticket" style="color: #059669; font-size: 1.1rem;"></i>
            <span>Mã: <strong>${summary.coupon.code}</strong> (${summary.coupon.code === 'FREESHIP' ? 'Free ship' : `Giảm ${summary.coupon.discount_percent}%`})</span>
          </div>
          <button type="button" onclick="Checkout.removeCoupon()" style="background: none; border: none; color: #ef4444; font-size: 0.8rem; font-weight: 700; cursor: pointer; text-decoration: underline;">
            Gỡ bỏ
          </button>
        </div>
      `;
    } else {
      couponWrapper.innerHTML = `
        <div class="checkout-coupon-form">
          <input type="text" id="checkoutCouponInput" class="form-control" placeholder="Mã giảm giá (VD: TECH10)...">
          <button type="button" onclick="Checkout.applyCoupon()">Áp dụng</button>
        </div>
      `;
    }

    // Cập nhật số tiền
    const subtotalEl = document.getElementById('checkoutSubtotal');
    const shippingEl = document.getElementById('checkoutShippingFee');
    const discountEl = document.getElementById('checkoutDiscount');
    const totalEl = document.getElementById('checkoutFinalTotal');

    if (subtotalEl) subtotalEl.textContent = new Intl.NumberFormat('vi-VN').format(summary.rawSubtotal) + '₫';
    if (shippingEl) shippingEl.textContent = summary.shippingFee === 0 ? 'Miễn phí' : new Intl.NumberFormat('vi-VN').format(summary.shippingFee) + '₫';
    if (discountEl) discountEl.textContent = '-' + new Intl.NumberFormat('vi-VN').format(summary.discountAmount) + '₫';
    if (totalEl) totalEl.textContent = new Intl.NumberFormat('vi-VN').format(summary.finalTotal) + '₫';
  },

  changeItemQty(itemKey, newQty, maxStock = null) {
    Cart.updateQuantity(itemKey, newQty, maxStock);
    this.renderOrderSummary();
  },

  removeItem(itemKey) {
    Cart.removeItem(itemKey);
    this.renderOrderSummary();
  },

  async applyCoupon() {
    const input = document.getElementById('checkoutCouponInput');
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
        this.renderOrderSummary();
      } else {
        showToast(data.message, 'error');
      }
    } catch (e) {
      showToast('Lỗi khi kiểm tra mã giảm giá', 'error');
    }
  },

  removeCoupon() {
    Cart.setAppliedCoupon(null);
    showToast('Đã gỡ mã giảm giá', 'info');
    this.renderOrderSummary();
  },

  closeModal() {
    const modal = document.getElementById('checkoutModal');
    if (modal) modal.classList.remove('active');
  },

  async handleSubmit(e) {
    e.preventDefault();

    const summary = Cart.getSummary();
    if (summary.items.length === 0) {
      showToast('Giỏ hàng trống!', 'error');
      return;
    }

    const name = document.getElementById('customerName')?.value?.trim();
    const phone = document.getElementById('customerPhone')?.value?.trim();
    const email = document.getElementById('customerEmail')?.value?.trim() || '';

    const addressInput = document.getElementById('customerAddress') || document.getElementById('shippingAddress');
    const address = addressInput ? addressInput.value.trim() : '';

    const notesInput = document.getElementById('orderNotes');
    const notes = notesInput ? notesInput.value.trim() : '';

    const shippingMethodInput = document.getElementById('shippingMethod');
    const shippingMethod = shippingMethodInput ? shippingMethodInput.value : 'Tiêu chuẩn';

    const paymentMethodEl = document.querySelector('input[name="payment_method"]:checked');
    const paymentMethod = paymentMethodEl ? paymentMethodEl.value : 'cod';

    if (!name || !phone || !address) {
      showToast('Vui lòng điền đủ họ tên, số điện thoại và địa chỉ giao hàng!', 'error');
      return;
    }

    const submitBtn = document.getElementById('btnSubmitOrder');
    if (submitBtn) {
      submitBtn.disabled = true;
      submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang tạo đơn hàng...';
    }

    try {
      // 1. Tạo đơn hàng vào database
      const orderPayload = {
        user_id: (typeof App !== 'undefined' && App.currentUser) ? App.currentUser.id : null,
        customer_name: name,
        customer_phone: phone,
        customer_email: email,
        shipping_address: address,
        shipping_notes: notes,
        shipping_method: shippingMethod,
        shipping_fee: summary.shippingFee,
        discount_amount: summary.discountAmount,
        total_amount: summary.finalTotal,
        payment_method: paymentMethod,
        notes,
        items: summary.items
      };

      const res = await fetch('/api/orders', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(orderPayload)
      });
      const data = await res.json();

      if (!data.success) {
        throw new Error(data.message || 'Lỗi khi tạo đơn hàng');
      }

      const createdOrder = data.data;

      // 2. Kiểm tra phương thức thanh toán
      if (paymentMethod === 'cod') {
        // Hoàn tất với COD
        Cart.clear();
        this.closeModal();
        this.showSuccessModal(createdOrder);
        if (typeof App !== 'undefined') {
          if (App.refreshProductsData) App.refreshProductsData();
          else if (App.loadProducts) App.loadProducts();
        }
      } else {
        // Thanh toán qua cổng mô phỏng VNPay / MoMo
        this.closeModal();
        PaymentGateway.open({
          order_id: createdOrder.id,
          order_code: createdOrder.order_code,
          amount: createdOrder.total_amount,
          method: paymentMethod,
          customer_name: name,
          onSuccess: (paymentResult) => {
            Cart.clear();
            createdOrder.payment_status = 'paid';
            createdOrder.order_status = 'confirmed';
            showToast('Thanh toán trực tuyến thành công!', 'success');
            this.showSuccessModal(createdOrder);
            if (typeof App !== 'undefined') {
              if (App.refreshProductsData) App.refreshProductsData();
              else if (App.loadProducts) App.loadProducts();
            }
          },
          onCancel: () => {
            showToast(`Bạn đã hủy thanh toán đơn hàng ${createdOrder.order_code}`, 'warning');
            this.showCancelledPaymentModal(createdOrder, paymentMethod);
          }
        });
      }
    } catch (err) {
      showToast(err.message, 'error');
    } finally {
      if (submitBtn) {
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<i class="fa-solid fa-lock"></i> ĐẶT HÀNG NGAY';
      }
    }
  },

  showSuccessModal(order) {
    const modal = document.getElementById('orderSuccessModal');
    if (!modal) return;

    const codeEl = document.getElementById('successOrderCode');
    if (codeEl) codeEl.textContent = order.order_code;

    const nameEl = document.getElementById('successCustomerName');
    if (nameEl) nameEl.textContent = order.customer_name;

    const phoneEl = document.getElementById('successCustomerPhone');
    if (phoneEl) phoneEl.textContent = order.customer_phone;

    const addressEl = document.getElementById('successCustomerAddress');
    if (addressEl) addressEl.textContent = order.shipping_address;

    const orderNoteEl = document.getElementById('successOrderNote');
    if (orderNoteEl) orderNoteEl.textContent = order.notes;

    const totalEl = document.getElementById('successTotalAmount');
    if (totalEl) totalEl.textContent = new Intl.NumberFormat('vi-VN').format(order.total_amount) + '₫';

    const payStatusEl = document.getElementById('successPaymentStatus');
    if (payStatusEl) {
      if (order.payment_status === 'paid') {
        payStatusEl.innerHTML = `<span style="color: #10b981; font-weight: 700;"><i class="fa-solid fa-circle-check"></i> Đã thanh toán (${(order.payment_method || 'ONLINE').toUpperCase()})</span>`;
      } else {
        payStatusEl.innerHTML = '<span style="color: #f59e0b; font-weight: 700;"><i class="fa-solid fa-clock"></i> Thanh toán khi nhận hàng (COD)</span>';
      }
    }

    modal.classList.add('active');
  },

  showCancelledPaymentModal(order, paymentMethod) {
    const modal = document.getElementById('orderCancelledModal');
    if (!modal) return;

    const codeEl = document.getElementById('cancelledOrderCode');
    if (codeEl) codeEl.textContent = order.order_code;

    const nameEl = document.getElementById('cancelledCustomerName');
    if (nameEl) nameEl.textContent = order.customer_name;

    const totalEl = document.getElementById('cancelledTotalAmount');
    if (totalEl) totalEl.textContent = new Intl.NumberFormat('vi-VN').format(order.total_amount) + '₫';

    const retryBtn = document.getElementById('btnRetryPayment');
    if (retryBtn) {
      retryBtn.onclick = () => {
        modal.classList.remove('active');
        PaymentGateway.open({
          order_id: order.id,
          order_code: order.order_code,
          amount: order.total_amount,
          method: paymentMethod,
          customer_name: order.customer_name,
          onSuccess: (paymentResult) => {
            Cart.clear();
            order.payment_status = 'paid';
            order.order_status = 'confirmed';
            showToast('Thanh toán trực tuyến thành công!', 'success');
            this.showSuccessModal(order);
            if (typeof App !== 'undefined' && App.loadProducts) App.loadProducts();
          },
          onCancel: () => {
            this.showCancelledPaymentModal(order, paymentMethod);
          }
        });
      };
    }

    modal.classList.add('active');
  }
};
