/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlets;


import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import Data.StudentManagement;

public class EnrollStudentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int studentId = Integer.parseInt(request.getParameter("student_id"));
        int courseId = Integer.parseInt(request.getParameter("course_id"));

        StudentManagement sm = new StudentManagement();
        boolean success = sm.enrollStudentInCourse(studentId, courseId);

        if (success) {
            response.sendRedirect("studentDetails.jsp?id=" + studentId + "&status=success");
        } else {
            response.sendRedirect("studentDetails.jsp?id=" + studentId + "&status=error");
        }
    }
}
