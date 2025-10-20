package controller;

import DAO.StockTransactionDAO;
import DAO.InventoryItemDAO;
import DAO.UserDAO;
import model.StockTransaction;
import model.InventoryItem;
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

@WebServlet("/admin/stock-transactions")
public class StockTransactionServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(StockTransactionServlet.class.getName());
    private StockTransactionDAO stockTransactionDAO;
    private InventoryItemDAO inventoryItemDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        stockTransactionDAO = new StockTransactionDAO();
        inventoryItemDAO = new InventoryItemDAO();
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
                    listTransactions(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "report":
                    showReport(request, response);
                    break;
                default:
                    listTransactions(request, response);
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in StockTransactionServlet doGet", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu.");
            request.getRequestDispatcher("/admin/stock-transactions.jsp").forward(request, response);
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
                response.sendRedirect(request.getContextPath() + "/admin/stock-transactions");
                return;
            }

            switch (action) {
                case "add":
                    addTransaction(request, response, currentUser);
                    break;
                case "bulk_in":
                    bulkStockIn(request, response, currentUser);
                    break;
                case "bulk_out":
                    bulkStockOut(request, response, currentUser);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/stock-transactions");
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in StockTransactionServlet doPost", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu.");
            request.getRequestDispatcher("/admin/stock-transactions.jsp").forward(request, response);
        }
    }

    private void listTransactions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String itemFilter = request.getParameter("itemFilter");
            String typeFilter = request.getParameter("typeFilter");
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");

            List<StockTransaction> transactions = stockTransactionDAO.getFilteredTransactions(
                itemFilter, typeFilter, dateFrom, dateTo);
            
            // Get all items for filter dropdown
            List<InventoryItem> allItems = inventoryItemDAO.getAllInventoryItems();
            
            request.setAttribute("transactions", transactions);
            request.setAttribute("allItems", allItems);
            request.setAttribute("itemFilter", itemFilter);
            request.setAttribute("typeFilter", typeFilter);
            request.setAttribute("dateFrom", dateFrom);
            request.setAttribute("dateTo", dateTo);
            
            request.getRequestDispatcher("/admin/stock-transactions.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing transactions", e);
            request.setAttribute("error", "Không thể tải danh sách giao dịch.");
            request.getRequestDispatcher("/admin/stock-transactions.jsp").forward(request, response);
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<InventoryItem> items = inventoryItemDAO.getAllInventoryItems();
            request.setAttribute("items", items);
            request.getRequestDispatcher("/admin/stock-transactions.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing add form", e);
            request.setAttribute("error", "Không thể tải form thêm giao dịch.");
            request.getRequestDispatcher("/admin/stock-transactions.jsp").forward(request, response);
        }
    }

    private void showReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String reportType = request.getParameter("reportType");
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");

            List<StockTransaction> transactions = stockTransactionDAO.getFilteredTransactions(
                null, null, dateFrom, dateTo);
            
            // Calculate summary statistics
            int totalIn = 0, totalOut = 0;
            for (StockTransaction transaction : transactions) {
                if ("IN".equals(transaction.getTransactionType())) {
                    totalIn += transaction.getQuantity();
                } else {
                    totalOut += transaction.getQuantity();
                }
            }

            request.setAttribute("transactions", transactions);
            request.setAttribute("reportType", reportType);
            request.setAttribute("dateFrom", dateFrom);
            request.setAttribute("dateTo", dateTo);
            request.setAttribute("totalIn", totalIn);
            request.setAttribute("totalOut", totalOut);
            
            request.getRequestDispatcher("/admin/stock-report.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing report", e);
            request.setAttribute("error", "Không thể tạo báo cáo.");
            request.getRequestDispatcher("/admin/stock-transactions.jsp").forward(request, response);
        }
    }

    private void addTransaction(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            String transactionType = request.getParameter("transactionType");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String notes = request.getParameter("notes");

            if (quantity <= 0) {
                request.setAttribute("error", "Số lượng phải lớn hơn 0.");
                doGet(request, response);
                return;
            }

            // Check stock for OUT transactions
            if ("OUT".equals(transactionType)) {
                InventoryItem item = inventoryItemDAO.getInventoryItemById(itemId);
                if (item.getQuantity() < quantity) {
                    request.setAttribute("error", "Không đủ hàng trong kho. Tồn kho hiện tại: " + item.getQuantity());
                    doGet(request, response);
                    return;
                }
            }

            StockTransaction transaction = new StockTransaction();
            transaction.setItemId(itemId);
            transaction.setTransactionType(transactionType);
            transaction.setQuantity(quantity);
            transaction.setPerformedBy(currentUser.getUserId());
            transaction.setNotes(notes);

            boolean success = stockTransactionDAO.addTransaction(transaction);
            if (success) {
                // Update inventory quantity
                int quantityChange = "IN".equals(transactionType) ? quantity : -quantity;
                inventoryItemDAO.updateQuantity(itemId, quantityChange);
                request.setAttribute("success", "Thêm giao dịch thành công.");
            } else {
                request.setAttribute("error", "Không thể thêm giao dịch.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error adding transaction", e);
            request.setAttribute("error", "Có lỗi xảy ra khi thêm giao dịch.");
        }

        doGet(request, response);
    }

    private void bulkStockIn(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            String[] itemIds = request.getParameterValues("itemIds");
            String[] quantities = request.getParameterValues("quantities");
            String notes = request.getParameter("notes");

            if (itemIds == null || quantities == null || itemIds.length != quantities.length) {
                request.setAttribute("error", "Dữ liệu không hợp lệ.");
                doGet(request, response);
                return;
            }

            int successCount = 0;
            for (int i = 0; i < itemIds.length; i++) {
                try {
                    int itemId = Integer.parseInt(itemIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);
                    
                    if (quantity > 0) {
                        StockTransaction transaction = new StockTransaction();
                        transaction.setItemId(itemId);
                        transaction.setTransactionType("IN");
                        transaction.setQuantity(quantity);
                        transaction.setPerformedBy(currentUser.getUserId());
                        transaction.setNotes(notes);

                        boolean success = stockTransactionDAO.addTransaction(transaction);
                        if (success) {
                            inventoryItemDAO.updateQuantity(itemId, quantity);
                            successCount++;
                        }
                    }
                } catch (NumberFormatException e) {
                    // Skip invalid entries
                }
            }

            if (successCount > 0) {
                request.setAttribute("success", "Nhập kho hàng loạt thành công cho " + successCount + " vật tư.");
            } else {
                request.setAttribute("error", "Không có giao dịch nào được thực hiện.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in bulk stock in", e);
            request.setAttribute("error", "Có lỗi xảy ra khi nhập kho hàng loạt.");
        }

        doGet(request, response);
    }

    private void bulkStockOut(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            String[] itemIds = request.getParameterValues("itemIds");
            String[] quantities = request.getParameterValues("quantities");
            String notes = request.getParameter("notes");

            if (itemIds == null || quantities == null || itemIds.length != quantities.length) {
                request.setAttribute("error", "Dữ liệu không hợp lệ.");
                doGet(request, response);
                return;
            }

            int successCount = 0;
            for (int i = 0; i < itemIds.length; i++) {
                try {
                    int itemId = Integer.parseInt(itemIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);
                    
                    if (quantity > 0) {
                        // Check stock
                        InventoryItem item = inventoryItemDAO.getInventoryItemById(itemId);
                        if (item.getQuantity() >= quantity) {
                            StockTransaction transaction = new StockTransaction();
                            transaction.setItemId(itemId);
                            transaction.setTransactionType("OUT");
                            transaction.setQuantity(quantity);
                            transaction.setPerformedBy(currentUser.getUserId());
                            transaction.setNotes(notes);

                            boolean success = stockTransactionDAO.addTransaction(transaction);
                            if (success) {
                                inventoryItemDAO.updateQuantity(itemId, -quantity);
                                successCount++;
                            }
                        }
                    }
                } catch (NumberFormatException e) {
                    // Skip invalid entries
                }
            }

            if (successCount > 0) {
                request.setAttribute("success", "Xuất kho hàng loạt thành công cho " + successCount + " vật tư.");
            } else {
                request.setAttribute("error", "Không có giao dịch nào được thực hiện.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in bulk stock out", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xuất kho hàng loạt.");
        }

        doGet(request, response);
    }
}
