<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*"%>
<%
	// request 인코딩
	request.setCharacterEncoding("utf-8");

	/* session 유효성 검사
	* session 값이 null이 아니면 페이지 redirection. 리턴
	*/
	if(session.getAttribute("loginId") != null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}

	/* 요청값 유효성 검사(id, pw)
	* 값이 null, ""이면 login.jsp 페이지로 리턴
	*/
	if(request.getParameter("id") == null
		|| request.getParameter("pw") == null
		|| request.getParameter("id").equals("")
		|| request.getParameter("pw").equals("")){
		response.sendRedirect(request.getContextPath()+"/id_list/login.html");
		return;
	}
	// 값 저장
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	System.out.println(id + "<-- loginAction.jsp id");
	System.out.println(pw + "<-- loginAction.jsp pw");
	
	// vo.IdList 객체 생성하여 값 저장
	IdList paramIdList = new IdList();
	paramIdList.setId(id);
	paramIdList.setLastPw(pw);
	
	// IdListDao
	IdListDao idListDao = new IdListDao();
	
	/* loginCheck : idListDao.selectIdList(paramIdList) 리턴값 저장 변수
	* idListCheck : idListDao.selectIdListOne(id) 리턴값 저장 변수
	* loginCheck 값에 따른 redirection, session.setAttribute 유무 분기
	* loginCheck == true 일 때 idListCheck.getActive()값에 따른 redirection 분기
	* 로그인 후 마지막 로그인 날짜 update
	*/ 
	
	boolean loginCheck = idListDao.selectIdList(paramIdList);
	System.out.println(loginCheck +"<-- loginAction.jsp loginCheck");
	
	if(loginCheck == true){
		IdList idListCheck = idListDao.selectIdListOne(id);
		
		if(idListCheck.getActive().equals("Y")){
			session.setAttribute("loginId", id);
			response.sendRedirect(request.getContextPath()+"/home.jsp");
			System.out.println("로그인 성공, 세션 정보 :" +session.getAttribute("loginId"));
			
			// CustomerDao
			CustomerDao customerDao = new CustomerDao();
			int row = customerDao.updateLastLogin(id);
			if(row == 0){
				System.out.println(row + "<--loginAction.jsp updateLastLogin 실패 row");
			} else if(row == 1){
				System.out.println(row + "<--loginAction.jsp updateLastLogin 성공 row");
			} else {
				System.out.println("loginAction.jsp error row");
			}
			
		} else {
			response.sendRedirect(request.getContextPath()+"/id_list/login.html");
			System.out.println("로그인 실패 : Id Active N");
		} 	
	} else {
		response.sendRedirect(request.getContextPath()+"/id_list/login.html");
		System.out.println("로그인 실패 : Id 정보 없음");
	}	
	
	
%>