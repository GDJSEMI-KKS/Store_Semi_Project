<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%@page import="java.util.*"%>
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
	System.out.println(BG_YELLOW+BLUE+boardQNo+"<--qnaModify.jsp boardQNo"+RESET);
	
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
	
	// categoryList : <select> <option>에 사용할 카테고리 리스트
	ArrayList<String> categoryList = new ArrayList<>();
	categoryList.add("상품");
	categoryList.add("교환환불");
	categoryList.add("결제");
	categoryList.add("기타");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>qnaModify</title>
</head>
<body>
	<!-- 수정폼-->
	<div>
		<form method ="post" action="<%=request.getContextPath()%>/board_question/qnaModifyAction.jsp">
			<table>
				<tr>
					<th>문의번호</th>
					<td>
						<input type="hidden" name="boardQNo" value="<%=boardQuestion.getBoardQNo()%>">
						<%=boardQuestion.getBoardQNo()%>
					</td>
				</tr>
				<tr>
					<th>작성자</th>
					<td><%=boardQuestion.getId()%></td>
				</tr>
				<tr>
					<th>카테고리</th>
					<td>
						<select name="category">
							<%
								for(String category : categoryList){
									if((boardQuestion.getBoardQCategory()).equals(category)){
							%>
										<option value="<%=category%>" selected="selected"><%=category%></option>
							<%			
									}else{
							%>
										<option value="<%=category%>"><%=category%></option>
							<%			
									}	
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<th>문의제목</th>
					<td>
						<input type="text" name="boardQTitle" value="<%=boardQuestion.getBoardQTitle()%>"></td>
				</tr>
				<tr>
					<th>문의내용</th>
					<td>
						<textarea rows="2" cols="80" name="boardQContent"><%=boardQuestion.getBoardQContent()%></textarea>
					</td>
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
			<div>
				<button type="submit">수정</button>
			</div>
		</form>
	</div>
</body>
</html>