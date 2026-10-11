/**
 * TECHSTORE - SHOPPING CART LOGIC (LocalStorage + Reactive UI)
 */

const Cart = {
  storageKey: 'techstore_cart_v1',
  couponKey: 'techstore_applied_coupon',

  getItems() {
    try {
      const data = localStorage.getItem(this.storageKey);
      return data ? JSON.parse(data) : [];
    } catch (e) {
      return [];
    }
  },

  saveItems(items) {
    localStorage.setItem(this.storageKey, JSON.stringify(items));
    this.notifyChange();
  },

  addItem(product, quantity = 1, variant = null) {
    const vStock = (variant && variant.stock !== undefined) ? Number(variant.stock) : 999;
    const pStock = (product && product.stock !== undefined) ? Number(product.stock) : 999;
    const stockLimit = Math.min(vStock, pStock);

    if (stockLimit <= 0) {
      return { success: false, message: `Sản phẩm "${product.name}" hiện đã hết hàng!` };
    }

    const items = this.getItems();
    const itemKey = variant && variant.name ? `${product.id}_${variant.name}` : `${product.id}`;
    const existingIndex = items.findIndex(item => (item.cart_key || `${item.product_id}`) === itemKey);

    const currentQty = existingIndex > -1 ? items[existingIndex].quantity : 0;
    const requestedQty = Math.max(1, Number(quantity) || 1);

    if (currentQty + requestedQty > stockLimit) {
      const remainingCanAdd = Math.max(0, stockLimit - currentQty);
      return {
        success: false,
        message: remainingCanAdd > 0
          ? `Kho chỉ còn ${stockLimit} sản phẩm (bạn đã có ${currentQty} trong giỏ, chỉ có thể thêm tối đa ${remainingCanAdd})!`
          : `Bạn đã có tối đa ${stockLimit} sản phẩm trong giỏ hàng, không thể thêm tiếp!`
      };
    }

    const unitPrice = variant && variant.price ? Number(variant.price) : Number(product.price);
    const origPrice = variant && variant.original_price ? Number(variant.original_price) : Number(product.original_price || product.price);

    if (existingIndex > -1) {
      items[existingIndex].quantity += requestedQty;
      items[existingIndex].subtotal = items[existingIndex].quantity * items[existingIndex].price;
      items[existingIndex].stock = stockLimit;
    } else {
      items.push({
        cart_key: itemKey,
        product_id: product.id,
        product_name: product.name,
        variant_name: variant ? variant.name : null,
        product_image: (variant && variant.image) || product.image_url,
        price: unitPrice,
        original_price: origPrice,
        brand: product.brand,
        stock: stockLimit,
        quantity: requestedQty,
        subtotal: unitPrice * requestedQty
      });
    }

    this.saveItems(items);
    return { success: true, message: `Đã thêm ${requestedQty} x "${product.name}" vào giỏ hàng!` };
  },

  updateQuantity(itemKey, quantity, maxStock = null) {
    let items = this.getItems();
    if (quantity <= 0) {
      this.removeItem(itemKey);
      return;
    }

    const item = items.find(i => (i.cart_key || `${i.product_id}`) === `${itemKey}`);
    if (item) {
      const limit = maxStock !== null ? Number(maxStock) : (item.stock !== undefined ? Number(item.stock) : 999);
      if (quantity > limit) {
        quantity = limit;
        if (typeof showToast === 'function') {
          showToast(`Số lượng tối đa có thể mua là ${limit} sản phẩm!`, 'info');
        }
      }
      item.quantity = Math.max(1, quantity);
      item.subtotal = item.quantity * item.price;
      this.saveItems(items);
    }
  },

  removeItem(itemKey) {
    let items = this.getItems();
    items = items.filter(i => (i.cart_key || `${i.product_id}`) !== `${itemKey}`);
    this.saveItems(items);
  },

  clear() {
    localStorage.removeItem(this.storageKey);
    localStorage.removeItem(this.couponKey);
    this.notifyChange();
  },

  getAppliedCoupon() {
    try {
      const c = localStorage.getItem(this.couponKey);
      return c ? JSON.parse(c) : null;
    } catch (e) {
      return null;
    }
  },

  setAppliedCoupon(coupon) {
    if (!coupon) {
      localStorage.removeItem(this.couponKey);
    } else {
      localStorage.setItem(this.couponKey, JSON.stringify(coupon));
    }
    this.notifyChange();
  },

  getSummary() {
    const items = this.getItems();
    const rawSubtotal = items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    const totalCount = items.reduce((sum, item) => sum + item.quantity, 0);

    const coupon = this.getAppliedCoupon();
    let discountAmount = 0;
    if (coupon) {
      if (coupon.code === 'FREESHIP') {
        discountAmount = 30000;
      } else {
        discountAmount = Math.min((rawSubtotal * coupon.discount_percent) / 100, coupon.max_discount || 500000);
      }
    }

    const shippingFee = rawSubtotal > 0 ? (rawSubtotal >= 5000000 ? 0 : 30000) : 0;
    const finalTotal = Math.max(0, rawSubtotal - discountAmount + shippingFee);

    return {
      items,
      rawSubtotal,
      totalCount,
      shippingFee,
      discountAmount,
      finalTotal,
      coupon
    };
  },

  // Đăng ký listener để cập nhật giao diện khi giỏ hàng thay đổi
  listeners: [],
  onChange(fn) {
    this.listeners.push(fn);
  },
  notifyChange() {
    const summary = this.getSummary();
    this.listeners.forEach(fn => fn(summary));
  }
};
