package controller;

import DAO.ScheduleRequestDAO;
import DAO.UserDAO;
import model.ScheduleRequest;
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

@WebServlet("/manager/schedule-requests")
public class ManagerScheduleRequestServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ManagerScheduleRequestServlet.class.getName());
    private ScheduleRequestDAO scheduleRequestDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        scheduleRequestDAO = new ScheduleRequestDAO();
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
                request.setAttribute("error", "Bạn không có quyền truy cập trang này. Chỉ Clinic Manager mới có thể phê duyệt yêu cầu nghỉ.");
                request.getRequestDispatcher("/403.jsp").forward(request, response);
                return;
            }

            String action = request.getParameter("action");
            if (action == null) {
                action = "list";
            }

            switch (action) {
                case "list":
                    listRequests(request, response);
                    break;
                case "pending":
                    listPendingRequests(request, response);
                    break;
                case "approved":
                    listApprovedRequests(request, response);
                    break;
                case "rejected":
                    listRejectedRequests(request, response);
                    break;
                case "view":
                    viewRequest(request, response);
                    break;
                default:
                    listRequests(request, response);
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading schedule requests page", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu.");
            request.getRequestDispatcher("/manager/schedule-requests.jsp").forward(request, response);
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
                response.sendRedirect(request.getContextPath() + "/manager/schedule-requests");
                return;
            }

            switch (action) {
                case "approve":
                    approveRequest(request, response, currentUser);
                    break;
                case "reject":
                    rejectRequest(request, response, currentUser);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/manager/schedule-requests");
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing schedule request action", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu.");
            request.getRequestDispatcher("/manager/schedule-requests.jsp").forward(request, response);
        }
    }

    private void listRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<ScheduleRequest> requests = scheduleRequestDAO.getAllRequests();
            request.setAttribute("requests", requests);
            request.setAttribute("pendingCount", requests.stream().mapToInt(req -> "PENDING".equals(req.getStatus()) ? 1 : 0).sum());
            request.setAttribute("approvedCount", requests.stream().mapToInt(req -> "APPROVED".equals(req.getStatus()) ? 1 : 0).sum());
            request.setAttribute("rejectedCount", requests.stream().mapToInt(req -> "REJECTED".equals(req.getStatus()) ? 1 : 0).sum());
            request.getRequestDispatcher("/manager/schedule-requests.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing schedule requests", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách yêu cầu nghỉ.");
            request.getRequestDispatcher("/manager/schedule-requests.jsp").forward(request, response);
        }
    }

    private void listPendingRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<ScheduleRequest> requests = scheduleRequestDAO.getRequestsByStatus("PENDING");
            request.setAttribute("requests", requests);
            request.setAttribute("filterStatus", "PENDING");
            request.getRequestDispatcher("/manager/schedule-requests.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing pending requests", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách yêu cầu chờ duyệt.");
            listRequests(request, response);
        }
    }

    private void listApprovedRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<ScheduleRequest> requests = scheduleRequestDAO.getRequestsByStatus("APPROVED");
            request.setAttribute("requests", requests);
            request.setAttribute("filterStatus", "APPROVED");
            request.getRequestDispatcher("/manager/schedule-requests.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing approved requests", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách yêu cầu đã duyệt.");
            listRequests(request, response);
        }
    }

    private void listRejectedRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<ScheduleRequest> requests = scheduleRequestDAO.getRequestsByStatus("REJECTED");
            request.setAttribute("requests", requests);
            request.setAttribute("filterStatus", "REJECTED");
            request.getRequestDispatcher("/manager/schedule-requests.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing rejected requests", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách yêu cầu bị từ chối.");
            listRequests(request, response);
        }
    }

    private void viewRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int requestId = Integer.parseInt(request.getParameter("id"));
            ScheduleRequest scheduleRequest = scheduleRequestDAO.getRequestById(requestId);
            if (scheduleRequest != null) {
                request.setAttribute("scheduleRequest", scheduleRequest);
                request.getRequestDispatcher("/manager/schedule-request-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không tìm thấy yêu cầu nghỉ.");
                listRequests(request, response);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing schedule request", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xem chi tiết yêu cầu nghỉ.");
            listRequests(request, response);
        }
    }

    private void approveRequest(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            String managerNotes = request.getParameter("managerNotes");

            boolean success = scheduleRequestDAO.approveRequest(requestId, currentUser.getUserId(), managerNotes);
            if (success) {
                request.setAttribute("success", "Phê duyệt yêu cầu nghỉ thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi phê duyệt yêu cầu nghỉ.");
            }
            
            response.sendRedirect(request.getContextPath() + "/manager/schedule-requests?action=pending");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error approving schedule request", e);
            request.setAttribute("error", "Có lỗi xảy ra khi phê duyệt yêu cầu nghỉ.");
            listRequests(request, response);
        }
    }

    private void rejectRequest(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            String managerNotes = request.getParameter("managerNotes");

            boolean success = scheduleRequestDAO.rejectRequest(requestId, currentUser.getUserId(), managerNotes);
            if (success) {
                request.setAttribute("success", "Từ chối yêu cầu nghỉ thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi từ chối yêu cầu nghỉ.");
            }
            
            response.sendRedirect(request.getContextPath() + "/manager/schedule-requests?action=pending");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error rejecting schedule request", e);
            request.setAttribute("error", "Có lỗi xảy ra khi từ chối yêu cầu nghỉ.");
            listRequests(request, response);
        }
    }
}
