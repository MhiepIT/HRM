package com.example.Personnel.Management.Entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;
import java.util.Date;

@Entity
@Table(name = "employees")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "employee_id")
    private Long employeeId;
    
    @Column(name = "full_name")
    private String fullName;
    
    @Column(name = "dob")
    private Date dob;
    
    @Column(name = "gender")
    private String gender;
    
    @Column(name = "phone")
    private String phone;
    
    @Column(name = "email")
    private String email;
    
    @Column(name = "address")
    private String address;
    
    @Column(name = "hire_date")
    private Date hireDate;

    @ManyToOne
    @JoinColumn(name = "department_id")
    @JsonIgnoreProperties({"manager"})
    private Department department;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}
