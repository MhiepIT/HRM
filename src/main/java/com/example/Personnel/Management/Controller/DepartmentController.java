package com.example.Personnel.Management.Controller;

import com.example.Personnel.Management.DTO.DepartmentDTO;
import com.example.Personnel.Management.Entity.Department;
import com.example.Personnel.Management.Service.DepartmentService;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/departments")
@RequiredArgsConstructor
public class DepartmentController {

    private final DepartmentService departmentService;

    @GetMapping
    public ResponseEntity<?> getAllDepartments() {
        try {
            List<DepartmentDTO> departments = departmentService.getAllDepartments();
            return ResponseEntity.ok(departments);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Lỗi khi tải danh sách phòng ban: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getDepartmentById(@PathVariable Long id) {
        try {
            return departmentService.getDepartmentById(id)
                    .map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Lỗi khi tìm phòng ban: " + e.getMessage());
        }
    }

    @PostMapping
    public ResponseEntity<?> createDepartment(@RequestBody Department department) {
        try {
            Department created = departmentService.createDepartment(department);
            return ResponseEntity.ok(created);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Lỗi khi tạo phòng ban: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateDepartment(@PathVariable Long id, @RequestBody Department department) {
        try {
            Department updated = departmentService.updateDepartment(id, department);
            return ResponseEntity.ok(updated);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Lỗi khi cập nhật phòng ban: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteDepartment(@PathVariable Long id) {
        try {
            departmentService.deleteDepartment(id);
            return ResponseEntity.noContent().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Lỗi khi xóa phòng ban: " + e.getMessage());
        }
    }

    @GetMapping("/search")
    public ResponseEntity<?> searchDepartments(@RequestParam String name) {
        try {
            List<DepartmentDTO> departments = departmentService.searchDepartmentsByName(name);
            return ResponseEntity.ok(departments);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Lỗi khi tìm kiếm phòng ban: " + e.getMessage());
        }
    }
}
