<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("reviewNo") + " <--deleteReviewAnswerAction param reviewNo" + RESET);
	
	//요청값 유효성 검사
	if(request.getParameter("reviewNo") == null){
		System.out.println("deleteReviewAnswer 요청값 null 리다이렉션");
		response.sendRedirect(request.getContextPath()+"/admin_review/adminReview.jsp");
		return;
	}
	int reviewNo = Integer.parseInt(request.getParameter("reviewNo"));
	//변수 디버깅
	System.out.println(KMJ + reviewNo + " <--deleteReviewAnswerAction reviewNo" + RESET);
	
	//삭제를 위한 dao타입 객체생성
	ReviewAnswerDao rDao = new ReviewAnswerDao();
	int row = rDao.deleteReviewAnswer(reviewNo);
	
	if(row == 0){
		System.out.println(KMJ + "삭제실패 deleteReviewAnswerAction" + RESET);
	} else {
		System.out.println(KMJ + "삭제성공 deleteReviewAnswerAction" + RESET);
	}
%>