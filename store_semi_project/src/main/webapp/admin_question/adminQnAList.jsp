<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="dao.*"%>
<%@ page import="vo.IdList"%>
<%
	//RESET ANST CODE 콘솔창 글자색, 배경색 지정
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
	
	// 현재 로그인 Id
	String loginId = null;
	if(session.getAttribute("loginId") != null){
		loginId = (String)session.getAttribute("loginId");
	}
	
	/* idLevel 유효성 검사
	 * idLevel == 0이면 redirection. return
	*/
	
	// IdListDao selectIdListOne(loginId) method
	IdListDao idListDao = new IdListDao();
	IdList idList = idListDao.selectIdListOne(loginId);
	int idLevel = idList.getIdLevel();
	
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	// categoryName : 카테고리명 받을 변수
	String categoryName = "";
	if(request.getParameter("categoryName") != null){
		categoryName = request.getParameter("categoryName");
		System.out.println(BG_YELLOW+BLUE+categoryName +"<--categoryName"+RESET);
	}
	
	// categoryList : <select> <option>에 사용할 카테고리 리스트
	ArrayList<String> categoryList = new ArrayList<>();
	categoryList.add("상품");
	categoryList.add("교환환불");
	categoryList.add("결제");
	categoryList.add("기타");
	
	/* adminQnAList 페이징
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
	
	// AdminQuestionDao
	AdminQuestionDao adminQuestionDao = new AdminQuestionDao();
	
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage;
	int totalRow = adminQuestionDao.selectAdminQnAListCnt(categoryName);
	int lastPage = totalRow / rowPerPage;
	
	if(totalRow % rowPerPage != 0){
		lastPage +=1;
	}
	System.out.println(BG_YELLOW+BLUE+currentPage + "<--adminQnAList.jsp currentPage"+RESET);
	System.out.println(BG_YELLOW+BLUE+beginRow + "<--adminQnAList.jsp beginRow"+RESET);
	System.out.println(BG_YELLOW+BLUE+totalRow + "<--adminQnAList.jsp totalRow"+RESET);
	System.out.println(BG_YELLOW+BLUE+lastPage + "<--adminQnAList.jsp lastPage"+RESET);
	
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
	System.out.println(BG_YELLOW+BLUE+currentBlock+"<--adminQnAList.jsp currentBlock"+RESET);
	System.out.println(BG_YELLOW+BLUE+startPage+"<--adminQnAList.jsp startPage"+RESET);
	System.out.println(BG_YELLOW+BLUE+endPage+"<--adminQnAList.jsp endPage"+RESET);
	
	/* 1페이지당 qnaList
	 * AdminQuestionDao adminQuestionListByPage(beginRow, rowPerPage, categoryName) method 
	*/
	ArrayList<HashMap<String,Object>> qnaList = adminQuestionDao.adminQuestionListByPage(beginRow, rowPerPage, categoryName);
%>
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>adminQnAList</title>
</head>
<body>
   
	<!-- 요청 폼 -->
	<div class="container">
		<form action="<%=request.getContextPath()%>/admin_question/adminQnAList.jsp" method="post">
			<select name="categoryName"><!-- select 선택한 값이 유지되도록 분기 -->
				
				<%
					if(categoryName.equals("")){
				%>
						<option value="" selected="selected">카테고리</option>
				<%	
							for(String category : categoryList){	
				%>
								<option value="<%=category%>"><%=category%></option>
				<%
							}
					} else {
				%>
						<option value="">카테고리</option>
				<%	
							for(String category : categoryList){
								
								if(categoryName.equals(category)){
				%>
									<option value="<%=category%>" selected="selected"><%=category%></option>
				<%					
								} else{
				%>
									<option value="<%=category%>"><%=category%></option>
				<%					
								}
							}
					}
				%>
				
			</select>
			<button type="submit">검색</button>
		</form>
	</div>
	<div>
		<table>
			<thead>
				<tr>
					<th>카테고리</th>
					<th>번호</th>
					<th>주문번호</th>
					<th>문의제목</th>
					<th>등록일</th>
					<th>답변여부</th>
				</tr>
			</thead>
	        <tbody>
		        <%
					for(HashMap<String, Object> m : qnaList){
				%>
						<tr onclick = "location.href='<%=request.getContextPath()%>/admin_question/adminQnADetail.jsp?qNo=<%=(Integer) m.get("qNo")%>&qCategory=<%=(String) m.get("qCategory")%>'">
							<td><%=(String) m.get("qCategory")%></td>
							<td><%=(Integer) m.get("rnum")%></td>
							<td><%=(Integer) m.get("qNo")%></td>
							<td><%=(String) m.get("qTitle")%></td>
							<td><%=((String) m.get("qCreatedate")).substring(0,10)%></td>
							<%
								if((Integer) m.get("aNoCnt") > 0){
							%>
									<td>답변완료</td>
							<%		
								} else{
							%>
									<td>미답변</td>
							<%		
								}
							%>
						</tr>
				<%		
					}
				%>
	        </tbody>
	     </table>
     </div>
     <!-- 페이지 네비게이션 -->
		<div>
			<ul>
				<%
					if(startPage > 1){
				%>
						<li onclick="location.href='<%=request.getContextPath()%>/admin_question/adminQnAList.jsp?currentPage=<%=startPage-pageLength%>&categoryName=<%=categoryName%>'">
							<span>이전</span>
						</li>
				<%		
					}
						for(int i = startPage; i <= endPage; i++){
							if(i == currentPage){
				%>
								<li>
									<span><%=i%></span>
								</li>
				<%
							} else{
				%>
						<li onclick="location.href='<%=request.getContextPath()%>/admin_question/adminQnAList.jsp?currentPage=<%=i%>&categoryName=<%=categoryName%>'">
							<span><%=i%></span>
						</li>
				<%			
						}
					}
						if(endPage != lastPage){
				%>
							<li onclick="location.href='<%=request.getContextPath()%>/admin_question/adminQnAList.jsp?currentPage=<%=startPage+pageLength%>&categoryName=<%=categoryName%>'">
								<span>다음</span>
							</li>	
				<%			
						}
				%>
			</ul>
		</div>	                                              
</body>

</html>