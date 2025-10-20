package model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class SystemConfig {
    private int configId;
    private String configKey;
    private String configValue;
    private LocalDateTime updatedAt;
    private Integer updatedBy;
    
    // Related objects
    private User updatedByUser;

    public SystemConfig() {
    }

    public SystemConfig(int configId, String configKey, String configValue, 
                       LocalDateTime updatedAt, Integer updatedBy) {
        this.configId = configId;
        this.configKey = configKey;
        this.configValue = configValue;
        this.updatedAt = updatedAt;
        this.updatedBy = updatedBy;
    }

    public int getConfigId() {
        return configId;
    }

    public void setConfigId(int configId) {
        this.configId = configId;
    }

    public String getConfigKey() {
        return configKey;
    }

    public void setConfigKey(String configKey) {
        this.configKey = configKey;
    }

    public String getConfigValue() {
        return configValue;
    }

    public void setConfigValue(String configValue) {
        this.configValue = configValue;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Integer getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(Integer updatedBy) {
        this.updatedBy = updatedBy;
    }

    public User getUpdatedByUser() {
        return updatedByUser;
    }

    public void setUpdatedByUser(User updatedByUser) {
        this.updatedByUser = updatedByUser;
    }

    /**
     * Helper method to get updatedAt as java.util.Date for JSP formatting
     */
    public Date getUpdatedAtAsDate() {
        if (updatedAt != null) {
            return Date.from(updatedAt.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }

    @Override
    public String toString() {
        return "SystemConfig{" +
                "configId=" + configId +
                ", configKey='" + configKey + '\'' +
                ", configValue='" + configValue + '\'' +
                ", updatedAt=" + updatedAt +
                ", updatedBy=" + updatedBy +
                '}';
    }
}
