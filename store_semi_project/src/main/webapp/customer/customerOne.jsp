<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사: 로그아웃상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "customerOne 로그인필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("id") + " <--customerOne param id" + RESET);
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	if(request.getParameter("id") == null 
		|| !loginId.equals(request.getParameter("id"))){
		response.sendRedirect(request.getContextPath()+"/login.jsp");
		return;
	}
	String id = request.getParameter("id");
	System.out.println(KMJ + id + " <--customerOne id" + RESET);
	
	//고객정보 출력을 위한 dao생성
	CustomerDao cDao = new CustomerDao();
	Customer customer = cDao.selectCustomer(id);

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Customer One</title>
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
                  <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=loginId%>">마이페이지</a></li>
                  <li aria-current="page" class="breadcrumb-item active">프로필</li>
                </ol>
              </nav>
            </div>
            <div class="col-lg-3">
              <!-- 고객메뉴 시작 -->
              <div class="card sidebar-menu">
				<div class="card-header">
				  <h3 class="h4 card-title">고객 메뉴</h3>
				</div>
				<div class="card-body">
				  <ul class="nav nav-pills flex-column">
				   <a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=id%>" class="nav-link active"><i class="fa fa-list"></i>프로필</a>
				   <a href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=id%>&currentPage=1" class="nav-link"><i class="fa fa-user"></i>주문목록</a>
				   <a href="<%=request.getContextPath()%>/customer/customerReviewList.jsp?id=<%=id%>&currentPage=1" class="nav-link"><i class="fa fa-user"></i>리뷰목록</a>
				   <a href="<%=request.getContextPath()%>/id_list/logoutAction.jsp" class="nav-link"><i class="fa fa-sign-out"></i>로그아웃</a></ul>
				  </div>
				</div>
<!-- /.col-lg-3-->
              <!-- 고객메뉴 끝 -->
            </div>
            <div class="col-lg-9">
              <div class="box">
                <h1>나의 프로필</h1>
                <hr>
                	<table class="table">
						<tr><!-- 1행 -->
							<th>아이디</th>
							<td colspan="2"><%=customer.getId()%></td>
						</tr>
						<tr><!-- 2행 -->
							<th>이름</th>
							<td colspan="2"><%=customer.getCstmName()%></td>
						</tr>
						<tr><!-- 3행 -->
							<th>주소</th>
							<td><%=customer.getCstmAddress()%></td>
							<td>
								<a href="<%=request.getContextPath()%>/customer/addCustomerAddress.jsp?id=<%=id%>&currentPage=1">주소목록</a>
							</td>						
						</tr>
						<tr><!-- 4행 -->
							<th>이메일</th>
							<td colspan="2"><%=customer.getCstmEmail()%></td>
						</tr>
						<tr><!-- 5행 -->
							<th>생일</th>
							<td colspan="2"><%=customer.getCstmBirth()%></td>
						</tr>
						<tr><!-- 6행 -->
							<th>연락처</th>
							<td colspan="2"><%=customer.getCstmPhone()%></td>
						</tr>
						<tr><!-- 7행 -->
							<th>성별</th>
							<td colspan="2"><%=customer.getCstmGender()%></td>
						</tr>
						<tr><!-- 8행 -->
							<th>회원등급</th>
							<td colspan="2"><%=customer.getCstmRank()%></td>
						</tr>
						<tr><!-- 9행 -->
							<th>포인트</th>
							<td>
								<%=customer.getCstmPoint()%>
							</td>
							<td>
								<a href="<%=request.getContextPath()%>/customer/pointHistory.jsp?id=<%=id%>&currentPage=1">포인트이력확인</a> 
							</td>
						</tr>
					</table>
					<div class="box-footer d-flex justify-content-center">
                    <div class="col-md-6 text-center">
                    	<a href="<%=request.getContextPath()%>/customer/modifyCustomer.jsp?id=<%=customer.getId()%>" class="btn btn-primary">
                    	<i class="fa fa-save"></i>
						회원정보수정</a>
                    </div>
                    <div class="col-md-6 text-center">
                     	<a href="<%=request.getContextPath()%>/customer/modifyPassword.jsp?id=<%=customer.getId()%>" class="btn btn-primary">
                    	<i class="fa fa-save"></i>
						비밀번호변경</a>
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