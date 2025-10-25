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

@WebServlet("/manager/inventory")
public class ManagerInventoryServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ManagerInventoryServlet.class.getName());
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

            // Check if user has permission (Only ClinicManager)
            String roleName = currentUser.getRole().getRoleName().toLowerCase();
            if (!roleName.equals("clinicmanager")) {
                request.setAttribute("error", "Bạn không có quyền truy cập trang này. Chỉ Clinic Manager mới có thể quản lý inventory.");
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
                case "view":
                    viewInventoryItem(request, response);
                    break;
                case "transactions":
                    showTransactions(request, response);
                    break;
                case "low_stock":
                    showLowStockItems(request, response);
                    break;
                default:
                    listInventoryItems(request, response);
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading inventory management page", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu.");
            request.getRequestDispatcher("/manager/inventory-management.jsp").forward(request, response);
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

            // Check if user has permission (Only ClinicManager)
            String roleName = currentUser.getRole().getRoleName().toLowerCase();
            if (!roleName.equals("clinicmanager")) {
                request.setAttribute("error", "Bạn không có quyền truy cập trang này.");
                request.getRequestDispatcher("/403.jsp").forward(request, response);
                return;
            }

            String action = request.getParameter("action");
            if (action == null) {
                response.sendRedirect(request.getContextPath() + "/manager/inventory");
                return;
            }

            switch (action) {
                case "add":
                    addInventoryItem(request, response, currentUser);
                    break;
                case "stock_in":
                    stockIn(request, response, currentUser);
                    break;
                case "stock_out":
                    stockOut(request, response, currentUser);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/manager/inventory");
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing inventory action", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu.");
            request.getRequestDispatcher("/manager/inventory-management.jsp").forward(request, response);
        }
    }

    private void listInventoryItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<InventoryItem> items = inventoryItemDAO.getAllInventoryItems();
            request.setAttribute("items", items);
            request.setAttribute("lowStockCount", items.stream().mapToInt(item -> item.isLowStock() ? 1 : 0).sum());
            request.getRequestDispatcher("/manager/inventory-management.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing inventory items", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách vật tư.");
            request.getRequestDispatcher("/manager/inventory-management.jsp").forward(request, response);
        }
    }

    private void viewInventoryItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("id"));
            InventoryItem item = inventoryItemDAO.getInventoryItemById(itemId);
            if (item != null) {
                request.setAttribute("item", item);
                List<StockTransaction> transactions = stockTransactionDAO.getTransactionsByItemId(itemId);
                request.setAttribute("transactions", transactions);
                request.getRequestDispatcher("/manager/inventory-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không tìm thấy vật tư.");
                listInventoryItems(request, response);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing inventory item", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xem chi tiết vật tư.");
            listInventoryItems(request, response);
        }
    }

    private void showTransactions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<StockTransaction> transactions = stockTransactionDAO.getAllTransactions();
            request.setAttribute("transactions", transactions);
            request.getRequestDispatcher("/manager/stock-transactions.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing transactions", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải lịch sử giao dịch.");
            request.getRequestDispatcher("/manager/stock-transactions.jsp").forward(request, response);
        }
    }

    private void showLowStockItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<InventoryItem> lowStockItems = inventoryItemDAO.getLowStockItems();
            request.setAttribute("items", lowStockItems);
            request.setAttribute("isLowStockView", true);
            request.getRequestDispatcher("/manager/inventory-management.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing low stock items", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách vật tư tồn kho thấp.");
            listInventoryItems(request, response);
        }
    }

    private void stockIn(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String notes = request.getParameter("notes");

            StockTransaction transaction = new StockTransaction();
            transaction.setItemId(itemId);
            transaction.setTransactionType("IN");
            transaction.setQuantity(quantity);
            transaction.setNotes(notes);
            transaction.setPerformedBy(currentUser.getUserId());

            boolean success = stockTransactionDAO.addTransaction(transaction);
            if (success) {
                // Update inventory quantity
                if ("IN".equals(transaction.getTransactionType())) {
                    inventoryItemDAO.updateQuantity(itemId, quantity);
                } else if ("OUT".equals(transaction.getTransactionType())) {
                    inventoryItemDAO.updateQuantity(itemId, -quantity);
                }
                request.setAttribute("success", "Nhập kho thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi nhập kho.");
            }
            
            response.sendRedirect(request.getContextPath() + "/manager/inventory?action=list");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing stock in", e);
            request.setAttribute("error", "Có lỗi xảy ra khi nhập kho.");
            listInventoryItems(request, response);
        }
    }

    private void stockOut(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String notes = request.getParameter("notes");

            // Check if there's enough stock
            InventoryItem item = inventoryItemDAO.getInventoryItemById(itemId);
            if (item.getQuantity() < quantity) {
                request.setAttribute("error", "Số lượng xuất kho vượt quá tồn kho hiện tại.");
                listInventoryItems(request, response);
                return;
            }

            StockTransaction transaction = new StockTransaction();
            transaction.setItemId(itemId);
            transaction.setTransactionType("OUT");
            transaction.setQuantity(quantity);
            transaction.setNotes(notes);
            transaction.setPerformedBy(currentUser.getUserId());

            boolean success = stockTransactionDAO.addTransaction(transaction);
            if (success) {
                // Update inventory quantity
                if ("IN".equals(transaction.getTransactionType())) {
                    inventoryItemDAO.updateQuantity(itemId, quantity);
                } else if ("OUT".equals(transaction.getTransactionType())) {
                    inventoryItemDAO.updateQuantity(itemId, -quantity);
                }
                request.setAttribute("success", "Xuất kho thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi xuất kho.");
            }
            
            response.sendRedirect(request.getContextPath() + "/manager/inventory?action=list");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing stock out", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xuất kho.");
            listInventoryItems(request, response);
        }
    }
    
    private void addInventoryItem(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            // Validate input parameters
            String name = request.getParameter("name");
            String unit = request.getParameter("unit");
            String quantityStr = request.getParameter("quantity");
            String minStockStr = request.getParameter("minStock");

            // Input validation
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Tên vật tư không được để trống.");
                listInventoryItems(request, response);
                return;
            }

            if (unit == null || unit.trim().isEmpty()) {
                request.setAttribute("error", "Đơn vị không được để trống.");
                listInventoryItems(request, response);
                return;
            }

            if (quantityStr == null || quantityStr.trim().isEmpty()) {
                request.setAttribute("error", "Số lượng không được để trống.");
                listInventoryItems(request, response);
                return;
            }

            if (minStockStr == null || minStockStr.trim().isEmpty()) {
                request.setAttribute("error", "Tồn kho tối thiểu không được để trống.");
                listInventoryItems(request, response);
                return;
            }

            // Parse numeric values
            int quantity, minStock;
            try {
                quantity = Integer.parseInt(quantityStr.trim());
                minStock = Integer.parseInt(minStockStr.trim());
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Số lượng và tồn kho tối thiểu phải là số nguyên dương.");
                listInventoryItems(request, response);
                return;
            }

            // Validate numeric values
            if (quantity < 0) {
                request.setAttribute("error", "Số lượng không được âm.");
                listInventoryItems(request, response);
                return;
            }

            if (minStock < 0) {
                request.setAttribute("error", "Tồn kho tối thiểu không được âm.");
                listInventoryItems(request, response);
                return;
            }

            // Create inventory item
            InventoryItem item = new InventoryItem();
            item.setName(name.trim());
            item.setUnit(unit.trim());
            item.setQuantity(quantity);
            item.setMinStock(minStock);

            // Check if item name already exists
            if (inventoryItemDAO.getItemByName(name.trim()) != null) {
                request.setAttribute("error", "Tên vật tư '" + name.trim() + "' đã tồn tại. Vui lòng chọn tên khác.");
                listInventoryItems(request, response);
                return;
            }

            // Add inventory item
            logger.info("Attempting to add inventory item: " + item.getName());
            boolean success = inventoryItemDAO.addInventoryItem(item);
            
            if (success) {
                logger.info("Successfully added inventory item: " + item.getName());
                request.setAttribute("success", "✅ Thêm vật tư '" + item.getName() + "' thành công!");
            } else {
                logger.warning("Failed to add inventory item: " + item.getName());
                request.setAttribute("error", "❌ Không thể thêm vật tư. Có thể tên đã tồn tại hoặc có lỗi xảy ra.");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Unexpected error adding inventory item", e);
            request.setAttribute("error", "❌ Có lỗi không mong muốn xảy ra khi thêm vật tư.");
        }

        // Always reload the inventory list
        listInventoryItems(request, response);
    }
}
