<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>qnaAdd</title>
</head>
<body>
	<div>
		<form method="post" action="<%=request.getContextPath()%>/board_question/qnaAddAction.jsp">
			<table>
				<tr>
					<th>작성자</th>
					<td><%=loginId%></td>
				</tr>
				<tr>
					<th>카테고리</th>
					<td>
						<select name="category">
							<option value="">선택하세요</option>
							<option value="교환환불">교환환불</option>
							<option value="결제">결제</option>
							<option value="기타">기타</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>문의제목</th>
					<td>
						<input type="text" name="boardQTitle">
					</td>
				</tr>
				<tr>
					<th>문의내용</th>
					<td>
						<textarea rows="2" cols="80" name="boardQContent"></textarea>
					</td>
				</tr>
			</table>
			
			<div>
				<button type="submit">등록</button>
			</div>
		</form>
	</div>
</body>
</html>