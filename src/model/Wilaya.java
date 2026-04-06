package model;

public class Wilaya {
    
    private String wilayaID;
    private String nameAr;
    private String nameFr;
    
    // Constructors
    public Wilaya() {
    }
    
    public Wilaya(String wilayaID, String nameAr, String nameFr) {
        this.wilayaID = wilayaID;
        this.nameAr = nameAr;
        this.nameFr = nameFr;
    }
    
    // Getters and Setters
    public String getWilayaID() {
        return wilayaID;
    }
    
    public void setWilayaID(String wilayaID) {
        this.wilayaID = wilayaID;
    }
    
    public String getNameAr() {
        return nameAr;
    }
    
    public void setNameAr(String nameAr) {
        this.nameAr = nameAr;
    }
    
    public String getNameFr() {
        return nameFr;
    }
    
    public void setNameFr(String nameFr) {
        this.nameFr = nameFr;
    }
    
    @Override
    public String toString() {
        return nameFr; // Useful for JComboBox display
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Wilaya wilaya = (Wilaya) obj;
        return wilayaID != null && wilayaID.equals(wilaya.wilayaID);
    }
    
    @Override
    public int hashCode() {
        return wilayaID != null ? wilayaID.hashCode() : 0;
    }
}