package com.example.Personnel.Management.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebController {

    @GetMapping("/")
    public String index() {
        return "View/login";
    }

    @GetMapping("/login")
    public String login() {
        return "View/login";
    }

    @GetMapping("/admin")
    public String adminHome() {
        return "View/AdminHome";
    }

    @GetMapping("/employee")
    public String employeeHome() {
        return "View/EmployeeHome";
    }

    @GetMapping("/manager")
    public String managerHome() {
        return "View/ManagerHome";
    }

    @GetMapping("/accountant")
    public String accountantHome() {
        return "View/AccountantHome";
    }

    @GetMapping("/hr")
    public String hrHome() {
        return "View/HRHome";
    }

    @GetMapping("/attendance")
    public String attendance() {
        return "View/attendance";
    }

    @GetMapping("/contract")
    public String contract() {
        return "View/Contract";
    }

    @GetMapping("/departments")
    public String departments() {
        return "View/departments";
    }

    @GetMapping("/staff")
    public String staff() {
        return "View/staff";
    }

    @GetMapping("/insurance")
    public String insurance() {
        return "View/insurance";
    }

    @GetMapping("/payroll")
    public String payroll() {
        return "View/Payroll";
    }

    @GetMapping("/payroll-amount")
    public String payrollAmount() {
        return "View/PayrollAmount";
    }

    @GetMapping("/statistic")
    public String statistic() {
        return "View/statistic";
    }

    @GetMapping("/account")
    public String account() {
        return "View/account";
    }

    @GetMapping("/useraccount")
    public String useraccount() {
        return "View/useraccount";
    }

    @GetMapping("/text")
    public String text() {
        return "View/text";
    }
}
