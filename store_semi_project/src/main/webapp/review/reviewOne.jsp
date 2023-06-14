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
	} */
	String loginId = "user1"; //test용: 삭제예정
	System.out.println(KMJ + loginId + " <--ordersAction loginId" + RESET);
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값 유효성 검사
	if(request.getParameter("reviewNo") == null){
		response.sendRedirect(request.getContextPath()+"/orderList.jsp?id="+loginId);
		return;
	}
	int reviewNo = Integer.parseInt(request.getParameter("reviewNo"));
	//리뷰번호별 리뷰 출력
	ReviewDao rDao = new ReviewDao();
	HashMap<String, Object> review = rDao.selectReviewByReviewNo(reviewNo);
	
	//리뷰번호별 답변 출력
	ReviewAnswerDao aDao = new ReviewAnswerDao();
	ArrayList<ReviewAnswer> aList = aDao.SelectReviewAnswerList(reviewNo);
	
	//리뷰이미지 저장위치
	String dir = request.getServletContext().getRealPath("/review/reviewImg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Review One</title>
</head>
<body>
	<table>
		<tr>
			<th>작성자</th>
			<td><%=(String)review.get("id")%></td>
		</tr>
		<tr>
			<th>제목</th>
			<td><%=(String)review.get("reviewTitle")%></td>
		</tr>
		<tr>
			<th>내용</th>
			<td><%=(String)review.get("reviewContent")%></td>
		</tr>
		<tr>
			<th>사진</th>
			<td><img src="<%=request.getContextPath()%>/review/reviewImg/<%=(String)review.get("reviewSaveFilename")%>"></td>
		</tr>
	</table>
	<a href="<%=request.getContextPath()%>/review/modifyReview.jsp?reviewNo=<%=reviewNo%>">수정하기</a>
	<%
		if(loginId.equals((String)review.get("id"))){
	%>
		<a href="<%=request.getContextPath()%>/review/removeReviewAction.jsp?reviewNo=<%=reviewNo%>">삭제하기</a>
	<%
		}
	%>
	
	<table><!-- 관리자답변 -->
		<%
			for(ReviewAnswer a : aList){	
		%>
				<tr>
					<td><%=a.getReviewAContent()%></td>
					<td><%=a.getCreatedate()%></td>
				</tr>
		<%
			}
		%>
	</table>
	
</body>
</html>