package controller;

import DAO.InventoryItemDAO;
import DAO.StockTransactionDAO;
import DAO.UserDAO;
import model.InventoryItem;
import model.StockTransaction;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/inventory")
public class InventoryManagementServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(InventoryManagementServlet.class.getName());
    private InventoryItemDAO inventoryItemDAO;
    private StockTransactionDAO stockTransactionDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        inventoryItemDAO = new InventoryItemDAO();
        stockTransactionDAO = new StockTransactionDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Check if user has permission (Admin, ClinicManager, or Receptionist)
            String roleName = currentUser.getRole().getRoleName().toLowerCase();
            if (!roleName.equals("administrator") && !roleName.equals("clinicmanager") && 
                !roleName.equals("receptionist")) {
                request.setAttribute("error", "Bạn không có quyền truy cập trang này.");
                request.getRequestDispatcher("/403.jsp").forward(request, response);
                return;
            }

            String action = request.getParameter("action");
            if (action == null) {
                action = "list";
            }

            switch (action) {
                case "list":
                    listInventoryItems(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "view":
                    viewInventoryItem(request, response);
                    break;
                case "transactions":
                    showTransactions(request, response);
                    break;
                default:
                    listInventoryItems(request, response);
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in InventoryManagementServlet doGet", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu.");
            request.getRequestDispatcher("/admin/inventory-management.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String action = request.getParameter("action");
            if (action == null) {
                response.sendRedirect(request.getContextPath() + "/admin/inventory");
                return;
            }

            switch (action) {
                case "add":
                    addInventoryItem(request, response, currentUser);
                    break;
                case "update":
                    updateInventoryItem(request, response, currentUser);
                    break;
                case "delete":
                    deleteInventoryItem(request, response, currentUser);
                    break;
                case "stock_in":
                    stockIn(request, response, currentUser);
                    break;
                case "stock_out":
                    stockOut(request, response, currentUser);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/inventory");
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in InventoryManagementServlet doPost", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu.");
            request.getRequestDispatcher("/admin/inventory-management.jsp").forward(request, response);
        }
    }

    private void listInventoryItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<InventoryItem> items = inventoryItemDAO.getAllInventoryItems();
            List<InventoryItem> lowStockItems = inventoryItemDAO.getLowStockItems();
            
            request.setAttribute("items", items);
            request.setAttribute("lowStockItems", lowStockItems);
            request.setAttribute("lowStockCount", lowStockItems.size());
            
            request.getRequestDispatcher("/admin/inventory-management.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing inventory items", e);
            request.setAttribute("error", "Không thể tải danh sách vật tư.");
            request.getRequestDispatcher("/admin/inventory-management.jsp").forward(request, response);
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/inventory-management.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("id"));
            InventoryItem item = inventoryItemDAO.getInventoryItemById(itemId);
            if (item != null) {
                request.setAttribute("editItem", item);
            } else {
                request.setAttribute("error", "Không tìm thấy vật tư.");
            }
            request.getRequestDispatcher("/admin/inventory-management.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID không hợp lệ.");
            request.getRequestDispatcher("/admin/inventory-management.jsp").forward(request, response);
        }
    }

    private void viewInventoryItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("id"));
            InventoryItem item = inventoryItemDAO.getInventoryItemById(itemId);
            if (item != null) {
                List<StockTransaction> transactions = stockTransactionDAO.getTransactionsByItemId(itemId);
                request.setAttribute("item", item);
                request.setAttribute("transactions", transactions);
                request.getRequestDispatcher("/admin/inventory-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không tìm thấy vật tư.");
                request.getRequestDispatcher("/admin/inventory-management.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID không hợp lệ.");
            request.getRequestDispatcher("/admin/inventory-management.jsp").forward(request, response);
        }
    }

    private void showTransactions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<StockTransaction> transactions = stockTransactionDAO.getAllTransactions();
            request.setAttribute("transactions", transactions);
            request.getRequestDispatcher("/admin/stock-transactions.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing transactions", e);
            request.setAttribute("error", "Không thể tải lịch sử giao dịch.");
            request.getRequestDispatcher("/admin/stock-transactions.jsp").forward(request, response);
        }
    }

    private void addInventoryItem(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String unit = request.getParameter("unit");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int minStock = Integer.parseInt(request.getParameter("minStock"));

            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Tên vật tư không được để trống.");
                doGet(request, response);
                return;
            }

            InventoryItem item = new InventoryItem();
            item.setName(name.trim());
            item.setUnit(unit);
            item.setQuantity(quantity);
            item.setMinStock(minStock);

            boolean success = inventoryItemDAO.addInventoryItem(item);
            if (success) {
                request.setAttribute("success", "Thêm vật tư thành công.");
            } else {
                request.setAttribute("error", "Không thể thêm vật tư. Có thể tên đã tồn tại.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Số lượng và tồn kho tối thiểu phải là số.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error adding inventory item", e);
            request.setAttribute("error", "Có lỗi xảy ra khi thêm vật tư.");
        }

        doGet(request, response);
    }

    private void updateInventoryItem(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            String name = request.getParameter("name");
            String unit = request.getParameter("unit");
            int minStock = Integer.parseInt(request.getParameter("minStock"));

            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Tên vật tư không được để trống.");
                doGet(request, response);
                return;
            }

            InventoryItem item = inventoryItemDAO.getInventoryItemById(itemId);
            if (item == null) {
                request.setAttribute("error", "Không tìm thấy vật tư.");
                doGet(request, response);
                return;
            }

            item.setName(name.trim());
            item.setUnit(unit);
            item.setMinStock(minStock);

            boolean success = inventoryItemDAO.updateInventoryItem(item);
            if (success) {
                request.setAttribute("success", "Cập nhật vật tư thành công.");
            } else {
                request.setAttribute("error", "Không thể cập nhật vật tư.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating inventory item", e);
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật vật tư.");
        }

        doGet(request, response);
    }

    private void deleteInventoryItem(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            
            boolean success = inventoryItemDAO.deleteInventoryItem(itemId);
            if (success) {
                request.setAttribute("success", "Xóa vật tư thành công.");
            } else {
                request.setAttribute("error", "Không thể xóa vật tư. Có thể đang được sử dụng.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID không hợp lệ.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deleting inventory item", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xóa vật tư.");
        }

        doGet(request, response);
    }

    private void stockIn(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String notes = request.getParameter("notes");

            if (quantity <= 0) {
                request.setAttribute("error", "Số lượng nhập phải lớn hơn 0.");
                doGet(request, response);
                return;
            }

            StockTransaction transaction = new StockTransaction();
            transaction.setItemId(itemId);
            transaction.setTransactionType("IN");
            transaction.setQuantity(quantity);
            transaction.setPerformedBy(currentUser.getUserId());
            transaction.setNotes(notes);

            boolean success = stockTransactionDAO.addTransaction(transaction);
            if (success) {
                // Update inventory quantity
                inventoryItemDAO.updateQuantity(itemId, quantity);
                
                // Check if item is now out of low stock
                InventoryItem updatedItem = inventoryItemDAO.getInventoryItemById(itemId);
                if (updatedItem.isLowStock()) {
                    request.setAttribute("success", "Nhập kho thành công. ⚠️ Vật tư vẫn còn tồn kho thấp.");
                } else {
                    request.setAttribute("success", "Nhập kho thành công. ✅ Tồn kho đã đủ.");
                }
            } else {
                request.setAttribute("error", "Không thể thực hiện nhập kho.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Số lượng phải là số.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in stock in", e);
            request.setAttribute("error", "Có lỗi xảy ra khi nhập kho.");
        }

        doGet(request, response);
    }

    private void stockOut(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String notes = request.getParameter("notes");

            if (quantity <= 0) {
                request.setAttribute("error", "Số lượng xuất phải lớn hơn 0.");
                doGet(request, response);
                return;
            }

            // Check if enough stock
            InventoryItem item = inventoryItemDAO.getInventoryItemById(itemId);
            if (item.getQuantity() < quantity) {
                request.setAttribute("error", "Không đủ hàng trong kho. Tồn kho hiện tại: " + item.getQuantity());
                doGet(request, response);
                return;
            }

            StockTransaction transaction = new StockTransaction();
            transaction.setItemId(itemId);
            transaction.setTransactionType("OUT");
            transaction.setQuantity(quantity);
            transaction.setPerformedBy(currentUser.getUserId());
            transaction.setNotes(notes);

            boolean success = stockTransactionDAO.addTransaction(transaction);
            if (success) {
                // Update inventory quantity
                inventoryItemDAO.updateQuantity(itemId, -quantity);
                
                // Check if item is now in low stock
                InventoryItem updatedItem = inventoryItemDAO.getInventoryItemById(itemId);
                if (updatedItem.isLowStock()) {
                    request.setAttribute("success", "Xuất kho thành công. ⚠️ Cảnh báo: Vật tư đã sắp hết hàng!");
                } else {
                    request.setAttribute("success", "Xuất kho thành công.");
                }
            } else {
                request.setAttribute("error", "Không thể thực hiện xuất kho.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Số lượng phải là số.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in stock out", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xuất kho.");
        }

        doGet(request, response);
    }
}
