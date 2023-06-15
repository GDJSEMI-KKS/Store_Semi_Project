<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.*"%>
<%@page import="vo.*"%>
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
	
	// 요청 값 저장(searchWord, columnName)
	String searchWord = "";
	if(request.getParameter("searchWord") != null){
		searchWord = request.getParameter("searchWord");
	}
	String columnName = "";
	if(request.getParameter("columnName") != null){
		columnName = request.getParameter("columnName");
		
	}
	// 디버깅코드
	System.out.println(BG_YELLOW+BLUE+searchWord +"<--boardQuestionList.jsp searchWord"+RESET);
	System.out.println(BG_YELLOW+BLUE+columnName +"<--boardQuestionList.jsp columnName"+RESET);
	
	/* boardQuestionList 페이징
	* currentPage : 현재 페이지
	* rowPerPage : 페이지당 출력할 행의 수
	* beginRow : 시작 행번호
	* totalRow : 전체 행의 수
	* lastPage : 마지막 페이지를 담을 변수. totalRow(전체 행의 수) / rowPerPage(한 페이지에 출력되는 수)
	* totalRow % rowPerPage의 나머지가 0이 아닌경우 lastPage +1을 해야한다.
	*/
	
	int currentPage = 1;
	
	// currentPage 유효성 검사
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// BoardQuestionDao
	BoardQuestionDao boardQuestionDao = new BoardQuestionDao();
	
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage;
	int totalRow = boardQuestionDao.selectBoardQuestionListCnt(searchWord, columnName);
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0){
		lastPage +=1;
	}
	System.out.println(BG_YELLOW+BLUE+currentPage + "<--adminCustomerList.jsp currentPage"+RESET);
	System.out.println(BG_YELLOW+BLUE+beginRow + "<--adminCustomerList.jsp beginRow"+RESET);
	System.out.println(BG_YELLOW+BLUE+totalRow + "<--adminCustomerList.jsp totalRow"+RESET);
	System.out.println(BG_YELLOW+BLUE+lastPage + "<--adminCustomerList.jsp lastPage"+RESET);
	
	/* 페이지 블럭
	* currentBlock : 현재 페이지 블럭(currentPage / pageLength)
	* currentPage % pageLength != 0, currentBlock +1
	* pageLength : 현제 페이지 블럭의 들어갈 페이지 수
	* startPage : 블럭의 시작 페이지 (currentBlock -1) * pageLength +1
	* endPage : 블럭의 마지막 페이지 startPage + pageLength -1
	* 맨 마지막 블럭에서는 끝지점에 도달하기 전에 페이지가 끝나기 때문에 아래와 같이 처리 
	* if(endPage > lastPage){endPage = lastPage;}
	*/
	
	int pageLength = 5;
	int currentBlock = currentPage / pageLength;
	if(currentPage % pageLength != 0){
		currentBlock += 1;	
	}
	int startPage = (currentBlock -1) * pageLength +1;
	int endPage = startPage + pageLength -1;
	if(endPage > lastPage){
		endPage = lastPage;
	}
	System.out.println(BG_YELLOW+BLUE+currentBlock+"<--adminCustomerList.jsp currentBlock"+RESET);
	System.out.println(BG_YELLOW+BLUE+startPage+"<--adminCustomerList.jsp startPage"+RESET);
	System.out.println(BG_YELLOW+BLUE+endPage+"<--adminCustomerList.jsp endPage"+RESET);
	
	// 1페이지당 boardQuestionList
	ArrayList<HashMap<String, Object>> list = boardQuestionDao.selectBoardQuestionByPage(beginRow, rowPerPage, searchWord, columnName);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardQuestionList</title>
</head>
<body>
	<!-- 요청 폼 -->
	<div class="center">
		<form action="<%=request.getContextPath()%>/board_question/boardQuestionList.jsp" method="post">
			<select name="columnName"><!-- select 선택한 값이 유지되도록 분기 -->
				<%
					if(columnName.equals("") || columnName.equals("titleContent")){
				%>
					<option value="titleContent" selected="selected">제목+내용</option>
					<option value="title">제목</option>
					<option value="content">내용</option>
					<option value="id">작성자</option>
				<%		
					} else if(columnName.equals("title")){
				%>
					<option value="titleContent">제목+내용</option>
					<option value="title" selected="selected">제목</option>
					<option value="content">내용</option>
					<option value="id">작성자</option>
				<%		
					} else if(columnName.equals("content")){
				%>
					<option value="titleContent">제목+내용</option>
					<option value="title">제목</option>
					<option value="content" selected="selected">내용</option>
					<option value="id">작성자</option>
				<%		
					} else{
				%>
					<option value="titleContent">제목+내용</option>
					<option value="title">제목</option>
					<option value="content">내용</option>
					<option value="id" selected="selected">작성자</option>
				<%		
					}
				%>
			</select>
			<input type ="text" name="searchWord" value="<%=searchWord%>">
			<button type="submit">검색</button>
		</form>
	</div>
	
	<!-- 리스트 출력 -->
	<div>
		<table>
			<tr>
				<th>분류</th>
				<th>문의번호</th>
				<th>문의제목</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>조회수</th>
			</tr>
			<%
				for(HashMap<String, Object> bq: list){
					if(loginId.equals((String) bq.get("id"))){
			%>
					<tr onclick="location.href='<%=request.getContextPath()%>/board_question/qnaDetail.jsp?boardQNo=<%=(Integer) bq.get("boardQNo")%>'">
						<td><%=(String) bq.get("boardQCategory")%></td>
						<td><%=(Integer) bq.get("boardQNo")%></td>
						<td><%=(String) bq.get("boardQTitle")%></td>
						<td><%=(String) bq.get("id")%></td>
						<td><%=((String) bq.get("createdate")).substring(0,10)%></td>
						<td><%=(Integer) bq.get("boardQCheckCnt")%></td>
					<%
						if((Integer) bq.get("boardANoCnt") > 0){
					%>
							<td>답변완료</td>
					<%		
						} else{
					%>
							<td>확인중</td>
					<%		
						}
					%>
						
					</tr>
			<%			
					} else{
			%>
						<tr>
							<td><%=(String) bq.get("boardQCategory")%></td>
							<td><%=(Integer) bq.get("boardQNo")%></td>
							<td><%=(String) bq.get("boardQTitle")%></td>
							<td><%=(String) bq.get("id")%></td>
							<td><%=((String) bq.get("createdate")).substring(0,10)%></td>
							<td><%=(Integer) bq.get("boardQCheckCnt")%></td>
					<%
						if((Integer) bq.get("boardANoCnt") > 0){
					%>
							<td>답변완료</td>
					<%		
						} else{
					%>
							<td>확인중</td>
					<%		
						}
					%>
							<td>비공개</td>
					</tr>
			<%			
					}
			%>
				
			<%		
				}
			%>
		</table>
	</div>
	<div>
		<button type="button" onclick="location.href='<%=request.getContextPath()%>/board_question/qnaAdd.jsp'">문의등록</button>
	</div>
</body>
</html>