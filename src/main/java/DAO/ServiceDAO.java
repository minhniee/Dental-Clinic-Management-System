package DAO;

import context.DBContext;
import model.Service;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ServiceDAO {

    private static final Logger logger = Logger.getLogger(ServiceDAO.class.getName());

    /**
     * Get all active services
     */
    public List<Service> getAllActiveServices() {
        String sql = "SELECT * FROM Services WHERE is_active = 1 ORDER BY name ASC";
        
        List<Service> services = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            
            while (rs.next()) {
                Service service = mapResultSetToService(rs);
                services.add(service);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all active services", e);
        }
        
        return services;
    }

    /**
     * Get service by ID
     */
    public Service getServiceById(int serviceId) {
        String sql = "SELECT * FROM Services WHERE service_id = ? AND is_active = 1";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, serviceId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToService(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting service by ID: " + serviceId, e);
        }
        
        return null;
    }

    /**
     * Get services by price range
     */
    public List<Service> getServicesByPriceRange(double minPrice, double maxPrice) {
        String sql = "SELECT * FROM Services WHERE is_active = 1 AND price >= ? AND price <= ? ORDER BY price ASC";
        
        List<Service> services = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setDouble(1, minPrice);
            statement.setDouble(2, maxPrice);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Service service = mapResultSetToService(rs);
                services.add(service);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting services by price range: " + minPrice + " - " + maxPrice, e);
        }
        
        return services;
    }

    /**
     * Map ResultSet to Service object
     */
    private Service mapResultSetToService(ResultSet rs) throws SQLException {
        Service service = new Service();
        service.setServiceId(rs.getInt("service_id"));
        service.setName(rs.getString("name"));
        service.setDescription(rs.getString("description"));
        service.setPrice(rs.getBigDecimal("price"));
        service.setDurationMinutes(rs.getInt("duration_minutes"));
        service.setActive(rs.getBoolean("is_active"));
        
        return service;
    }
}
