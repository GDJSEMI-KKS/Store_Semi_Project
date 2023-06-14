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
	System.out.println(KMJ + request.getParameter("beginRow") + " <--adminReview param beginRow" + RESET);
	System.out.println(KMJ + request.getParameter("rowPerPage") + " <--adminReview param rowPerPage" + RESET);
	System.out.println(KMJ + request.getParameter("answer") + " <--adminReview param answer" + RESET);
	
	//요청값 유효성 검사: currentPage, rowPerPage
	int currentPage = 1;
	int rowPerPage = 10;
	String answer = "all"; 
	//beginRow와 rowPerPage, answer가 null이 아닌 경우에 변수에 저장
	if(request.getParameter("currentPage") != null && request.getParameter("rowPerPage") != null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	} else if(request.getParameter("answer") != null){
		answer = request.getParameter("answer");
	}
	
	//변수 디버깅
	System.out.println(KMJ + currentPage + " <--adminReview currentPage" + RESET);
	System.out.println(KMJ + rowPerPage + " <--adminReview rowPerPage" + RESET);
	System.out.println(KMJ + answer + " <--adminReview answer" + RESET);

	int beginRow = (currentPage - 1)*rowPerPage;
	
	//review리스트 출력을 위한 dao타입객체생성
	ReviewDao rDao = new ReviewDao();
	//리스트 받기
	ArrayList<HashMap<String,Object>> list = rDao.selectReviewListByPage(beginRow, rowPerPage, answer);
	System.out.println(KMJ + list.size() + " <--adminReview list.size()" + RESET);

	//페이지네이션에 필요한 변수 선언: reviewCnt, lastPage, pagePerPage, startPage, endPage
	int reviewCnt = rDao.selectReviewCnt(beginRow, rowPerPage, answer);
	int lastPage = reviewCnt / rowPerPage;
	//ordersCnt를 rowPerPage로 나눈 나머지가 있으면 lastPage + 1
	if(reviewCnt % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	int pagePerPage = 10;
	int startPage = ((currentPage - 1)/pagePerPage)*pagePerPage + 1;
	int endPage = startPage + pagePerPage - 1;
	//endPage가 lastPage보다 크면 endPage = lastPage
	if(endPage > lastPage){
		endPage = lastPage; 
	}
	
	//변수 디버깅
	System.out.println(KMJ + reviewCnt + " <--adminReview reviewCnt" + RESET);
	System.out.println(KMJ + lastPage + " <--adminReview lastPage" + RESET);
	System.out.println(KMJ + startPage + " <--adminReview startPage" + RESET);
	System.out.println(KMJ + lastPage + " <--adminReview endPage" + RESET);
%>
<!DOCTYPE html>
<html class="no-js" >
<head>
	<meta charset="utf-8">
	<title>Admin Review</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/admin_review/adminReview.jsp">
		<table>
			<tr>
				<th>답변여부</th>
				<td>
					<input type="radio" name="answer" value="all">전체
					<input type="radio" name="answer" value="true">답변대기
					<input type="radio" name="answer" value="false">답변완료
				</td>
				<td><button type="submit">보기</button></td>
			</tr>
		</table>
	</form>
	<table>
		<tr>
			<th>후기번호</th>
			<th>주문번호</th>
			<th>제목번호</th>
			<th>조회수번호</th>
			<th>답변수</th>
			<th>작성일시</th>
			<th>수정일시</th>
			<th>답변하기</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list){
		%>
				<tr>
					<td><%=(Integer)m.get("reviewNo")%></td>
					<td><%=(Integer)m.get("orderNo")%></td>
					<td><%=m.get("reviewTitle").toString()%></td>
					<td><%=(Integer)m.get("reviewCheckCnt")%></td>
					<td>
						<% 
							if((Integer)m.get("cnt") > 0 ){
						%>
								답변완료
						<%
							} else {
						%>
								답변대기
						<%
							}
						%>
					</td>
					<td><%=(String)m.get("createdate")%></td>
					<td><%=(String)m.get("updatedate")%></td>
					<td><a href="<%=request.getContextPath()%>/admin_review/addReviewAnswer.jsp?reviewNo=<%=(Integer)m.get("reviewNo")%>">답변하기</a></td>
				</tr>
		<%
			}
		%>
	</table>
</body>
</html>