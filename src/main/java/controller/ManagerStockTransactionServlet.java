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

@WebServlet("/manager/stock-transactions")
public class ManagerStockTransactionServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ManagerStockTransactionServlet.class.getName());
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

            // Check if user has permission (Only ClinicManager)
            String roleName = currentUser.getRole().getRoleName().toLowerCase();
            if (!roleName.equals("clinicmanager")) {
                request.setAttribute("error", "Bạn không có quyền truy cập trang này. Chỉ Clinic Manager mới có thể xem giao dịch kho.");
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
                case "report":
                    showReport(request, response);
                    break;
                default:
                    listTransactions(request, response);
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in ManagerStockTransactionServlet doGet", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu.");
            request.getRequestDispatcher("/manager/stock-transactions.jsp").forward(request, response);
        }
    }

    private void listTransactions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get filter parameters
            String itemFilter = request.getParameter("itemFilter");
            String typeFilter = request.getParameter("typeFilter");
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");

            List<StockTransaction> transactions;
            
            if (itemFilter != null || typeFilter != null || dateFrom != null || dateTo != null) {
                // Use filtered results
                transactions = stockTransactionDAO.getFilteredTransactions(itemFilter, typeFilter, dateFrom, dateTo);
            } else {
                // Get all transactions
                transactions = stockTransactionDAO.getAllTransactions();
            }

            // Get all inventory items for filter dropdown
            List<InventoryItem> items = inventoryItemDAO.getAllInventoryItems();

            request.setAttribute("transactions", transactions);
            request.setAttribute("allItems", items);
            request.setAttribute("itemFilter", itemFilter);
            request.setAttribute("typeFilter", typeFilter);
            request.setAttribute("dateFrom", dateFrom);
            request.setAttribute("dateTo", dateTo);

            request.getRequestDispatcher("/manager/stock-transactions.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing transactions", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách giao dịch.");
            request.getRequestDispatcher("/manager/stock-transactions.jsp").forward(request, response);
        }
    }

    private void showReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get report parameters
            String reportType = request.getParameter("reportType");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            List<StockTransaction> transactions = stockTransactionDAO.getAllTransactions();
            List<InventoryItem> items = inventoryItemDAO.getAllInventoryItems();

            request.setAttribute("transactions", transactions);
            request.setAttribute("items", items);
            request.setAttribute("reportType", reportType);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);

            request.getRequestDispatcher("/manager/stock-transactions.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing report", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tạo báo cáo.");
            request.getRequestDispatcher("/manager/stock-transactions.jsp").forward(request, response);
        }
    }
}
