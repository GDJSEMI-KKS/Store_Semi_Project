<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	/* //로그인 유효성 검사
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println(KMJ + "ordersAction 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId" + " <--ordersAction loginId");
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
	
	//요청값 유효성 검사: 
	if(request.getParameter("reviewNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int reviewNo = Integer.parseInt(request.getParameter("reviewNo"));
	//변수 디버깅
	System.out.println(KMJ + reviewNo + " <--addReviewAnswer reviewNo" + RESET);

	//review정보 출력
	ReviewDao rDao = new ReviewDao();
	HashMap<String, Object> review = rDao.selectReviewByReviewNo(reviewNo);
	ReviewAnswerDao aDao = new ReviewAnswerDao();
	ArrayList<ReviewAnswer> aList = aDao.SelectReviewAnswerList(reviewNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Review Answer</title>
</head>
<body>
	<table>
		<tr>
			<th>리뷰제목</th>
			<td><%=review.get("reviewTitle")%></td>
		</tr>
		<tr>
			<th>리뷰내용</th>
			<td><%=review.get("reviewContent")%></td>
		</tr>
	</table>
	<form action="<%=request.getContextPath()%>/admin_review/addReviewAnswerAction.jsp">
		<input type="hidden" name="reviewNo" value="<%=reviewNo%>">
		<table>
			<tr>
				<th>답변입력</th>
				<td><textarea name="reviewAContent" cols="80" rows="2"></textarea>
				<td><button type="submit">입력</button></td>
			</tr>
		</table>
	</form>
	<table><!-- 입력된 답변 -->
		<%
			for(ReviewAnswer a : aList){	
		%>
				<tr>
					<td><%=a.getReviewAContent()%></td>
					<td><%=a.getCreatedate()%></td>
					<td><a href="<%=request.getContextPath()%>/admin_review/modifyReviewAnswerAction.jsp?reviewNo=<%=reviewNo%>">수정</a></td>
					<td><a href="<%=request.getContextPath()%>/admin_review/deleteReviewAnswerAction.jsp?reviewNo=<%=reviewNo%>">삭제</a></td>
				</tr>
		<%
			}
		%>
	</table>
</body>
</html>