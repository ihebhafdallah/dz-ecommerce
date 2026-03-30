package model;

import java.util.Date;

public class User {

    private int userID;
    private String firstName;
    private String lastName;
    private String email;
    private String passwordHash;
    private String phone;
    private Date registrationDate;
    private boolean isActive;
    private Integer defaultAddressID;

    // constructors
    public User() {
    }

    public User(String firstName, String lastName, String email, String passwordHash, String phone) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(Date registrationDate) {
        this.registrationDate = registrationDate;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public Integer getDefaultAddressID() {
        return defaultAddressID;
    }

    public void setDefaultAddressID(Integer defaultAddressID) {
        this.defaultAddressID = defaultAddressID;
    }

    // getters & setters
}
