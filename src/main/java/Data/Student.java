package Data;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Gabriel Medina
 */
public class Student {
    private int id;
    private String name;
    private String surnames;
    private int age;
    private String address;
    private int year;
    private String familyData;
    private boolean consentimiento;

    public void setConsentimiento(boolean consentimiento) {
        this.consentimiento = consentimiento;
    }

    public boolean isConsentimiento() {
        return consentimiento;
    }
   

    public Student(int id, String name, String surnames, int age, String address, int year, String familyData, boolean consentimiento) {
        this.id = id;
        this.name = name;
        this.surnames = surnames;
        this.age = age;
        this.address = address;
        this.year = year;
        this.familyData = familyData;
        this.consentimiento= consentimiento;
    }

    public Student(String name, String surnames, int age, String address, int year, String familyData, boolean consentimiento) {
        this.name = name;
        this.surnames = surnames;
        this.age = age;
        this.address = address;
        this.year = year;
        this.familyData = familyData;
        this.consentimiento= consentimiento;
    }   
 
    

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getSurnames() {
        return surnames;
    }

    public int getAge() {
        return age;
    }

    public String getAddress() {
        return address;
    }

    public int getYear() {
        return year;
    }

    public String getFamilyData() {
        return familyData;
    }

 

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setSurnames(String surname) {
        this.surnames = surname;
    }

    public void setAge(int nota) {
        this.age = nota;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public void setFamilyDates(String familyDate) {
        this.familyData = familyData;
    }



    @Override
    public String toString() {
        return "Id: \t\t" + getId()
                + "\nName: \t\t" + getName()
                + "\nSurname: \t" + getSurnames()
                + "\nAge: \t\t" + getAge()
                + "\nAddress: \t" + getAddress()
                + "\nYear: \t" + getYear()
                + "\nFamilyData: \t" + getFamilyData() + "\n"
                + "\nConsentimiento: \t" + isConsentimiento() + "\n";
    }
}

