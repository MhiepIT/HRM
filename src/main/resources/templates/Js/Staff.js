const API = "http://localhost:8080/employees/api";

document.addEventListener("DOMContentLoaded", () => {
    loadEmployees();
    document.getElementById("employeeForm").addEventListener("submit", handleFormSubmit);
    document.getElementById("btnAddNew").addEventListener("click", () => {
        document.getElementById("employeeForm").style.display = "block";
        document.getElementById("employeeForm").reset();
        document.getElementById("employeeId").value = "";
    });
    document.getElementById("btnCancel").addEventListener("click", () => {
        document.getElementById("employeeForm").style.display = "none";
        document.getElementById("employeeForm").reset();
    });
});

function loadEmployees() {
    fetch(`${API}/list`)
        .then(res => {
            if (!res.ok) {
                throw new Error(`HTTP Error: ${res.status} - ${res.statusText}`);
            }
            return res.json();
        })
        .then(data => {
            if (!data || !data.data) {
                throw new Error("Dữ liệu không hợp lệ từ server");
            }
            const employees = data.data;
            const tbody = document.getElementById("tableBody");
            tbody.innerHTML = "";
            employees.forEach(emp => {
                const tr = document.createElement("tr");
                tr.innerHTML = `
                    <td>${emp.employeeId}</td>
                    <td>${emp.fullName}</td>
                    <td>${emp.address ?? ""}</td>
                    <td>${emp.dob?.substring(0, 10) ?? ""}</td>
                    <td>${emp.email}</td>
                    <td>${emp.gender}</td>
                    <td>${emp.hireDate?.substring(0, 10) ?? ""}</td>
                    <td>${emp.phone}</td>
                    <td>${emp.department?.id ?? emp.departmentId ?? ""}</td>
                    <td>${emp.user?.id ?? emp.userId ?? ""}</td>
                    <td>
                        <button class="btn-edit" onclick="editEmployee(${emp.employeeId})">✏️</button>
                        <button onclick="deleteEmployee(${emp.employeeId})">🗑️</button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(err => {
            console.error("Không load được danh sách:", err);
            const tbody = document.getElementById("tableBody");
            tbody.innerHTML = `<tr><td colspan="11" style="text-align: center; color: red;">
                Không thể kết nối đến server. Vui lòng kiểm tra:<br/>
                1. Server có đang chạy trên port 8080?<br/>
                2. Database đã kết nối?<br/>
                Lỗi: ${err.message}
            </td></tr>`;
        });
}

function handleFormSubmit(e) {
    e.preventDefault();
    const id = document.getElementById("employeeId").value;
    const payload = {
        fullName: document.getElementById("fullName").value,
        address: document.getElementById("address").value,
        dob: document.getElementById("dob").value,
        email: document.getElementById("email").value,
        gender: document.getElementById("gender").value,
        hireDate: document.getElementById("hireDate").value,
        phone: document.getElementById("phone").value,
        departmentId: +document.getElementById("departmentId").value,
        userId: +document.getElementById("userId").value
    };
    const url = id ? `${API}/update/${id}` : `${API}/add`;
    const method = id ? "PUT" : "POST";

    fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload)
    })
        .then(res => {
            if (!res.ok) {
                return res.json().then(err => {
                    throw new Error(err.message || "Có lỗi xảy ra");
                });
            }
            return res.json();
        })
        .then(() => {
            document.getElementById("employeeForm").style.display = "none";
            resetForm();
            loadEmployees();
            alert(id ? "Cập nhật thành công!" : "Thêm mới thành công!");
        })
        .catch(err => {
            alert("Lỗi: " + err.message);
        });
}

function editEmployee(id) {
    fetch(`${API}/detail/${id}`)
        .then(res => res.json())
        .then(data => {
            const emp = data.employee;
            document.getElementById("employeeId").value = emp.employeeId;
            document.getElementById("fullName").value = emp.fullName;
            document.getElementById("address").value = emp.address || "";
            document.getElementById("dob").value = emp.dob?.substring(0, 10) || "";
            document.getElementById("email").value = emp.email || "";
            document.getElementById("gender").value = emp.gender || "";
            document.getElementById("hireDate").value = emp.hireDate?.substring(0, 10) || "";
            document.getElementById("phone").value = emp.phone || "";
            document.getElementById("departmentId").value = emp.departmentId || "";
            document.getElementById("userId").value = emp.userId || "";
            document.getElementById("employeeForm").style.display = "block";
        })
        .catch(err => {
            console.error("Lỗi khi lấy chi tiết nhân viên:", err);
            alert("Không thể lấy thông tin nhân viên.");
        });
}
function deleteEmployee(id) {
    if (!confirm("Bạn có chắc chắn muốn xoá nhân viên này?")) return;

    fetch(`${API}/delete/${id}`, {
        method: "DELETE"
    })
        .then(res => {
            if (!res.ok) {
                return res.json().then(err => {
                    throw new Error(err.message || "Không thể xoá");
                });
            }
            return res.json();
        })
        .then(() => {
            loadEmployees();
            alert("Đã xoá nhân viên!");
        })
        .catch(err => {
            alert("Lỗi khi xoá: " + err.message);
        });
}
function resetForm() {
    document.getElementById("employeeForm").reset();
    document.getElementById("employeeId").value = "";
}
function searchEmployees() {
    const searchValue = document.getElementById("searchInput").value.trim();
    if (!searchValue) {
        loadEmployees();
        return;
    }
    fetch(`${API}/search?name=${encodeURIComponent(searchValue)}`)
        .then(res => res.json())
        .then(data => {
            const employees = data.data || [];
            const tbody = document.getElementById("tableBody");
            tbody.innerHTML = "";

            employees.forEach(emp => {
                const tr = document.createElement("tr");
                tr.innerHTML = `
                    <td>${emp.employeeId}</td>
                    <td>${emp.fullName}</td>
                    <td>${emp.address ?? ""}</td>
                    <td>${emp.dob?.substring(0, 10) ?? ""}</td>
                    <td>${emp.email}</td>
                    <td>${emp.gender}</td>
                    <td>${emp.hireDate?.substring(0, 10) ?? ""}</td>
                    <td>${emp.phone}</td>
                    <td>${emp.department?.id ?? emp.departmentId ?? ""}</td>
                    <td>${emp.user?.id ?? emp.userId ?? ""}</td>
                    <td>
                        <button class="btn-edit" onclick="editEmployee(${emp.employeeId})">✏️</button>
                        <button onclick="deleteEmployee(${emp.employeeId})">🗑️</button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(err => {
            console.error("Không tìm thấy nhân viên:", err);
            alert("Không tìm thấy nhân viên nào.");
        });
}

function exportToExcel() {
    let csv = "ID,Họ tên,Địa chỉ,Ngày sinh,Email,Giới tính,Ngày làm,Điện thoại,Phòng ban,Tài khoản\n";
    const rows = document.querySelectorAll("table tbody tr");

    rows.forEach(row => {
        const cols = row.querySelectorAll("td");
        const data = [...cols].slice(0, 10).map(td => `"${td.innerText}"`).join(",");
        csv += data + "\n";
    });
    const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
    const link = document.createElement("a");
    link.href = URL.createObjectURL(blob);
    link.download = "danh_sach_nhan_vien.csv";
    link.click();
   }
     function goBack() {
    const ref = document.referrer;

    if (ref.includes("admin")) {
        window.location.href = "/admin";
    } else if (ref.includes("manager")) {
        window.location.href = "/manager";
    } else if (ref.includes("hr")) {
        window.location.href = "/hr";
    } else {
        window.location.href = "/login";
    }
}