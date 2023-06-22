<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	/* //로그인 유효성 검사 : 로그아웃 상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/로그인.jsp");
		System.out.println(KMJ + "admin_customer/customerOne 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId" + " <--ordersAction loginId");
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
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("id") + " <--admin_customer/customerOne param id" + RESET);
		
	//요청값 유효성 검사 : id가 넘어오지 않으면 회원리스트로 리다이렉션
	if(request.getParameter("id") == null){
		response.sendRedirect(request.getContextPath()+"/admin_customer/adminCustomerList.jsp");
		return;
	}
	String id = request.getParameter("id");
	System.out.println(KMJ + id + " <-admin_customer/customerOne id" + RESET); */
	
	String idLevel = "2"; //테스트용 삭제예정
	String id = "user5"; //테스트용 삭제예정

	//id가 employees테이블에 있는 경우(관리자인 경우) 관리자 상세페이지로 리다이렉션
	EmployeesDao eDao = new EmployeesDao();
	Employees employee = eDao.selectEmployee(id);
	if(employee != null){ 
		response.sendRedirect(request.getContextPath()+"/admin_customer/adminOne.jsp");
		return;
	}
	
	//회원정보 출력
	CustomerDao cDao = new CustomerDao();
	Customer customer = cDao.selectCustomer(id);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Admin Customer One</title>
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
	                  <a href="#" class="nav-link "><i class="fa fa-list"></i>통계</a>
	                  <a href="#" class="nav-link "><i class="fa fa-list"></i>카테고리관리</a>
	                  <a href="<%=request.getContextPath()%>/product/productList.jsp" class="nav-link "><i class="fa fa-list"></i>상품관리</a>
	                  <a href="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?id=<%=id%>&currentPage=1" class="nav-link active"><i class="fa fa-list"></i>회원관리</a>
	                  <a href="<%=request.getContextPath()%>/admin_orders/adminOrders.jsp?id=<%=id%>&currentPage=1" class="nav-link "><i class="fa fa-list"></i>주문관리</a>
	                  <a href="#" class="nav-link "><i class="fa fa-list"></i>문의관리</a>
	                  <a href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?id=<%=id%>&currentPage=1" class="nav-link "><i class="fa fa-list"></i>리뷰관리</a>
                </div>
              </div>
              <!-- /.col-lg-3-->
              <!-- 고객메뉴 끝 -->
            </div>
            <div class="col-lg-9">
              <div class="box">
              	<!-- 상세정보 -->
				<div>
					<form action="<%=request.getContextPath()%>/admin_customer/modifyAdminCustomerLvAction.jsp" method="post">
						<input type="hidden" name="id" value="<%=id%>">
						<input type="hidden" name="name" value="<%=customer.getCstmName()%>">
						<input type="hidden" name="idLevel" value="1">
						<h1>회원상세정보</h1>
						<hr>
						<table class="table">
							<tr><!-- 1행 -->
								<th>아이디</th>
								<td><%=customer.getId()%></td>
							</tr>
							<tr><!-- 2행 -->
								<th>이름</th>
								<td><%=customer.getCstmName()%></td>
							</tr>
							<tr><!-- 3행 -->
								<th>주소</th>
								<td><%=customer.getCstmAddress()%></td>
							</tr>
							<tr><!-- 4행 -->
								<th>이메일</th>
								<td><%=customer.getCstmEmail()%></td>
							</tr>
							<tr><!-- 5행 -->
								<th>생일</th>
								<td><%=customer.getCstmBirth()%></td>
							</tr>
							<tr><!-- 6행 -->
								<th>연락처</th>
								<td><%=customer.getCstmPhone()%></td>
							</tr>
							<tr><!-- 7행 -->
								<th>성별</th>
								<td><%=customer.getCstmGender()%></td>
							</tr>
							<tr><!-- 8행 -->
								<th>회원등급</th>
								<td><%=customer.getCstmRank()%></td>
							</tr>
							<%
								//관리자등급이 2인 경우에만 회원등급 변경가능
								if(idLevel.equals("2")){
							%>
									<tr>
										<th>관리자권한부여</th>
										<td>
											<button type="submit" class="btn btn-primary">권한주기</button>
										</td>
									</tr>
							<%
								}
							%>
							<tr><!-- 9행 -->
								<th>포인트</th>
								<td><%=customer.getCstmPoint()%></td>
							</tr>
							<tr><!-- 10행 -->
								<th>총주문금액</th>
								<td><%=customer.getCstmSumPrice()%></td>
							</tr>
						</table>
					</form>
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