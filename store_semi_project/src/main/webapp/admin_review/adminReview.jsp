<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	/* //로그인 유효성 검사 : 로그아웃상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/로그인.jsp");
		System.out.println(KMJ + "adminReview 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId" + " <-adminReview loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} 
	
	//id가 employees테이블에 없는 경우(관리자가 아닌 경우) 홈으로 리다이렉션
	IdListDao iDao = new IdListDao();
	IdList loginLevel = iDao.selectIdListOne(loginId);
	String idLevel = loginLevel.getIdLevel();
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	*/
	
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
	if(request.getParameter("currentPage") != null 
		&& request.getParameter("rowPerPage") != null){
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
	
	//리뷰목록 출력
	ReviewDao rDao = new ReviewDao();
	ArrayList<HashMap<String,Object>> list = rDao.selectReviewListByPage(beginRow, rowPerPage, answer);
	System.out.println(KMJ + list.size() + " <--adminReview list.size()" + RESET);

	//페이지네이션에 필요한 변수 선언: reviewCnt, lastPage, pagePerPage, startPage, endPage
	int reviewCnt = rDao.selectReviewCnt(beginRow, rowPerPage, answer);
	int lastPage = reviewCnt / rowPerPage;
	//reviewCnt를 rowPerPage로 나눈 나머지가 있으면 lastPage + 1
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
					<%
						if(answer.equals("all")){
					%>
							<input type="radio" name="answer" value="all" checked>전체
							<input type="radio" name="answer" value="true">답변대기
							<input type="radio" name="answer" value="false">답변완료
					<%
						} else if (answer.equals("true")){
					%>
							<input type="radio" name="answer" value="all">전체
							<input type="radio" name="answer" value="true" checked>답변대기
							<input type="radio" name="answer" value="false">답변완료
					<%
						} else {
					%>
							<input type="radio" name="answer" value="all">전체
							<input type="radio" name="answer" value="true">답변대기
							<input type="radio" name="answer" value="false" checked>답변완료
					<%
						}
					%>
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
	<!-- 페이지네이션 -->
	<ul class="pagination">
		<!-- 첫페이지 -->
		<li class="page-item">
			<a class="page-link" href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?currentPage=1">&#60;&#60;</a>
		</li>
		<!-- 이전 페이지블럭 (startPage - 1) -->
		<%
			if(startPage > 1){ //startPage가 1인 페이지블럭에서는 '이전'버튼 비활성화
		%>
				<li class="page-item disabled"><a class="page-link" href="#">&#60;</a></li>
		<%	
			} else {
		%>
				<li class="page-item">
					<a class="page-link" href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?currentPage=<%=startPage-1%>">&#60;</a>
				</li>
		<%
			}
		%>
		
		<!-- 현재페이지 -->
		<%
			for(int i=startPage; i<=endPage; i+=1){ //startPage~endPage 사이의 페이지i 출력하기
				if(currentPage == i){ //현재페이지와 i가 같은 경우에는 표시하기
		%>
				<li class="page-item active">
					<a class="page-link" href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?currentPage=<%=i%>">
						<span class="sr-only"><%=i%></span>
					</a>
				</li>
		<%
				} else {
		%>
				<li class="page-item">
					<a class="page-link" href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?currentPage=<%=i%>">
						<%=i%>
					</a>
				</li>
		<%	
				}
			}
		%>
		<!-- 다음 페이지블럭 (endPage + 1) -->
		<%
			if(lastPage == endPage){ //마지막페이지에서는 '다음'버튼 비활성화
		%>
				<li class="page-item disabled"><a class="page-link" href="#">&#62;</a></li>
		<%	
			} else {
		%>
				<li class="page-item">
					<a class="page-link" href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?currentPage=<%=endPage+1%>">&#62;</a>
				</li>
		<%
			}
		%>
		
		<!-- 마지막페이지 -->
		<li class="page-item">
			<a class="page-link" href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?currentPage=<%=lastPage%>">&#62;&#62;</a>
		</li>
	</ul>
</body>
</html>