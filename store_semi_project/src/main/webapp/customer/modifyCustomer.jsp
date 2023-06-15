<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사: 로그인이 되어있지 않거나 로그인정보가 요청id와 다를 경우 리다이렉션
	/* if(session.getAttribute("loginId") == null){
		response.sendRedirect(KMJ + request.getContextPath()+"/로그인페이지.jsp" + RESET);
		System.out.println(KMJ + "modifyCustomer 로그인되어있지 않아 리다이렉션" + RESET);
		return;
	}
	String loginId = session.getAttribute(KMJ + "loginId" + " <--modifyCustomer loginId" + RESET);*/
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(request.getParameter("id") + " <--modifyCustomer id" + RESET);
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	/* if(request.getParameter("id") == null || !loginId.equals(request.getParameter("id"))){
		response.sendRedirect(KMJ + request.getContextPath()+"/메인.jsp" + RESET);
		return;
	}
	String id = request.getParameter("id");
	System.out.println(KMJ + id + " <--modifyCustomer id" + RESET); */
	
	String id = "user1";
	
	//고객정보 출력을 위한 dao생성
	CustomerDao cDao = new CustomerDao();
	Customer customer = cDao.selectCustomer(id);

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
                  <h3 class="h4 card-title">고객 메뉴</h3>
                </div>
                <div class="card-body">
                  <ul class="nav nav-pills flex-column">
	                  <a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=id%>" class="nav-link active"><i class="fa fa-list"></i>프로필</a>
	                  <a href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=id%>&currentPage=1" class="nav-link"><i class="fa fa-user"></i>주문목록</a>
	                  <a href="<%=request.getContextPath()%>/id_list/logoutAction.jsp" class="nav-link"><i class="fa fa-sign-out"></i>로그아웃</a></ul>
                </div>
              </div>
              <!-- /.col-lg-3-->
              <!-- 고객메뉴 끝 -->
            </div>
            <div class="col-lg-9">
              <div class="box">
                <h1>My Account</h1>
                	<form>
                  <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="firstname">아이디</label>
                        <input id="firstname"  name="id" value="<%=customer.getId()%>" readonly type="text" class="form-control">
                      </div>
                    </div>
                  </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="firstname">이름</label>
                        <input id="firstname" name="name" value="<%=customer.getCstmName()%>" type="text" class="form-control">
                      </div>
                    </div>
                   </div>
                    <div class="row">
                    <div class="col-md-9">
                      <div class="form-group">
                        <label for="firstname">주소</label>
                        <input id="firstname" name="address" value="<%=customer.getCstmAddress()%>" type="text" class="form-control">
                      </div>
                      <div class="col-md-3">
                      	<a href="<%=request.getContextPath()%>/customer/addCustomerAddress.jsp?id=<%=customer.getId()%>">주소추가</a>
                      </div>
                    </div>
                   </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="firstname">이메일</label>
                        <input id="firstname" type="text" class="form-control">
                      </div>
                    </div>
                   </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="firstname">생일</label>
                        <input id="firstname" type="text" class="form-control">
                      </div>
                    </div>
                   </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="firstname">연락처</label>
                        <input id="firstname" type="text" class="form-control">
                      </div>
                    </div>
                   </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="firstname">성별</label>
                        <input id="firstname" type="text" class="form-control">
                      </div>
                    </div>
                   </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="firstname">회원등급</label>
                        <input id="firstname" type="text" class="form-control">
                      </div>
                    </div>
                   </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="firstname">포인트</label>
                        <input id="firstname" type="text" class="form-control">
                      </div>
                    </div>
                   </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="firstname">총 주문금액</label>
                        <input id="firstname" type="text" class="form-control">
                      </div>
                    </div>
                    <div class="col-md-12 text-center">
                      <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i> 수정하기</button>
                    </div>
                  </div>
                </form>
                	<form action="<%=request.getContextPath()%>/customer/modifyCustomerAction.jsp" method="post">
						<table>
							<tr><!-- 1행 -->
								<th>id</th>
								<td><input type="text" name="id" value="<%=customer.getId()%>" readonly></td>
							</tr>
							<tr><!-- 2행 -->
								<th>이름</th>
								<td><input type="text" name="name" value="<%=customer.getCstmName()%>"></td>
							</tr>
							<tr><!-- 3행 -->
								<th>주소</th>
								<td>
									<input type="text" name="address" value="<%=customer.getCstmAddress()%>">
									<a class="modAddr" href="<%=request.getContextPath()%>/customer/addCustomerAddress.jsp?id=<%=customer.getId()%>">주소추가</a>
								</td>
							</tr>
							<tr><!-- 4행 -->
								<th>이메일</th>
								<td><input type="email" name="email" value="<%=customer.getCstmEmail()%>"></td>
							</tr>
							<tr><!-- 5행 -->
								<th>생일</th>
								<td><input type="date" name="birth" value="<%=customer.getCstmBirth()%>"></td>
							</tr>
							<tr><!-- 6행 -->
								<th>연락처</th>
								<td><input type="text" name="phone" value="<%=customer.getCstmPhone()%>"></td>
							</tr>
							<tr><!-- 7행 -->
								<th>성별</th>
								<td>
									<%
										if(customer.getCstmGender().equals("M")){
									%>
											<input type="radio" name="gender" value="M" checked>남자
											<input type="radio" name="gender" value="F">여자
									<%
										} else {
									%>
											<input type="radio" name="gender" value="M">남자
											<input type="radio" name="gender" value="F" checked>여자
									<%
										}
									%>
									
								</td>
							</tr>
							<tr><!-- 8행 -->
								<th>회원등급</th>
								<td><input type="text" name="rank" value="<%=customer.getCstmRank()%>" readonly></td>
							</tr>
							<tr><!-- 9행 -->
								<th>포인트</th>
								<td><input type="number" name="point" value="<%=customer.getCstmPoint()%>" readonly></td>
							</tr>
							<tr><!-- 10행 -->
								<th>총주문금액</th>
								<td><input type="number" name="sumPrice" value="<%=customer.getCstmSumPrice()%>" readonly></td>
							</tr>
						</table>
						<div class="col-md-6">
                     		<button class="btn btn-primary" type="submit"><i class="fa fa-save"></i>수정하기</button>
                   		</div>
						
					</form>
					<div class="row">
                    <div class="col-md-6 text-center">
                    	<a href="<%=request.getContextPath()%>/customer/modifyCustomer.jsp?id=<%=customer.getId()%>" class="btn btn-primary">
                    	<i class="fa fa-save"></i>
						회원정보수정</a>
                    </div>
                    <div class="col-md-6">
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
