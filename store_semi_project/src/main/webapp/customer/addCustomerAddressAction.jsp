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
		System.out.println(KMJ + "modifyCustomer 로그인되어있지 않아 리다이렉션" + RESET);
		return;
	}
	String loginId = session.getAttribute(KMJ + "loginId" + " <--addCustomerAddressAction loginId" + RESET);*/
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("id") + " <--addCustomerAddressAction param id" + RESET);
	System.out.println(KMJ + request.getParameter("addName") + " <--addCustomerAddressAction param addName" + RESET);
	System.out.println(KMJ + request.getParameter("add") + " <--addCustomerAddressAction param add" + RESET);
	System.out.println(KMJ + request.getParameter("addDefault") + " <--addCustomerAddressAction param addDefault" + RESET);
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	if(request.getParameter("id") == null || request.getParameter("addName") == null
			|| request.getParameter("add") == null
			|| request.getParameter("id").equals("") || request.getParameter("addName").equals("")){
		response.sendRedirect(KMJ + request.getContextPath()+"/home.jsp" + RESET);
		return;
	}
	String id = request.getParameter("id");
	String addName = request.getParameter("addName");
	String add = request.getParameter("add");
	String addDefault = "N"; //체크박스 체크되어있으면 on,아니면 null
	if(request.getParameter("addDefault") != null){
		addDefault = "Y";
	}
	
	System.out.println(KMJ + id + " <--addCustomerAddressAction id" + RESET); 
	System.out.println(KMJ + addName + " <--addCustomerAddressAction addName" + RESET); 
	System.out.println(KMJ + add + " <--addCustomerAddressAction add" + RESET); 
	System.out.println(KMJ + addDefault + " <--addCustomerAddressAction addDefault" + RESET); 
	
	//변수를 Address타입으로 묶기
	Address address = new Address();
	address.setId(id);
	address.setAddressName(addName);
	address.setAddress(add);
	address.setAddressDefault(addDefault);
	
	//addDefault가 on인 경우에는(null이 아닌 경우) 주소추가하고 기존 기본주소는 기본값여부 N으로 바꾸기
	AddressDao aDao = new AddressDao();
	int insertRow = 0;
	int updateRow = 0;
	if(addDefault.equals("Y")){
		updateRow = aDao.updateAddressDefault(id); //기존 기본주소값 N으로 바꾸기
		insertRow = aDao.insertAddress(address); //기본주소 추가
		System.out.println(KMJ + insertRow + " <--addCustomerAddressAction inserRow 추가여부" + RESET);
		System.out.println(KMJ + updateRow + " <--addCustomerAddressAction inserRow 기본주소변경여부" + RESET);
	} else {
		insertRow = aDao.insertAddress(address); //기본주소 추가
		System.out.println(KMJ + insertRow + " <--addCustomerAddressAction inserRow 추가여부" + RESET);
	}
	
	response.sendRedirect(request.getContextPath()+"/customer/addCustomerAddress.jsp?id="+id);

%>