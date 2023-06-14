<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사: 로그인이 되어있지 않거나 로그인정보가 요청id와 다를 경우 리다이렉션
	/* if(session.getAttribute("loginId") == null){
		response.sendRedirect(KMJ + request.getContextPath()+"/로그인페이지.jsp" + RESET);
		System.out.println(KMJ + "customerOne 로그인되어있지 않아 리다이렉션" + RESET);
		return;
	}
	String loginId = session.getAttribute(KMJ + "loginId" + " <--customerOne loginId" + RESET);*/

	/* //관리자가 아닌 경우 홈으로 리다이렉션
	IdListDao iDao = new IdListDao();
	IdList loginLevel = iDao.selectIdListOne(loginId);
	int idLevel = loginLevel.getIdLevel();
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} */
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(request.getParameter("id") + " <--customerOne id" + RESET);
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	if(request.getParameter("id") == null 
		|| request.getParameter("idLevel") == null
		|| request.getParameter("name") == null){
		response.sendRedirect(KMJ + request.getContextPath()+"/admin_customer/adminCustomerList.jsp" + RESET);
		return;
	}
	String id = request.getParameter("id");
	String idLevel = request.getParameter("idLevel");
	String empName = request.getParameter("name");
	
	System.out.println(KMJ + id + " <--modifyAdminCustomerLvAction id" + RESET); 
	System.out.println(KMJ + idLevel + " <--modifyAdminCustomerLvAction idLevel" + RESET);
	System.out.println(KMJ + empName + " <--modifyAdminCustomerLvAction empName" + RESET);
	
	Employees employee = new Employees();
	employee.setId(id);
	employee.setEmpName(empName);
	employee.setEmpLevel(idLevel);
	
	//사원목록에 추가
	EmployeesDao eDao = new EmployeesDao();
	int row = eDao.insertEmployee(employee);
	if(row == 1){
		System.out.println(KMJ + row + "modifyAdminCustomerLvAction row 사원목록에추가성공" + RESET);
	}
	
	//idList테이블 level변경
	IdListDao iDao = new IdListDao();
	int idRow = iDao.updateIdListIdLevel(id, Integer.parseInt(idLevel));
	
	response.sendRedirect(request.getContextPath()+"/admin_customer/customerOne.jsp?id="+id);

%>