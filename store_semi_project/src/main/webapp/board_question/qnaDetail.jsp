<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%
	//RESET ANST CODE 콘솔창 글자색, 배경색 지정
	final String RESET = "\u001B[0m";
	final String BLUE ="\u001B[34m";
	final String BG_YELLOW ="\u001B[43m";

	/* session 유효성 검사
	* session 값이 null이면 redirection. return.
	*/
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	// 현재 로그인 Id
	String loginId = null;
	if(session.getAttribute("loginId") != null){
		loginId = (String)session.getAttribute("loginId");
	}
	
	/* 요청 값 유효성 검사
	 * 값이 null이면 redirection. return.
	*/
	if(request.getParameter("boardQNo") == null
		|| request.getParameter("boardQNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/board_question/qnaList.jsp");
		return;	
	}
	
	// 요청 값 저장
	int boardQNo = Integer.parseInt(request.getParameter("boardQNo"));
	System.out.println(BG_YELLOW+BLUE+boardQNo+"<--qnaDetail.jsp boardQNo"+RESET);
	
	// BoardQuestionDao
	BoardQuestionDao boardQuestionDao = new BoardQuestionDao();
	// 상세페이지 조회
	BoardQuestion boardQuestion = boardQuestionDao.selectBoardQuestionOne(boardQNo);
	
	/* 작성자 id, 현재 로그인 id 일치 검사
	 * 불일치 하면 redirection. return.
	*/ 
	if(loginId.equals(boardQuestion.getId()) == false){
		response.sendRedirect(request.getContextPath()+"/board_question/qnaList.jsp");
		return;	
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>qnaDetail</title>
</head>
<body>
	<!-- 상세페이지 출력 -->
	<div>
		<table>
			<tr>
				<th>문의번호</th>
				<td><%=boardQuestion.getBoardQNo()%></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><%=boardQuestion.getId()%></td>
			</tr>
			<tr>
				<th>카테고리</th>
				<td><%=boardQuestion.getBoardQCategory()%></td>
			</tr>
			<tr>
				<th>문의제목</th>
				<td><%=boardQuestion.getBoardQTitle()%></td>
			</tr>
			<tr>
				<th>문의내용</th>
				<td><%=boardQuestion.getBoardQContent()%></td>
			</tr>
			<tr>
				<th>조회수</th>
				<td><%=boardQuestion.getBoardQCheckCnt()%></td>
			</tr>
			<tr>
				<th>작성일</th>
				<td><%=boardQuestion.getCreatedate()%></td>
			</tr>
			<tr>
				<th>수정일</th>
				<td><%=boardQuestion.getUpdatedate()%></td>
			</tr>
		</table>
	</div>
	
	<!-- 수정, 삭제 버튼 -->
	<div>
		<button type="button" onclick="location.href='<%=request.getContextPath()%>/board_question/qnaModify.jsp?boardQNo=<%=boardQNo%>'">수정</button>
		<button type="button" onclick="location.href='<%=request.getContextPath()%>/board_question/qnaRemoveAction.jsp?boardQNo=<%=boardQNo%>'">삭제</button>
	</div>
</body>
</html>