package dao;

import model.Wilaya;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WilayaDAO {

    // CREATE
    public void addWilaya(Wilaya wilaya) {
        String sql = "INSERT INTO Wilayas (WilayaID, NameAr, NameFr) VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, wilaya.getWilayaID());
            ps.setString(2, wilaya.getNameAr());
            ps.setString(3, wilaya.getNameFr());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // UPDATE
    public void updateWilaya(Wilaya wilaya) {
        String sql = "UPDATE Wilayas SET NameAr = ?, NameFr = ? WHERE WilayaID = ?";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, wilaya.getNameAr());
            ps.setString(2, wilaya.getNameFr());
            ps.setString(3, wilaya.getWilayaID());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // DELETE
    public void deleteWilaya(String wilayaID) {
        String sql = "DELETE FROM Wilayas WHERE WilayaID = ?";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, wilayaID);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // READ - Get all wilayas
    public List<Wilaya> getAllWilayas() {
        List<Wilaya> wilayas = new ArrayList<>();
        String sql = "SELECT * FROM Wilayas ORDER BY NameFr";

        try (Connection con = DBConnection.getConnection(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Wilaya wilaya = new Wilaya();
                wilaya.setWilayaID(rs.getString("WilayaID"));
                wilaya.setNameAr(rs.getString("NameAr"));
                wilaya.setNameFr(rs.getString("NameFr"));

                wilayas.add(wilaya);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return wilayas;
    }

    // READ - Get wilaya by ID
    public Wilaya getWilayaById(String wilayaID) {
        Wilaya wilaya = null;
        String sql = "SELECT * FROM Wilayas WHERE WilayaID = ?";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, wilayaID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                wilaya = new Wilaya();
                wilaya.setWilayaID(rs.getString("WilayaID"));
                wilaya.setNameAr(rs.getString("NameAr"));
                wilaya.setNameFr(rs.getString("NameFr"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return wilaya;
    }

    // READ - Get wilaya by French name
    public Wilaya getWilayaByNameFr(String nameFr) {
        Wilaya wilaya = null;
        String sql = "SELECT * FROM Wilayas WHERE NameFr = ?";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nameFr);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                wilaya = new Wilaya();
                wilaya.setWilayaID(rs.getString("WilayaID"));
                wilaya.setNameAr(rs.getString("NameAr"));
                wilaya.setNameFr(rs.getString("NameFr"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return wilaya;
    }

    // READ - Get wilaya by Arabic name
    public Wilaya getWilayaByNameAr(String nameAr) {
        Wilaya wilaya = null;
        String sql = "SELECT * FROM Wilayas WHERE NameAr = ?";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nameAr);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                wilaya = new Wilaya();
                wilaya.setWilayaID(rs.getString("WilayaID"));
                wilaya.setNameAr(rs.getString("NameAr"));
                wilaya.setNameFr(rs.getString("NameFr"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return wilaya;
    }

    // READ - Search wilayas by French name (partial match)
    public List<Wilaya> searchWilayasByNameFr(String keyword) {
        List<Wilaya> wilayas = new ArrayList<>();
        String sql = "SELECT * FROM Wilayas WHERE NameFr LIKE ? ORDER BY NameFr";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Wilaya wilaya = new Wilaya();
                wilaya.setWilayaID(rs.getString("WilayaID"));
                wilaya.setNameAr(rs.getString("NameAr"));
                wilaya.setNameFr(rs.getString("NameFr"));

                wilayas.add(wilaya);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return wilayas;
    }

    // CHECK if wilaya exists
    public boolean wilayaExists(String wilayaID) {
        String sql = "SELECT 1 FROM Wilayas WHERE WilayaID = ?";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, wilayaID);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // COUNT total wilayas
    public int getWilayasCount() {
        String sql = "SELECT COUNT(*) FROM Wilayas";

        try (Connection con = DBConnection.getConnection(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
}