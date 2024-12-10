/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Data;

/**
 *
 * @author gabriel
 */
public class Admin {
    private int id;
    private String name;
    private String role;

    public Admin(int id, String name, String role) {
        this.id = id;
        this.name = name;
        this.role = role;
    }

    // Getters
    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getRole() {
        return role;
    }

    @Override
    public String toString() {
        return "Admin{id=" + id + ", name='" + name + "', role='" + role + "'}";
    }
}

