<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	/* //로그인 유효성 검사 : 로그아웃 상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/로그인.jsp");
		System.out.println(KMJ + "addReviewAnswerAction 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId" + " <--addReviewAnswerAction loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} 
	
	//관리자가 아닌 경우 홈으로 리다이렉션
	IdListDao iDao = new IdListDao();
	IdList loginLevel = iDao.selectIdListOne(loginId);
	int idLevel = loginLevel.getIdLevel();
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	*/
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("reviewNo") + " <--addReviewAnswerAction param reviewNo" + RESET);
	System.out.println(KMJ + request.getParameter("reviewAContent") + " <--addReviewAnswerAction param reviewAContent" + RESET);
	
	//요청값 유효성 검사
	if(request.getParameter("reviewNo") == null 
		|| request.getParameter("reviewAContent") == null){
		response.sendRedirect(request.getContextPath()+"/admin_review/adminReview.jsp");
		return;
	}
	int reviewNo = Integer.parseInt(request.getParameter("reviewNo"));
	String reviewAContent = request.getParameter("reviewAContent");	
	System.out.println(KMJ + reviewNo + " <-addReviewAnswerAction reviewNo" + RESET);
	System.out.println(KMJ + reviewAContent + " <-addReviewAnswerAction reviewAContent" + RESET);
	
	ReviewAnswer rAnswer = new ReviewAnswer();
	rAnswer.setReviewNo(reviewNo);
	rAnswer.setReviewAContent(reviewAContent);
	
	//review_answer테이블에 삽입
	ReviewAnswerDao aDao = new ReviewAnswerDao();
	int row = aDao.insertReviewAnswer(rAnswer);
	
	if(row == 0){
		System.out.println(KMJ + row + " <--addReviewAnswerAction row 입력실패" + RESET);
	} else {
		System.out.println(KMJ + row + " <--addReviewAnswerAction row 입력성공" + RESET);
	}
	
	//입력action완료 후 리뷰목록으로 리다이렉션
	response.sendRedirect(request.getContextPath()+"/admin_review/adminReview.jsp?reviewNo="+reviewNo);
%>