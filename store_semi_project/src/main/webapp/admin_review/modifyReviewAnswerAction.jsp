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
	System.out.println(KMJ + request.getParameter("reviewNo") + " <--modifyReviewAnswerAction param reviewNo" + RESET);
	System.out.println(KMJ + request.getParameter("reviewAContent") + " <--modifyReviewAnswerAction param reviewAContent" + RESET);
	
	//요청값 유효성 검사
	if(request.getParameter("reviewAnswer") == null || request.getParameter("reviewAContent") == null){
		System.out.println("modifyReviewAnswer 요청값 null 리다이렉션");
		response.sendRedirect(request.getContextPath()+"/admin_review/adminReview.jsp");
		return;
	}
	int reviewNo = Integer.parseInt(request.getParameter("reviewNo"));
	String reviewAContent = request.getParameter("reviewAContent");	
	//변수 디버깅
	System.out.println(KMJ + reviewNo + " <--modifyReviewAnswerAction reviewNo" + RESET);
	ReviewAnswer rAnswer = new ReviewAnswer();
	rAnswer.setReviewNo(reviewNo);
	rAnswer.setReviewAContent(reviewAContent);
	
	//입력을 위한 dao타입 객체생성
	ReviewAnswerDao rDao = new ReviewAnswerDao();
	int row = rDao.updateReviewAnswer(rAnswer);
	
	if(row == 0){
		System.out.println(KMJ + "수정실패 modifyReviewAnswerAction" + RESET);
	} else {
		System.out.println(KMJ + "수정성공 modifyReviewAnswerAction" + RESET);
	}
%>
