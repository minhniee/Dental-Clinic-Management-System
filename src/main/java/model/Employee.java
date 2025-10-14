package model;

import java.time.LocalDate;

public class Employee {
    private int employeeId;
    private int userId;
    private String position;
    private LocalDate hireDate;
    private User user;

    public Employee() {
    }

    public Employee(int employeeId, int userId, String position, LocalDate hireDate) {
        this.employeeId = employeeId;
        this.userId = userId;
        this.position = position;
        this.hireDate = hireDate;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public LocalDate getHireDate() {
        return hireDate;
    }

    public void setHireDate(LocalDate hireDate) {
        this.hireDate = hireDate;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "employeeId=" + employeeId +
                ", userId=" + userId +
                ", position='" + position + '\'' +
                ", hireDate=" + hireDate +
                '}';
    }
}
