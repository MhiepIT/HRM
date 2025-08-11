-- Script tạo database và dữ liệu mẫu cho hệ thống HRM
-- Thực hiện theo thứ tự: Create Database -> Create Tables -> Insert Data
-- ====== TẠO DATABASE ======
DROP DATABASE IF EXISTS employeestorage;
CREATE DATABASE employeestorage CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE employeestorage;
-- ====== TẠO CÁC BẢNG ======
-- Bảng Users
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM(
        'ADMIN',
        'EMPLOYEE',
        'MANAGER',
        'ACCOUNTANT',
        'HR'
    ) NOT NULL,
    verification_code VARCHAR(255),
    verified BOOLEAN DEFAULT FALSE,
    account_status ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- Bảng Departments
CREATE TABLE departments (
    department_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL UNIQUE,
    manager_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- Bảng Employees
CREATE TABLE employees (
    employee_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(255),
    address TEXT,
    hire_date DATE,
    department_id BIGINT,
    user_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE
    SET NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
-- Thêm foreign key cho manager_id trong departments sau khi tạo employees
ALTER TABLE departments
ADD FOREIGN KEY (manager_id) REFERENCES employees(employee_id) ON DELETE
SET NULL;
-- Bảng Contracts
CREATE TABLE contracts (
    contract_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    contract_type VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    salary DECIMAL(15, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);
-- Bảng Insurances
CREATE TABLE insurances (
    insurance_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    insurance_type VARCHAR(255) NOT NULL,
    insurance_amount DECIMAL(15, 2) NOT NULL,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);
-- Bảng Attendances
CREATE TABLE attendances (
    attendance_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    date DATE NOT NULL,
    check_in TIMESTAMP NOT NULL,
    check_out TIMESTAMP,
    work_hours DECIMAL(4, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,
    UNIQUE KEY unique_employee_date (employee_id, date)
);
-- Bảng Payrolls
CREATE TABLE payrolls (
    payroll_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
    basic_salary DECIMAL(15, 2) NOT NULL,
    overtime_pay DECIMAL(15, 2) NOT NULL DEFAULT 0,
    final_salary DECIMAL(15, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,
    UNIQUE KEY unique_employee_month_year (employee_id, month, year)
);
-- ====== TẠO INDEX ======
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_employees_user ON employees(user_id);
CREATE INDEX idx_contracts_employee ON contracts(employee_id);
CREATE INDEX idx_insurances_employee ON insurances(employee_id);
CREATE INDEX idx_attendances_employee ON attendances(employee_id);
CREATE INDEX idx_attendances_date ON attendances(date);
CREATE INDEX idx_payrolls_employee ON payrolls(employee_id);
CREATE INDEX idx_payrolls_month_year ON payrolls(month, year);
-- ====== THÊM DỮ LIỆU MẪU ======
-- ====== USERS TABLE ======
INSERT INTO users (
        email,
        username,
        password,
        role,
        verified,
        account_status
    )
VALUES (
        'admin@hrm.com',
        'admin',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'ADMIN',
        true,
        'ACTIVE'
    ),
    (
        'hr@hrm.com',
        'hr_manager',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'HR',
        true,
        'ACTIVE'
    ),
    (
        'manager1@hrm.com',
        'manager1',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'MANAGER',
        true,
        'ACTIVE'
    ),
    (
        'manager2@hrm.com',
        'manager2',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'MANAGER',
        true,
        'ACTIVE'
    ),
    (
        'accountant@hrm.com',
        'accountant',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'ACCOUNTANT',
        true,
        'ACTIVE'
    ),
    (
        'emp1@hrm.com',
        'employee1',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'EMPLOYEE',
        true,
        'ACTIVE'
    ),
    (
        'emp2@hrm.com',
        'employee2',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'EMPLOYEE',
        true,
        'ACTIVE'
    ),
    (
        'emp3@hrm.com',
        'employee3',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'EMPLOYEE',
        true,
        'ACTIVE'
    ),
    (
        'emp4@hrm.com',
        'employee4',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'EMPLOYEE',
        true,
        'ACTIVE'
    ),
    (
        'emp5@hrm.com',
        'employee5',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'EMPLOYEE',
        true,
        'ACTIVE'
    ),
    (
        'emp6@hrm.com',
        'employee6',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'EMPLOYEE',
        true,
        'ACTIVE'
    ),
    (
        'emp7@hrm.com',
        'employee7',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'EMPLOYEE',
        true,
        'ACTIVE'
    ),
    (
        'emp8@hrm.com',
        'employee8',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'EMPLOYEE',
        true,
        'ACTIVE'
    );
-- ====== DEPARTMENTS TABLE (Tạo phòng ban trước, không có manager) ======
INSERT INTO departments (department_name, manager_id)
VALUES ('Phòng Công nghệ thông tin', NULL),
    ('Phòng Nhân sự', NULL),
    ('Phòng Kế toán', NULL),
    ('Phòng Marketing', NULL),
    ('Phòng Kinh doanh', NULL),
    ('Phòng Hành chính', NULL);
-- ====== EMPLOYEES TABLE ======
INSERT INTO employees (
        full_name,
        dob,
        gender,
        phone,
        email,
        address,
        hire_date,
        department_id,
        user_id
    )
VALUES (
        'Nguyễn Văn Admin',
        '1985-01-15',
        'Nam',
        '0901234567',
        'admin@hrm.com',
        'Hà Nội',
        '2020-01-01',
        1,
        1
    ),
    (
        'Trần Thị HR',
        '1987-03-20',
        'Nữ',
        '0902345678',
        'hr@hrm.com',
        'Hà Nội',
        '2020-02-01',
        2,
        2
    ),
    (
        'Lê Văn Quản lý IT',
        '1983-05-10',
        'Nam',
        '0903456789',
        'manager1@hrm.com',
        'Hồ Chí Minh',
        '2020-03-01',
        1,
        3
    ),
    (
        'Phạm Thị Quản lý Marketing',
        '1986-08-25',
        'Nữ',
        '0904567890',
        'manager2@hrm.com',
        'Đà Nẵng',
        '2020-04-01',
        4,
        4
    ),
    (
        'Hoàng Văn Kế toán',
        '1988-12-05',
        'Nam',
        '0905678901',
        'accountant@hrm.com',
        'Hà Nội',
        '2020-05-01',
        3,
        5
    ),
    (
        'Võ Thị Nhân viên IT',
        '1990-02-14',
        'Nữ',
        '0906789012',
        'emp1@hrm.com',
        'Hà Nội',
        '2021-01-15',
        1,
        6
    ),
    (
        'Đỗ Văn Nhân viên HR',
        '1992-06-30',
        'Nam',
        '0907890123',
        'emp2@hrm.com',
        'Hồ Chí Minh',
        '2021-02-15',
        2,
        7
    ),
    (
        'Bùi Thị Nhân viên Kế toán',
        '1991-09-18',
        'Nữ',
        '0908901234',
        'emp3@hrm.com',
        'Đà Nẵng',
        '2021-03-15',
        3,
        8
    ),
    (
        'Lý Văn Nhân viên Marketing',
        '1993-11-22',
        'Nam',
        '0909012345',
        'emp4@hrm.com',
        'Hà Nội',
        '2021-04-15',
        4,
        9
    ),
    (
        'Trương Thị Nhân viên Kinh doanh',
        '1989-04-07',
        'Nữ',
        '0910123456',
        'emp5@hrm.com',
        'Hồ Chí Minh',
        '2021-05-15',
        5,
        10
    ),
    (
        'Ngô Văn Nhân viên Hành chính',
        '1994-07-12',
        'Nam',
        '0911234567',
        'emp6@hrm.com',
        'Đà Nẵng',
        '2021-06-15',
        6,
        11
    ),
    (
        'Đinh Thị Thực tập sinh IT',
        '1995-10-03',
        'Nữ',
        '0912345678',
        'emp7@hrm.com',
        'Hà Nội',
        '2022-01-10',
        1,
        12
    ),
    (
        'Vũ Văn Thực tập sinh Marketing',
        '1996-01-28',
        'Nam',
        '0913456789',
        'emp8@hrm.com',
        'Hồ Chí Minh',
        '2022-02-10',
        4,
        13
    );
-- ====== CẬP NHẬT MANAGER CHO DEPARTMENTS ======
UPDATE departments
SET manager_id = 3
WHERE department_id = 1;
-- IT
UPDATE departments
SET manager_id = 2
WHERE department_id = 2;
-- HR  
UPDATE departments
SET manager_id = 5
WHERE department_id = 3;
-- Kế toán
UPDATE departments
SET manager_id = 4
WHERE department_id = 4;
-- Marketing
UPDATE departments
SET manager_id = 1
WHERE department_id = 5;
-- Kinh doanh
UPDATE departments
SET manager_id = 1
WHERE department_id = 6;
-- Hành chính
-- ====== CONTRACTS TABLE ======
INSERT INTO contracts (
        employee_id,
        contract_type,
        start_date,
        end_date,
        salary
    )
VALUES (
        1,
        'Hợp đồng không thời hạn',
        '2020-01-01',
        NULL,
        25000000.00
    ),
    (
        2,
        'Hợp đồng không thời hạn',
        '2020-02-01',
        NULL,
        20000000.00
    ),
    (
        3,
        'Hợp đồng không thời hạn',
        '2020-03-01',
        NULL,
        22000000.00
    ),
    (
        4,
        'Hợp đồng không thời hạn',
        '2020-04-01',
        NULL,
        21000000.00
    ),
    (
        5,
        'Hợp đồng không thời hạn',
        '2020-05-01',
        NULL,
        18000000.00
    ),
    (
        6,
        'Hợp đồng có thời hạn',
        '2021-01-15',
        '2024-01-14',
        15000000.00
    ),
    (
        7,
        'Hợp đồng có thời hạn',
        '2021-02-15',
        '2024-02-14',
        14000000.00
    ),
    (
        8,
        'Hợp đồng có thời hạn',
        '2021-03-15',
        '2024-03-14',
        16000000.00
    ),
    (
        9,
        'Hợp đồng có thời hạn',
        '2021-04-15',
        '2024-04-14',
        15500000.00
    ),
    (
        10,
        'Hợp đồng có thời hạn',
        '2021-05-15',
        '2024-05-14',
        17000000.00
    ),
    (
        11,
        'Hợp đồng có thời hạn',
        '2021-06-15',
        '2024-06-14',
        13500000.00
    ),
    (
        12,
        'Hợp đồng thực tập',
        '2022-01-10',
        '2022-07-10',
        5000000.00
    ),
    (
        13,
        'Hợp đồng thực tập',
        '2022-02-10',
        '2022-08-10',
        5500000.00
    );
-- ====== INSURANCES TABLE ======
INSERT INTO insurances (
        employee_id,
        insurance_type,
        insurance_amount,
        start_date,
        end_date
    )
VALUES (
        1,
        'Bảo hiểm xã hội',
        2500000.00,
        '2020-01-01',
        NULL
    ),
    (
        1,
        'Bảo hiểm y tế',
        1500000.00,
        '2020-01-01',
        NULL
    ),
    (
        2,
        'Bảo hiểm xã hội',
        2000000.00,
        '2020-02-01',
        NULL
    ),
    (
        2,
        'Bảo hiểm y tế',
        1200000.00,
        '2020-02-01',
        NULL
    ),
    (
        3,
        'Bảo hiểm xã hội',
        2200000.00,
        '2020-03-01',
        NULL
    ),
    (
        3,
        'Bảo hiểm y tế',
        1300000.00,
        '2020-03-01',
        NULL
    ),
    (
        4,
        'Bảo hiểm xã hội',
        2100000.00,
        '2020-04-01',
        NULL
    ),
    (
        4,
        'Bảo hiểm y tế',
        1250000.00,
        '2020-04-01',
        NULL
    ),
    (
        5,
        'Bảo hiểm xã hội',
        1800000.00,
        '2020-05-01',
        NULL
    ),
    (
        5,
        'Bảo hiểm y tế',
        1100000.00,
        '2020-05-01',
        NULL
    ),
    (
        6,
        'Bảo hiểm xã hội',
        1500000.00,
        '2021-01-15',
        '2024-01-14'
    ),
    (
        6,
        'Bảo hiểm y tế',
        900000.00,
        '2021-01-15',
        '2024-01-14'
    ),
    (
        7,
        'Bảo hiểm xã hội',
        1400000.00,
        '2021-02-15',
        '2024-02-14'
    ),
    (
        7,
        'Bảo hiểm y tế',
        850000.00,
        '2021-02-15',
        '2024-02-14'
    ),
    (
        8,
        'Bảo hiểm xã hội',
        1600000.00,
        '2021-03-15',
        '2024-03-14'
    ),
    (
        8,
        'Bảo hiểm y tế',
        950000.00,
        '2021-03-15',
        '2024-03-14'
    ),
    (
        9,
        'Bảo hiểm xã hội',
        1550000.00,
        '2021-04-15',
        '2024-04-14'
    ),
    (
        9,
        'Bảo hiểm y tế',
        925000.00,
        '2021-04-15',
        '2024-04-14'
    ),
    (
        10,
        'Bảo hiểm xã hội',
        1700000.00,
        '2021-05-15',
        '2024-05-14'
    ),
    (
        10,
        'Bảo hiểm y tế',
        1000000.00,
        '2021-05-15',
        '2024-05-14'
    );
-- ====== ATTENDANCES TABLE (Dữ liệu chấm công mẫu) ======
INSERT INTO attendances (
        employee_id,
        date,
        check_in,
        check_out,
        work_hours
    )
VALUES -- Tháng 1/2024
    (
        1,
        '2024-01-02',
        '2024-01-02 08:00:00',
        '2024-01-02 17:30:00',
        8.5
    ),
    (
        1,
        '2024-01-03',
        '2024-01-03 08:15:00',
        '2024-01-03 17:45:00',
        8.5
    ),
    (
        2,
        '2024-01-02',
        '2024-01-02 08:30:00',
        '2024-01-02 17:30:00',
        8.0
    ),
    (
        2,
        '2024-01-03',
        '2024-01-03 08:00:00',
        '2024-01-03 17:00:00',
        8.0
    ),
    (
        3,
        '2024-01-02',
        '2024-01-02 08:00:00',
        '2024-01-02 18:00:00',
        9.0
    ),
    (
        3,
        '2024-01-03',
        '2024-01-03 08:00:00',
        '2024-01-03 17:30:00',
        8.5
    ),
    -- Thêm dữ liệu cho các nhân viên khác
    (
        6,
        '2024-01-02',
        '2024-01-02 08:30:00',
        '2024-01-02 17:30:00',
        8.0
    ),
    (
        7,
        '2024-01-02',
        '2024-01-02 08:45:00',
        '2024-01-02 17:45:00',
        8.0
    ),
    (
        8,
        '2024-01-02',
        '2024-01-02 08:15:00',
        '2024-01-02 17:15:00',
        8.0
    );
-- ====== PAYROLLS TABLE (Bảng lương mẫu) ======
INSERT INTO payrolls (
        employee_id,
        month,
        year,
        basic_salary,
        overtime_pay,
        final_salary
    )
VALUES -- Lương tháng 12/2023
    (
        1,
        12,
        2023,
        25000000.00,
        2500000.00,
        27500000.00
    ),
    (
        2,
        12,
        2023,
        20000000.00,
        1500000.00,
        21500000.00
    ),
    (
        3,
        12,
        2023,
        22000000.00,
        3000000.00,
        25000000.00
    ),
    (
        4,
        12,
        2023,
        21000000.00,
        2100000.00,
        23100000.00
    ),
    (
        5,
        12,
        2023,
        18000000.00,
        1800000.00,
        19800000.00
    ),
    (
        6,
        12,
        2023,
        15000000.00,
        1200000.00,
        16200000.00
    ),
    (
        7,
        12,
        2023,
        14000000.00,
        1000000.00,
        15000000.00
    ),
    (
        8,
        12,
        2023,
        16000000.00,
        1300000.00,
        17300000.00
    ),
    -- Lương tháng 1/2024
    (1, 1, 2024, 25000000.00, 2800000.00, 27800000.00),
    (2, 1, 2024, 20000000.00, 1600000.00, 21600000.00),
    (3, 1, 2024, 22000000.00, 3200000.00, 25200000.00),
    (4, 1, 2024, 21000000.00, 2000000.00, 23000000.00),
    (5, 1, 2024, 18000000.00, 1900000.00, 19900000.00);
-- ====== Kiểm tra dữ liệu đã thêm ======
SELECT 'Users' as table_name,
    COUNT(*) as records
FROM users
UNION ALL
SELECT 'Departments',
    COUNT(*)
FROM departments
UNION ALL
SELECT 'Employees',
    COUNT(*)
FROM employees
UNION ALL
SELECT 'Contracts',
    COUNT(*)
FROM contracts
UNION ALL
SELECT 'Insurances',
    COUNT(*)
FROM insurances
UNION ALL
SELECT 'Attendances',
    COUNT(*)
FROM attendances
UNION ALL
SELECT 'Payrolls',
    COUNT(*)
FROM payrolls;
-- Note: Password được mã hóa với BCrypt, mật khẩu gốc là "password"
-- Bạn có thể đăng nhập với:
-- admin@hrm.com / password (ADMIN)
-- hr@hrm.com / password (HR)  
-- manager1@hrm.com / password (MANAGER)
-- emp1@hrm.com / password (EMPLOYEE)