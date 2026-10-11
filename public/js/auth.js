/**
 * TECHSTORE - AUTHENTICATION CLIENT CONTROLLER (LOGIN & REGISTER)
 */

const AuthPage = {
  init() {
    // Kiểm tra URL hash (nếu có #register thì tự chuyển sang tab Đăng ký)
    if (window.location.hash === '#register') {
      this.switchTab('register');
    }

    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
      loginForm.addEventListener('submit', (e) => this.handleLogin(e));
    }

    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
      registerForm.addEventListener('submit', (e) => this.handleRegister(e));
    }
  },

  switchTab(tab) {
    const loginContainer = document.getElementById('loginFormContainer');
    const registerContainer = document.getElementById('registerFormContainer');
    const loginBtn = document.getElementById('tabLoginBtn');
    const registerBtn = document.getElementById('tabRegisterBtn');
    const alertBox = document.getElementById('authAlert');

    if (alertBox) alertBox.style.display = 'none';

    if (tab === 'register') {
      loginContainer.style.display = 'none';
      registerContainer.style.display = 'block';
      loginBtn.classList.remove('active');
      registerBtn.classList.add('active');
      window.location.hash = 'register';
    } else {
      registerContainer.style.display = 'none';
      loginContainer.style.display = 'block';
      registerBtn.classList.remove('active');
      loginBtn.classList.add('active');
      window.location.hash = 'login';
    }
  },

  togglePasswordVisibility(inputId, btn) {
    const input = document.getElementById(inputId);
    if (!input) return;
    const isPass = input.type === 'password';
    input.type = isPass ? 'text' : 'password';
    btn.innerHTML = isPass ? '<i class="fa-regular fa-eye-slash"></i>' : '<i class="fa-regular fa-eye"></i>';
  },

  fillDemoUser(identifier, password) {
    this.switchTab('login');
    document.getElementById('loginIdentifier').value = identifier;
    document.getElementById('loginPassword').value = password;
    this.showAlert(`Đã điền tài khoản mẫu: ${identifier}`, 'success');
  },

  showAlert(message, type = 'error') {
    const box = document.getElementById('authAlert');
    if (!box) return;
    box.className = `auth-alert ${type}`;
    box.innerHTML = `
      <i class="fa-solid ${type === 'error' ? 'fa-circle-exclamation' : 'fa-circle-check'}"></i>
      <span>${message}</span>
    `;
    box.style.display = 'flex';
  },

  async handleLogin(e) {
    e.preventDefault();
    const identifier = document.getElementById('loginIdentifier').value.trim();
    const password = document.getElementById('loginPassword').value.trim();

    if (!identifier || !password) {
      this.showAlert('Vui lòng nhập đầy đủ thông tin đăng nhập.');
      return;
    }

    const btn = document.getElementById('btnLoginSubmit');
    btn.disabled = true;
    btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang đăng nhập...';

    try {
      const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ identifier, password })
      });
      const data = await res.json();

      if (data.success) {
        this.showAlert(data.message, 'success');
        // Lưu thông tin người dùng vào localStorage
        localStorage.setItem('techstore_user', JSON.stringify(data.data));

        setTimeout(() => {
          // Trở về trang chủ
          window.location.href = '/';
        }, 800);
      } else {
        this.showAlert(data.message || 'Đăng nhập không thành công.');
      }
    } catch (err) {
      this.showAlert('Lỗi kết nối tới máy chủ khi đăng nhập.');
    } finally {
      btn.disabled = false;
      btn.innerHTML = 'ĐĂNG NHẬP NGAY';
    }
  },

  async handleRegister(e) {
    e.preventDefault();
    const name = document.getElementById('regName').value.trim();
    const phone = document.getElementById('regPhone').value.trim();
    const email = document.getElementById('regEmail').value.trim();
    const password = document.getElementById('regPassword').value;
    const confirmPassword = document.getElementById('regConfirmPassword').value;

    if (!name || !phone || !password) {
      this.showAlert('Vui lòng điền họ tên, số điện thoại và mật khẩu.');
      return;
    }

    if (password !== confirmPassword) {
      this.showAlert('Mật khẩu xác nhận không khớp! Vui lòng kiểm tra lại.');
      return;
    }

    if (password.length < 3) {
      this.showAlert('Mật khẩu quá ngắn, vui lòng nhập tối thiểu 3 ký tự.');
      return;
    }

    const btn = document.getElementById('btnRegisterSubmit');
    btn.disabled = true;
    btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang tạo tài khoản...';

    try {
      const res = await fetch('/api/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, phone, email, password })
      });
      const data = await res.json();

      if (data.success) {
        this.showAlert(data.message, 'success');
        localStorage.setItem('techstore_user', JSON.stringify(data.data));

        setTimeout(() => {
          window.location.href = '/';
        }, 1200);
      } else {
        this.showAlert(data.message || 'Đăng ký không thành công.');
      }
    } catch (err) {
      this.showAlert('Lỗi kết nối máy chủ khi đăng ký tài khoản.');
    } finally {
      btn.disabled = false;
      btn.innerHTML = 'ĐĂNG KÝ TÀI KHOẢN';
    }
  }
};

document.addEventListener('DOMContentLoaded', () => {
  AuthPage.init();
});
