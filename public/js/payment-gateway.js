/**
 * TECHSTORE - SIMULATED PAYMENT GATEWAY (VNPAY / MOMO / CARD)
 */

const PaymentGateway = {
  activeTimer: null,

  open({ order_id, order_code, amount, method, customer_name, onSuccess, onCancel }) {
    this.close(); // Đóng modal cũ nếu có

    // Tạo modal HTML động
    const modal = document.createElement('div');
    modal.id = 'simulatedPaymentModal';
    modal.className = 'modal-overlay active';

    const formattedAmount = new Intl.NumberFormat('vi-VN').format(amount) + 'đ';

    let headerClass = 'vnpay';
    let brandTitle = 'Cổng thanh toán VNPAY-QR';
    let brandDesc = 'Quét mã bằng ứng dụng ngân hàng';
    let logoText = 'VNPAY';
    let qrUrl = `https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=VNPAY_QR_${order_code}_${amount}`;
    let demoOtp = '123456';

    if (method === 'momo') {
      headerClass = 'momo';
      brandTitle = 'Ví Điện Tử MoMo';
      brandDesc = 'Quét mã QR bằng App MoMo để thanh toán';
      logoText = 'MoMo';
      qrUrl = `https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=MOMO_PAY_${order_code}_${amount}`;
      demoOtp = '654321';
    } else if (method === 'credit_card') {
      headerClass = 'card';
      brandTitle = 'Cổng Thẻ Quốc Tế 3D Secure';
      brandDesc = 'Xác thực OTP ngân hàng phát hành thẻ';
      logoText = 'VISA / MC';
      demoOtp = '888888';
    }

    modal.innerHTML = `
      <div class="modal-content payment-gateway-modal">
        <div class="gateway-header ${headerClass}">
          <div class="gateway-brand">
            <div class="gateway-logo-badge">${logoText}</div>
            <div class="gateway-title-group">
              <h3>${brandTitle}</h3>
              <p>${brandDesc}</p>
            </div>
          </div>
          <div class="gateway-security-badge">
            <i class="fa-solid fa-shield-halved"></i> Bảo mật PCI-DSS
          </div>
        </div>

        <div class="gateway-body">
          <div class="payment-order-summary">
            <div>
              <div style="font-size: 0.82rem; color: #94a3b8;">Mã đơn hàng: <strong style="color: #fff;">${order_code}</strong></div>
              <div style="font-size: 0.82rem; color: #94a3b8;">Khách hàng: <strong style="color: #fff;">${customer_name || 'Khách lẻ'}</strong></div>
            </div>
            <div class="pos-amount">${formattedAmount}</div>
          </div>

          ${method === 'credit_card' ? `
            <div class="sim-credit-card">
              <div class="card-top-row">
                <div class="card-chip"></div>
                <div class="card-brand-logo">VISA</div>
              </div>
              <div class="card-number-display">•••• •••• •••• 9820</div>
              <div class="card-bottom-row">
                <div>
                  <div style="font-size: 0.65rem; opacity: 0.7;">CHỦ THẺ</div>
                  <div style="font-weight: 700;">${(customer_name || 'NGUYEN VAN A').toUpperCase()}</div>
                </div>
                <div>
                  <div style="font-size: 0.65rem; opacity: 0.7;">HẾT HẠN</div>
                  <div style="font-weight: 700;">12/28</div>
                </div>
              </div>
            </div>
          ` : `
            <div class="qr-container">
              <div class="qr-box">
                <div class="qr-scanner-line"></div>
                <img src="${qrUrl}" alt="Mã QR thanh toán">
              </div>
              <div class="qr-timer">
                <i class="fa-regular fa-clock"></i> Mã QR hết hạn sau: <strong id="qrCountdownText">10:00</strong>
              </div>
            </div>
          `}

          <div class="sim-instructions">
            <strong><i class="fa-solid fa-circle-info"></i> Mô phỏng thanh toán thử nghiệm:</strong>
            <ol>
              <li>Hệ thống giả lập môi trường Sandbox thực tế cho đồ án.</li>
              <li>Bấm nút <strong>"Điền OTP Test"</strong> để tự động nhập mã OTP giả lập: <code>${demoOtp}</code>.</li>
              <li>Bấm <strong>"Xác nhận thanh toán"</strong> để hoàn tất đơn hàng.</li>
            </ol>
          </div>

          <div class="otp-simulation-row">
            <input type="text" id="simOtpInput" class="otp-input-field" maxlength="6" placeholder="Mã OTP" value="${demoOtp}">
            <button type="button" class="btn-autofill-otp" id="btnAutofillOtp">
              <i class="fa-solid fa-wand-magic-sparkles"></i> OTP Test: ${demoOtp}
            </button>
          </div>

          <div class="gateway-actions">
            <button type="button" class="btn-gateway-cancel" id="btnCancelPayment">Hủy bỏ</button>
            <button type="button" class="btn-gateway-confirm" id="btnConfirmPayment">
              <i class="fa-solid fa-lock"></i> Xác nhận thanh toán
            </button>
          </div>
        </div>
      </div>
    `;

    document.body.appendChild(modal);

    // Bắt đầu đếm ngược 10 phút
    this.startCountdown(600);

    // Gán sự kiện
    const autofillBtn = modal.querySelector('#btnAutofillOtp');
    const otpInput = modal.querySelector('#simOtpInput');
    const confirmBtn = modal.querySelector('#btnConfirmPayment');
    const cancelBtn = modal.querySelector('#btnCancelPayment');

    autofillBtn.addEventListener('click', () => {
      otpInput.value = demoOtp;
      otpInput.focus();
    });

    cancelBtn.addEventListener('click', async () => {
      this.close();
      try {
        fetch('/api/payment/verify', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ order_id, order_code, status: 'cancel' })
        }).catch(() => {});
      } catch (e) {}
      if (typeof onCancel === 'function') onCancel();
    });

    confirmBtn.addEventListener('click', async () => {
      let enteredOtp = otpInput.value.trim();
      if (!enteredOtp) {
        enteredOtp = demoOtp;
        otpInput.value = demoOtp;
      }

      confirmBtn.disabled = true;
      confirmBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang xác thực...';

      try {
        const response = await fetch('/api/payment/verify', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            order_id,
            order_code,
            method,
            otp: enteredOtp
          })
        });
        const resData = await response.json();

        if (resData.success) {
          this.close();
          if (typeof onSuccess === 'function') onSuccess(resData.data);
        } else {
          alert(resData.message || 'Xác thực thanh toán thất bại');
          confirmBtn.disabled = false;
          confirmBtn.innerHTML = '<i class="fa-solid fa-lock"></i> Xác nhận thanh toán';
        }
      } catch (err) {
        alert('Lỗi kết nối tới máy chủ khi xác thực: ' + err.message);
        confirmBtn.disabled = false;
        confirmBtn.innerHTML = '<i class="fa-solid fa-lock"></i> Xác nhận thanh toán';
      }
    });
  },

  startCountdown(seconds) {
    clearInterval(this.activeTimer);
    let remaining = seconds;
    const textEl = document.getElementById('qrCountdownText');

    this.activeTimer = setInterval(() => {
      remaining--;
      if (remaining <= 0) {
        clearInterval(this.activeTimer);
        if (textEl) textEl.textContent = '00:00 (Hết hạn)';
        return;
      }
      const mins = String(Math.floor(remaining / 60)).padStart(2, '0');
      const secs = String(remaining % 60).padStart(2, '0');
      if (textEl) textEl.textContent = `${mins}:${secs}`;
    }, 1000);
  },

  close() {
    clearInterval(this.activeTimer);
    const existing = document.getElementById('simulatedPaymentModal');
    if (existing) existing.remove();
  }
};
