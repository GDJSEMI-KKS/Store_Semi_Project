<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%
	//RESET ANST CODE 콘솔창 글자색, 배경색 지정
	final String RESET = "\u001B[0m";
	final String BLUE ="\u001B[34m";
	final String BG_YELLOW ="\u001B[43m";
	
	// request 인코딩
	request.setCharacterEncoding("utf-8");
	
	/* session 유효성 검사
	* session 값이 null이면 redirection. 리턴
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
	
	/* 요청값 유효성 검사
	 * 값이 null, ""이면 adminQnAList.jsp 페이지로 리턴
	*/ 
	if(request.getParameter("qNo") == null
		|| request.getParameter("qCategory") == null
		|| request.getParameter("qNo").equals("")
		|| request.getParameter("qCategory").equals("")){
		response.sendRedirect(request.getContextPath()+"/admin_question/adminQnAList.jsp");
		return;
	}
	
	// 값 저장
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	String qCategory = request.getParameter("qCategory");
	// 디버깅코드
	System.out.println(BG_YELLOW+BLUE+qNo+qNo+"<-- adminQnADetail.jsp qNo"+RESET);
	System.out.println(BG_YELLOW+BLUE+qNo+qCategory+"<-- adminQnADetail.jsp qCategory"+RESET);
	
	AdminQuestionDao adminQuestionDao = new AdminQuestionDao();
	
	// 카테고리의 따라 사용할 dao Method 분기
	Question question = null;
	BoardQuestion boardQuestion = null;
	ArrayList<Answer> answerList = null;
	ArrayList<BoardAnswer> boardAnswerList = null;
	
	if(qCategory.equals("상품")){
		question = adminQuestionDao.selectQuestionOne(qNo);
		answerList = adminQuestionDao.selectAnswerList(qNo);
	} else{
		boardQuestion = adminQuestionDao.selectBoardQuestionOne(qNo);
		boardAnswerList = adminQuestionDao.selectBoardAnswerList(qNo);
	}			
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 카테고리의 따라 상세페이지 내용 분기 -->
	<%
		if(qCategory.equals("상품")){
	%>
		<!-- 문의 상세내용 -->
		<div>
			<table>
				<tr>
					<th>카테고리</th>
					<td><%=question.getqCategory()%></td>
				</tr>
				<tr>
					<th>문의번호</th>
					<td><%=question.getqNo()%></td>
				</tr>
				<tr>
					<th>상품번호</th>
					<td><%=question.getProductNo()%></td>
				</tr>
				<tr>
					<th>문의제목</th>
					<td><%=question.getqTitle()%></td>
				</tr>
				<tr>
					<th>문의내용</th>
					<td><%=question.getqContent()%></td>
				</tr>
				<tr>
					<th>등록일</th>
					<td><%=question.getCreatedate()%></td>
				</tr>
				<tr>
					<th>수정일</th>
					<td><%=question.getUpdatedate()%></td>
				</tr>
			</table>
		</div>
		
		<!-- 답변 폼 -->
		<div>
			<form action="<%=request.getContextPath()%>/admin_question/adminAnswerAddAction.jsp" method="post">
				<input type="hidden" name="qCategory" value="<%=question.getqCategory()%>">
				<input type="hidden" name="qNo" value ="<%=question.getqNo()%>">
				<input type="hidden" name="id" value ="<%=loginId%>">
				<div>
					<table>
						<tr>
							<th>답변</th>
							<td>
								<textarea rows="2" cols="80" name="qContent"></textarea>
							</td>
						</tr>
					</table>
				</div>
				<div>
					<button type="submit">댓글입력</button>
				</div>
			</form>
		</div>
		
		<!-- 답변 출력 -->
		<div>
			<h4>답변</h4>
			<table>
				<%
					for(Answer answer : answerList){
				%>
						<tr>
							<th><%=answer.getaNo()%></th>
							<td>
								<p><%=answer.getaContent()%></p>
							</td>
						</tr>
				<%		
					}
				%>
				
			</table>
		</div>
		
	<%		
		} else {
	%>
		<!-- 문의 상세내용 -->
		<div>
			<table>
				<tr>
					<th>카테고리</th>
					<td><%=boardQuestion.getBoardQCategory()%></td>
				</tr>
				<tr>
					<th>문의번호</th>
					<td><%=boardQuestion.getBoardQNo()%></td>
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
					<th>등록일</th>
					<td><%=boardQuestion.getCreatedate()%></td>
				</tr>
				<tr>
					<th>수정일</th>
					<td><%=boardQuestion.getUpdatedate()%></td>
				</tr>
			</table>
		</div>
		<!-- 답변입력 폼 -->
		<div>
			<form action="<%=request.getContextPath()%>/admin_question/adminAnswerAddAction.jsp" method="post">
				<input type="hidden" name="qCategory" value="<%=boardQuestion.getBoardQCategory()%>">
				<input type="hidden" name="qNo" value ="<%=boardQuestion.getBoardQNo()%>">
				<input type="hidden" name="id" value ="<%=loginId%>">
				<div class="container p-3">
					<table class="table table-sm">
						<tr>
							<th>답변</th>
							<td>
								<textarea rows="2" cols="80" name="qContent"></textarea>
							</td>
						</tr>
					</table>
				</div>
				<div class="container">
					<button type="submit">댓글입력</button>
				</div>
			</form>
		</div>
		
		<!-- 답변 출력 -->
		<div>
			<h4>답변</h4>
			<table>
				<%
					for(BoardAnswer boardAnswer : boardAnswerList){
				%>
						<tr>
							<th><%=boardAnswer.getBoardANo()%></th>
							<td>
								<p><%=boardAnswer.getBoardAContent()%></p>
							</td>
						</tr>
				<%		
					}
				%>	
			</table>
		</div>
	<%		
		}
	%>
	
		
</body>
</html>