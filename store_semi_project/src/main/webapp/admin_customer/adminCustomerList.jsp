<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.IdListCustomerDao"%>
<%@page import="java.util.*"%>
<%
	// session값 유효성 검사
	
	// IdListCustonmeDao selectIdCstmListByPage Method 입력값 분기
	// checkbox value 값 받을 배열 생성
	String [] ckIdLevel = null; // 회원 IdLevel
	int [] intCkIdLevel = null; // String [] ckIdLevel의 값을 int로 받을 배열 
	String [] ckCstmRank = null; // 고객 등급
	String [] ckActive = null; // Id 활성화 여부
	
	// checkbox value 값에 따른 분기
	// ckIdLevel
	if(request.getParameter("ckIdLevel") == null){
		ckIdLevel = null;
	} else if(request.getParameter("ckIdLevel") != null){
		ckIdLevel = request.getParameterValues("ckIdLevel");
		intCkIdLevel = new int[ckIdLevel.length];
		
		for(int i=0; i<intCkIdLevel.length; i+=1){ 
			intCkIdLevel[i] = Integer.parseInt(ckIdLevel[i]);
		}
	}
	
	// ckCstmRank
	if(request.getParameter("ckCstmRank") == null){
		ckCstmRank = null;
	} else if(request.getParameter("ckCstmRank") != null){
		ckCstmRank = request.getParameterValues("ckCstmRank");
	}
	
	// ckActive
	if(request.getParameter("ckActive") == null){
		ckActive = null;
	} else if(request.getParameterValues("ckActive") != null){
		ckActive = request.getParameterValues("ckActive");
	}
	
	/* adminCustomerList 페이징
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
	System.out.println(currentPage + "<--adminCustomerList.jsp currentPage");
	
	// IdListCustomerDao dao
	IdListCustomerDao idListCustomerDao = new IdListCustomerDao();
	
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage;
	int totalRow = idListCustomerDao.selectIdCstmListCnt(intCkIdLevel, ckCstmRank, ckActive);
	int lastPage = totalRow / rowPerPage;
	System.out.println(lastPage + "<--adminCustomerList.jsp lastPage");
	if(totalRow % rowPerPage != 0){
		lastPage +=1;
	}
	
	/* 페이지 블럭
	* currentBlock : 현재 페이지 블럭
	* pageLength : 현제 페이지 블럭의 들어갈 페이지 수
	* startPage : 블럭의 시작 페이지 (currentBlock -1) * pageLength +1
	* endPage : 블럭의 마지막 페이지 startPage + pageLength -1
	* 맨 마지막 블럭에서는 끝지점에 도달하기 전에 페이지가 끝나기 때문에 아래와 같이 처리 
	* if(endPage > totalPage){endPage = totalPage;}
	*/
	
	int currentBlock = 0;
	int pageLength = 5;
	if(currentPage % pageLength == 0){
		currentBlock = currentPage / pageLength;
	}else{
		currentBlock = (currentPage / pageLength) +1;	
	}
	System.out.println(currentBlock+"<--adminCustomerList.jsp currentBlock");
	
	int startPage = (currentBlock -1) * pageLength +1;
	System.out.println(startPage+"<--adminCustomerList.jsp startPage");
	
	int endPage = startPage + pageLength -1;
	if(endPage > lastPage){
		endPage = lastPage;
	}
	System.out.println(endPage+"<--adminCustomerList.jsp endPage");
	
	/* 1페이지당 adminCustomerList
	 * AdminQuestionDao adminQuestionListByPage(beginRow, rowPerPage, categoryName) method 
	*/
	ArrayList<HashMap<String,Object>> adminCustomerList = idListCustomerDao.selectIdCstmListByPage(beginRow, rowPerPage, intCkIdLevel, ckCstmRank, ckActive);
	
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>adminCustomerList</title>
</head>
<body>
	<!-- 리스트 조회 폼 -->
	<div>
		<form action="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp" method="post">
			<div>
				<div>회원</div>
				<div>
					<input type ="checkbox" name="ckIdLevel" value="0"> 고객
					<input type ="checkbox" name="ckIdLevel" value="1"> 사원
					<input type ="checkbox" name="ckIdLevel" value="2"> 관리자
				</div>
				
				<div>회원등급</div>
				<div>
					<input type ="checkbox" name="ckCstmRank" value="gold"> Gold
					<input type ="checkbox" name="ckCstmRank" value="silver"> Silver
					<input type ="checkbox" name="ckCstmRank" value="bronze"> Bronze 
				</div>
				
				<div>활성화</div>
				<div>
					<input type ="checkbox" name="ckActive" value="Y"> 활성화
					<input type ="checkbox" name="ckActive" value="N"> 비활성화
				</div>
			</div>
			
			<div>
				<button type="submit">조회</button>
			</div>
		</form>
	</div>
	
	<!-- 조회 리스트 출력 -->
	<div>
		<table>
			<tr>
				<th>ID</th>
				<th>회원등급</th>
				<th>활성화</th>
			</tr>
			<%
				for(HashMap<String, Object> m : adminCustomerList){
			%>
				<tr onclick="location.href='<%=request.getContextPath()%>/admin_customer/customerOne.jsp?id=<%=(String) m.get("id")%>'">
					<td><%=(String) m.get("id")%></td>
					<td><%=(String) m.get("cstmRank")%></td>
					<td><%=(String) m.get("active")%></td>
				</tr>
			<%		
				}
			%>
		</table>
	</div>
	
	<!-- 페이지 네비게이션 -->
	<div class="pageNav">
		<ul class="list-group list-group-horizontal">
			<%
				if(startPage > 1){
			%>
					<li class="list-group-item pageNavLi" onclick="location.href='<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=<%=startPage-pageLength%>'">
						<span>이전</span>
					</li>
			<%		
				}
					for(int i = startPage; i <= endPage; i++){
						if(i == currentPage){
			%>
							<li class="list-group-item currentPageNav">
								<span><%=i%></span>
							</li>
			<%
						} else{
			%>
					<li class="list-group-item pageNavLi" onclick="location.href='<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=<%=i%>'">
						<span><%=i%></span>
					</li>
			<%			
					}
				}
					if(endPage != lastPage){
			%>
						<li class="list-group-item pageNavLi" onclick="location.href='<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=<%=startPage+pageLength%>'">
							<span>다음</span>
						</li>	
			<%			
					}
			%>
		</ul>
	</div>	
</body>
</html>