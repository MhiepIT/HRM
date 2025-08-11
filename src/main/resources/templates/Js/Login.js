document.addEventListener("DOMContentLoaded", () => {
    const loginButton = document.getElementById('loginButton');

    if (loginButton) {
        loginButton.addEventListener('click', async () => {
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value.trim();

            if (!email || !password) {
                showAlert("Vui lòng nhập đầy đủ email và mật khẩu!");
                return;
            }

            try {
                const result = await apiCall(API_CONFIG.ENDPOINTS.LOGIN, 'POST', { email, password });
                
                if (result.accountStatus !== "ACTIVE") {
                    showAlert("Tài khoản của bạn chưa được kích hoạt!");
                    return;
                }
                
                localStorage.setItem("loggedInUser", JSON.stringify(result));
                showAlert(result.message);
                redirectToHome(result.role);

            } catch (error) {
                showAlert("Đăng nhập thất bại! " + error.message);
                console.error("Lỗi login:", error);
            }
        });
    }
});
