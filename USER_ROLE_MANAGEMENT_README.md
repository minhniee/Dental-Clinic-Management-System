# User & Role Management System

## Overview
This document describes the implementation of the User & Role Management functionality for the Dental Clinic Management System, based on the SRS requirements.

## Features Implemented

### 1. User Management
- **View All Users**: Display list of all users with their roles and status
- **Create New User**: Add new users with username, email, password, full name, phone, and role assignment
- **Update User Role**: Change user roles (Administrator, ClinicManager, Dentist, Receptionist, Patient)
- **Update User Status**: Activate/deactivate user accounts
- **User Validation**: Check for duplicate usernames and emails

### 2. Role Management
- **View All Roles**: Display all available roles in the system
- **Create New Role**: Add custom roles (beyond the default 5 roles)
- **Update Role**: Modify existing role names
- **Delete Role**: Remove custom roles (default roles cannot be deleted)
- **Role Protection**: Prevent deletion of roles that are in use

### 3. Activity Logging
- **Audit Trail**: Track all user management activities
- **Activity Types**: CREATE, UPDATE, DELETE, LOGIN operations
- **Target Tracking**: Track which entities were affected (USER, ROLE, etc.)
- **IP Address Logging**: Record user IP addresses for security
- **User Agent Tracking**: Log browser/client information

## Technical Implementation

### Database Schema
The system uses the existing `DentalClinicDB_MVP` database with the following tables:

#### Users Table
- `user_id` (Primary Key)
- `username` (Unique)
- `email` (Unique)
- `password_hash`
- `full_name`
- `phone`
- `role_id` (Foreign Key to Roles)
- `is_active`
- `created_at`

#### Roles Table
- `role_id` (Primary Key)
- `role_name` (Unique)

#### ActivityLogs Table (New)
- `log_id` (Primary Key)
- `user_id` (Foreign Key to Users, nullable for system actions)
- `action` (CREATE, UPDATE, DELETE, LOGIN, etc.)
- `description` (Human readable description)
- `target_type` (USER, ROLE, APPOINTMENT, etc.)
- `target_id` (ID of affected record)
- `ip_address`
- `user_agent`
- `created_at`

### Java Classes

#### DAO Classes
- **UserDAO**: Handles all user-related database operations
- **RoleDAO**: Manages role-related database operations
- **ActivityLogDAO**: Manages activity logging

#### Servlet Classes
- **UserManagementServlet**: Handles user management requests (`/admin/users`)
- **RoleManagementServlet**: Handles role management requests (`/admin/roles`)
- **ActivityLogServlet**: Handles activity log viewing (`/admin/activity-logs`)

#### Model Classes
- **User**: User entity model
- **Role**: Role entity model
- **ActivityLog**: Activity log entity model

### JSP Pages
- **user-management.jsp**: User management interface
- **role-management.jsp**: Role management interface
- **activity-logs.jsp**: Activity log viewing interface

## Security Features

### Access Control
- Only users with "Administrator" role can access user management features
- Session validation ensures users are logged in
- Role-based access control for all management operations

### Input Validation
- Server-side validation for all form inputs
- SQL injection prevention using PreparedStatements
- XSS protection through proper JSP escaping

### Audit Trail
- All user management activities are logged
- IP address and user agent tracking
- Timestamp recording for all activities
- Detailed descriptions of all actions performed

## Error Handling

### User-Friendly Error Messages
- **MSG20**: "User not found" - When trying to update non-existent users
- **MSG21**: "Invalid role selection" - When selecting invalid roles
- **MSG22**: "Failed to update role, please try again later" - System errors

### Exception Handling
- Comprehensive try-catch blocks in all servlets
- Database connection error handling
- Graceful degradation for system errors

## Usage Instructions

### For Administrators

#### Managing Users
1. Navigate to `/admin/users`
2. View all users in the system
3. Create new users using the "Tạo Người Dùng Mới" button
4. Update user roles using the "Đổi Vai Trò" button
5. Activate/deactivate users using the status buttons

#### Managing Roles
1. Navigate to `/admin/roles`
2. View all available roles
3. Create new roles using the "Tạo Vai Trò Mới" button
4. Edit existing roles using the "Chỉnh Sửa" button
5. Delete custom roles (default roles are protected)

#### Viewing Activity Logs
1. Navigate to `/admin/activity-logs`
2. Filter logs by target type, action, or date range
3. View detailed audit trail of all system activities

### Database Setup
1. Run the main database script to create the base schema
2. Run `add_activity_logs_table.sql` to add the ActivityLogs table
3. Ensure the database connection is properly configured in `DBContext.java`

## API Endpoints

### User Management
- `GET /admin/users` - Display user management page
- `POST /admin/users` - Handle user management actions
  - `action=createUser` - Create new user
  - `action=updateRole` - Update user role
  - `action=updateStatus` - Update user status

### Role Management
- `GET /admin/roles` - Display role management page
- `POST /admin/roles` - Handle role management actions
  - `action=createRole` - Create new role
  - `action=updateRole` - Update existing role
  - `action=deleteRole` - Delete role

### Activity Logs
- `GET /admin/activity-logs` - Display activity logs with optional filtering

## Configuration

### Database Connection
Update the database connection settings in `src/main/java/context/DBContext.java`:
```java
String user = "sa";
String pass = "123";
String url = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=DentalClinicDB_MVP;trustServerCertificate=true";
```

### Servlet Mappings
All servlet mappings are configured in `src/main/webapp/WEB-INF/web.xml`.

## Testing

### Manual Testing
1. Login as administrator
2. Navigate to user management pages
3. Test creating, updating, and managing users and roles
4. Verify activity logs are being created
5. Test error scenarios (invalid inputs, unauthorized access)

### Security Testing
1. Try accessing management pages without login
2. Try accessing with non-administrator roles
3. Test SQL injection attempts
4. Verify audit trail is working correctly

## Future Enhancements

### Potential Improvements
1. **Password Hashing**: Implement proper password hashing (currently using plain text)
2. **Role Permissions**: Add granular permissions within roles
3. **Bulk Operations**: Support for bulk user operations
4. **Advanced Filtering**: More sophisticated filtering options for activity logs
5. **Export Functionality**: Export user lists and activity logs
6. **Email Notifications**: Notify users of role changes
7. **Two-Factor Authentication**: Enhanced security for administrator accounts

### Performance Optimizations
1. **Pagination**: Add pagination for large user lists
2. **Caching**: Implement caching for frequently accessed data
3. **Database Indexing**: Optimize database queries
4. **Async Logging**: Implement asynchronous activity logging

## Troubleshooting

### Common Issues
1. **Database Connection**: Ensure SQL Server is running and accessible
2. **Permission Errors**: Verify user has Administrator role
3. **Session Timeout**: Check session configuration in web.xml
4. **JSP Errors**: Ensure all JSP dependencies are available

### Debug Mode
Enable debug logging by setting appropriate log levels in the application configuration.

## Support
For technical support or questions about the User & Role Management system, please refer to the system documentation or contact the development team.
