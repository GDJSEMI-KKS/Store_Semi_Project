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
	
	// IdListCustonmeDao selectIdCstmListByPage Method 입력값 분기
	// checkbox value 값 받을 배열 생성
	String [] ckIdLevel = null; // 회원 IdLevel
	int [] intCkIdLevel = null; // String [] ckIdLevel의 값을 int로 받을 배열 
	String [] ckCstmRank = null; // 고객 등급
	String [] ckActive = null; // Id 활성화 여부
		
	// checkbox value 값에 따른 분기
	// ckIdLevel
	if(request.getParameter("ckIdLevel") != null){
		ckIdLevel = request.getParameterValues("ckIdLevel");
		intCkIdLevel = new int[ckIdLevel.length];
		
		for(int i=0; i<intCkIdLevel.length; i+=1){ 
			intCkIdLevel[i] = Integer.parseInt(ckIdLevel[i]);
		}
	}
	
	// ckCstmRank
	if(request.getParameter("ckCstmRank") != null){
		ckCstmRank = request.getParameterValues("ckCstmRank");
	}
	
	// ckActive
	if(request.getParameterValues("ckActive") != null){
		ckActive = request.getParameterValues("ckActive");
	}
	
	// 페이지 이동시 checkbox 값이 문자열로 넘어오지 않아 문자열로 변경
	String ckIdLevelStr = "";
	String ckCstmRankStr = "";
	String ckActiveStr = "";
	
	if(ckIdLevel != null){
		for(String s : ckIdLevel){
			ckIdLevelStr += "&ckIdLevel="+s;
		}
	} else if(ckCstmRank != null){
		for(String s : ckCstmRank){
			ckCstmRankStr += "&ckCstmrank="+s;
		}
	} else if(ckActive != null){
		for(String s : ckActive){
			ckActiveStr += "&ckActive="+s;
		}
	}
	// 디버깅코드
	System.out.println(BG_YELLOW+BLUE+ckIdLevelStr+"<-- ckIdLevelStr"+RESET);
	System.out.println(BG_YELLOW+BLUE+ckCstmRankStr+"<-- ckCstmRankStr"+RESET);
	System.out.println(BG_YELLOW+BLUE+ckActiveStr+"<-- ckActiveStr"+RESET);
	
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
	
	// IdListCustomerDao dao
	IdListCustomerDao idListCustomerDao = new IdListCustomerDao();
	
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage;
	int totalRow = idListCustomerDao.selectIdCstmListCnt(intCkIdLevel, ckCstmRank, ckActive);
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
	
	/* 1페이지당 adminCustomerList
	 * AdminQuestionDao adminQuestionListByPage(beginRow, rowPerPage, categoryName) method 
	*/
	ArrayList<HashMap<String,Object>> adminCustomerList = idListCustomerDao.selectIdCstmListByPage(beginRow, rowPerPage, intCkIdLevel, ckCstmRank, ckActive);
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>customerOne</title>
	<jsp:include page="/inc/link.jsp"></jsp:include>
</head>
<body>
<!-- 메뉴 -->
<jsp:include page="/inc/menu.jsp"></jsp:include>

<!-- -----------------------------메인 시작----------------------------------------------- -->
<div id="all">
      <div id="content">
        <div class="container">
          <div class="row">
            <div class="col-lg-12">
              <!-- 마이페이지 -->
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li aria-current="page" class="breadcrumb-item active">마이페이지</li>
                </ol>
              </nav>
            </div>
            <div class="col-lg-3">
              <!-- 고객메뉴 시작 -->
              <div class="card sidebar-menu">
                <div class="card-header">
                  <h3 class="h4 card-title">관리자 메뉴</h3>
                </div>
                <div class="card-body">
                  <ul class="nav nav-pills flex-column">
	                  <a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=loginId%>" class="nav-link "><i class="fa fa-list"></i>통계</a>
	                  <a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=loginId%>" class="nav-link "><i class="fa fa-list"></i>카테고리관리</a>
	                  <a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=loginId%>" class="nav-link "><i class="fa fa-list"></i>상품관리</a>
	                  <a href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=1" class="nav-link active"><i class="fa fa-list"></i>회원관리</a>
	                  <a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=loginId%>" class="nav-link "><i class="fa fa-list"></i>주문관리</a>
	                  <a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=loginId%>" class="nav-link "><i class="fa fa-list"></i>문의관리</a>
	                  <a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=loginId%>" class="nav-link "><i class="fa fa-list"></i>리뷰관리</a>
                </div>
              </div>
              <!-- /.col-lg-3-->
              <!-- 고객메뉴 끝 -->
            </div>
            <div class="col-lg-9">
              <div class="box">
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
												<li class="list-group-item pageNavLi" onclick="location.href='<%=request.getContextPath()%>
												/admin_customer/adminCustomerList.jsp?currentPage=<%=startPage-pageLength%><%=ckIdLevelStr%><%=ckCstmRankStr%><%=ckActiveStr%>'">
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
												<li class="list-group-item pageNavLi" onclick="location.href='<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=<%=i%><%=ckIdLevelStr%><%=ckCstmRankStr%><%=ckActiveStr%>'">
													<span><%=i%></span>
												</li>
										<%			
												}
											}
												if(endPage != lastPage){
										%>
													<li class="list-group-item pageNavLi" onclick="location.href='<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=<%=startPage+pageLength%><%=ckIdLevelStr%><%=ckCstmRankStr%><%=ckActiveStr%>'">
														<span>다음</span>
													</li>	
										<%			
												}
										%>
									</ul>
					</div>	
				  <!-- 수정, 삭제, 돌아가기 버튼 -->
				  <div class="box-footer d-flex justify-content-between">
                    <div class="col-md-6 text-center">
                     	
                    </div>
                    <div class="col-md-6 text-center">
                     	
                  </div>
                 </div>
				</div>
              </div>
            </div>
          </div>
        </div>
      </div>
	
	<!-- -----------------------------메인 끝----------------------------------------------- -->
<!-- footer -->
<jsp:include page="/inc/footer.jsp"></jsp:include>
<!-- copy -->
<jsp:include page="/inc/copy.jsp"></jsp:include>
<!-- 자바스크립트 -->
<jsp:include page="/inc/script.jsp"></jsp:include>
</body>
</html>	