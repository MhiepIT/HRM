// API Configuration
const API_CONFIG = {
    BASE_URL: window.location.origin, // Động, sẽ tự adapt theo môi trường
    ENDPOINTS: {
        LOGIN: '/api/auth/login',
        REGISTER: '/api/auth/register',
        OTP_SEND: '/api/otp/send',
        OTP_VERIFY: '/api/otp/verify',
        USERS: '/api/account',
        EMPLOYEES: '/api/employees',
        DEPARTMENTS: '/api/departments',
        ATTENDANCE: '/api/attendance',
        PAYROLL: '/api/payroll',
        INSURANCE: '/api/insurance',
        STATISTICS: '/api/statistics'
    }
};

// Utility function to make API calls
async function apiCall(endpoint, method = 'GET', data = null) {
    const url = API_CONFIG.BASE_URL + endpoint;
    const options = {
        method: method,
        headers: {
            'Content-Type': 'application/json'
        }
    };

    if (data) {
        options.body = JSON.stringify(data);
    }

    try {
        const response = await fetch(url, options);
        const result = await response.json();
        
        if (!response.ok) {
            throw new Error(result.message || 'API call failed');
        }
        
        return result;
    } catch (error) {
        console.error('API call error:', error);
        throw error;
    }
}

// Common utility functions
function showAlert(message, type = 'info') {
    alert(message);
}

function redirectToHome(role) {
    switch (role) {
        case "ADMIN":
            window.location.href = "/admin";
            break;
        case "EMPLOYEE":
            window.location.href = "/employee";
            break;
        case "MANAGER":
            window.location.href = "/manager";
            break;
        case "ACCOUNTANT":
            window.location.href = "/accountant";
            break;
        case "HR":
            window.location.href = "/hr";
            break;
        default:
            showAlert("Không xác định được quyền truy cập!");
    }
}
