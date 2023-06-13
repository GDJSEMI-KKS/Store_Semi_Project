<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.AdminQuestionDao"%>
<%@ page import="java.net.*"%>
<%@ page import="vo.*"%>
<%
	// RESET ANST CODE 콘솔창 글자색, 배경색 지정
	final String RESET = "\u001B[0m";
	final String BLUE ="\u001B[34m";
	final String BG_YELLOW ="\u001B[43m";

	// request 인코딩
	request.setCharacterEncoding("utf-8");
	
	/* session 유효성 검사
	* session 값이 null이면 redirection. return.
	*/
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	/* 요청값 유효성 검사(qNo, qCategory, id)
	 * qNo, qCategory 값이 null, ""이면 adminQnAList.jsp redirection. return.
	 * id 값이 null, ""이면 home.jsp redirection. return.	 
	*/
	if(request.getParameter("qNo") == null
		|| request.getParameter("qCategory") == null
		|| request.getParameter("qNo").equals("")
		|| request.getParameter("qCategory").equals("")){
		
		response.sendRedirect(request.getContextPath()+"/admin_question/adminQnAList.jsp");
		return;
	
	} else if(request.getParameter("id") == null
				||request.getParameter("id").equals("")){
		
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} 
	
	// 값 저장
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	String qCategory = request.getParameter("qCategory");
	String id = request.getParameter("id");
	// 디버깅코드
	System.out.println(BG_YELLOW+BLUE+qNo+"<--adminAnswerAddAction.jsp qNo"+RESET);
	System.out.println(BG_YELLOW+BLUE+qCategory+"<--adminAnswerAddAction.jsp qCategory"+RESET);
	System.out.println(BG_YELLOW+BLUE+id+"<--adminAnswerAddAction.jsp id"+RESET);
	
	/* 요청값 유효성 검사(qContent)
	 * 값이 null, ""이면 adminQnADetail.jsp redirection. qNo, qCategory 전달. return. 
	 * qCategory 인코딩	 
	*/
	if(request.getParameter("qContent") == null
		|| request.getParameter("qContent").equals("")){
		
		String category = URLEncoder.encode(qCategory,"utf-8");
		response.sendRedirect(request.getContextPath()+"/admin_question/adminQnADetail.jsp?qNo="+qNo+"&qCategory="+category);
		return;
	}
	
	// 값 저장
	String qContent = request.getParameter("qContent");
	// 디버깅코드
	System.out.println(BG_YELLOW+BLUE+qContent+"<--adminAnswerAddAction.jsp qContent"+RESET);
	
	
	// category 값의 따라 분기하여 각 dao method 호출하여 실행
	if(qCategory.equals("상품")){
		
		// vo.Answer 값 저장
		Answer answer = new Answer();
		answer.setqNo(qNo);
		answer.setId(id);
		answer.setaContent(qContent);
		
		// AdminQuestionDao insertAnswer(answer) Method
		AdminQuestionDao adminQuestionDao = new AdminQuestionDao();
		int answerRow = adminQuestionDao.insertAnswer(answer);
		
		// answerRow 값 확인
		if(answerRow == 0){
			System.out.println(BG_YELLOW+BLUE+answerRow+"<-- adminAnswerAction.jsp insertAnswer 실패 answerRow"+RESET);
		} else if(answerRow == 1){
			System.out.println(BG_YELLOW+BLUE+answerRow+"<-- adminAnswerAction.jsp insertAnswer 성공 answerRow"+RESET);
			
		} else{
			System.out.println(BG_YELLOW+BLUE+answerRow+"<-- adminAnswerAction.jsp error answerRow"+RESET);
		}
		
	} else{
		
		// vo.BoardAnswer 값 저장
		BoardAnswer boardAnswer = new BoardAnswer();
		boardAnswer.setBoardQNo(qNo);
		boardAnswer.setId(id);
		boardAnswer.setBoardAContent(qContent);
		
		// AdminQuestionDao insertBoardAnswer(boardAnswer) Method
		AdminQuestionDao adminQuestionDao = new AdminQuestionDao();
		int boardAnswerRow = adminQuestionDao.insertBoardAnswer(boardAnswer);
		
		// boardAnswerRow 값 확인
		if(boardAnswerRow == 0){
			System.out.println(BG_YELLOW+BLUE+boardAnswerRow+"<-- adminAnswerAction.jsp insertBoardAnswer 실패 boardAnswerRow"+RESET);
		} else if(boardAnswerRow == 1){
			System.out.println(BG_YELLOW+BLUE+boardAnswerRow+"<-- adminAnswerAction.jsp insertBoardAnswer 성공 boardAnswerRow"+RESET);
			
		} else{
			System.out.println(BG_YELLOW+BLUE+boardAnswerRow+"<-- adminAnswerAction.jsp error boardAnswerRow"+RESET);
		}
	}
	
	/* redirection adminQnADetail.jsp, qNo, qCategory 전달
	 * qCategory 인코딩
	*/
	String category = URLEncoder.encode(qCategory,"utf-8");
	response.sendRedirect(request.getContextPath()+"/admin_question/adminQnADetail.jsp?qNo="+qNo+"&qCategory="+category);
%>