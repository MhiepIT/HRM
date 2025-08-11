const baseApi = "http://localhost:8080/api/departments";

document.addEventListener("DOMContentLoaded", () => {
    const tbody = document.querySelector("#departmentTable tbody");
    const form = document.getElementById("departmentForm");
    const searchInput = document.getElementById("searchInput");
    const btnAddNew = document.getElementById("btnAddNew");
    const btnCancel = document.getElementById("btnCancel");

    btnAddNew.addEventListener("click", () => {
        form.style.display = "block";
        form.reset();
        document.getElementById("departmentId").value = "";
    });
    btnCancel.addEventListener("click", () => {
        form.style.display = "none";
        form.reset();
        document.getElementById("departmentId").value = "";
    });
    async function loadDepartments(keyword = "") {
        let url = keyword ? `${baseApi}/search?name=${keyword}` : baseApi;
        try {
            const res = await fetch(url);
            if (!res.ok) {
                const errorText = await res.text();
                throw new Error(`HTTP ${res.status}: ${errorText || res.statusText}`);
            }
            
            const contentType = res.headers.get("content-type");
            if (!contentType || !contentType.includes("application/json")) {
                const textResponse = await res.text();
                throw new Error(`Server trả về lỗi: ${textResponse}`);
            }
            
            const departments = await res.json();
            renderTable(departments);
        } catch (error) {
            console.error("Lỗi tải danh sách phòng ban:", error);
            const tbody = document.querySelector("#departmentTable tbody");
            tbody.innerHTML = `<tr><td colspan="4" style="text-align: center; color: red; padding: 20px;">
                <strong>Không thể tải danh sách phòng ban!</strong><br/>
                <small>Chi tiết lỗi: ${error.message}</small><br/><br/>
                <strong>Vui lòng kiểm tra:</strong><br/>
                ✓ Server có đang chạy trên port 8080?<br/>
                ✓ Database MySQL có hoạt động?<br/>
                ✓ Bảng 'departments' có tồn tại?<br/>
                ✓ Xem console (F12) để biết thêm chi tiết
            </td></tr>`;
        }
    }
    function renderTable(depts) {
        tbody.innerHTML = "";
        depts.forEach(dept => {
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${dept.departmentId}</td>
                <td>${dept.departmentName}</td>
                <td>${dept.managerName || ''}</td>
                <td>
                    <button onclick='editDepartment(${dept.departmentId}, "${dept.departmentName}", "${dept.managerId || ''}")'>✏️ Sửa</button>
                    <button onclick='deleteDepartment(${dept.departmentId})'>🗑️ Xoá</button>
                </td>
            `;
            tbody.appendChild(row);
        });
    }
    window.editDepartment = function(id, name, managerId) {
        document.getElementById("departmentId").value = id;
        document.getElementById("departmentName").value = name;
        document.getElementById("managerId").value = managerId;
        document.getElementById("departmentForm").style.display = "block";
    };
    window.deleteDepartment = async function(id) {
        if (confirm("Bạn có chắc muốn xoá?")) {
            try {
                const res = await fetch(`${baseApi}/${id}`, { method: "DELETE" });
                if (res.ok) {
                    alert("Đã xoá!");
                    loadDepartments();
                } else {
                    const msg = await res.text();
                    alert("Lỗi xoá: " + msg);
                }
            } catch (error) {
                alert("Lỗi xoá phòng ban.");
                console.error(error);
            }
        }
    };
    form.addEventListener("submit", async (e) => {
        e.preventDefault();

        const id = document.getElementById("departmentId").value;
        const name = document.getElementById("departmentName").value;
        const managerId = document.getElementById("managerId").value;

        const body = {
            departmentName: name,
            manager: managerId ? { employeeId: parseInt(managerId) } : null
        };

        try {
            const res = await fetch(
                id ? `${baseApi}/${id}` : baseApi,
                {
                    method: id ? "PUT" : "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(body)
                }
            );
            if (res.ok) {
                alert(id ? "Đã cập nhật!" : "Đã thêm mới!");
                form.style.display = "none";
                form.reset();
                document.getElementById("departmentId").value = "";
                loadDepartments();
            } else {
                const msg = await res.text();
                alert("Lỗi: " + msg);
            }
        } catch (error) {
            alert("Lỗi khi gửi biểu mẫu.");
            console.error(error);
        }
    });
    searchInput.addEventListener("input", () => {
        loadDepartments(searchInput.value);
    });
    loadDepartments();
});