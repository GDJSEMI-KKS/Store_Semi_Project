<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 유효성 검사 : 로그아웃 상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "orderSheet 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	System.out.println(KMJ + loginId + " <--orderSheet loginId");
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값 유효성 검사
	/* if(request.getParameter("cartNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int cartNo = Integer.parseInt(request.getParameter("cartNo")); */
	int cartNo = 3; //test용: 삭제예정
	System.out.println(KMJ + cartNo + " <--orderSheet cartNo" + RESET);
		
	//주문정보 출력
	CartDao cDao = new CartDao();
	HashMap<String, Object> cart = cDao.selectCartOne(cartNo);
	int totalPrice = (Integer)cart.get("cartCnt") * (Integer)cart.get("productPrice");
	
	//포인트정보 출력
	CustomerDao cstmDao = new CustomerDao();
	Customer customer = cstmDao.selectCustomer(loginId);
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
              <!-- breadcrumb-->
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a href="#">장바구니/주문</a></li>
                  <li aria-current="page" class="breadcrumb-item active">주문하기</li>
                </ol>
              </nav>
            </div>
            <div id="checkout" class="col-lg-9">
              <div class="box">
                <form action="<%=request.getContextPath()%>/orders/ordersAction.jsp" method="post">
					<input type="hidden" name="cartNo" value="<%=cartNo%>">
					<input type="hidden" name="id" value="<%=loginId%>">
					<input type="hidden" name="productNo" value="<%=cart.get("productNo")%>">
					<input type="hidden" name="orderCnt" value="<%=cart.get("cartCnt")%>">
					<input type="hidden" name="orderPrice" value="<%=(Integer)cart.get("productPrice")*(Integer)cart.get("cartCnt")%>">
                  <h1>주문하기</h1>
                  <div class="nav flex-column flex-md-row nav-pills text-center">
                  	<a href="checkout1.html" class="nav-link flex-sm-fill text-sm-center active"><i class="fa fa-map-marker"></i>주문하기</a>
                  	<a href="#" class="nav-link flex-sm-fill text-sm-center disabled"> <i class="fa fa-eye"></i>주문확인</a>
                  </div>
                 <div class="content py-3">
                 	<h3>주문자 정보</h3>
                    <div class="row">
                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="firstname">이름</label>
                          <input id="name" type="text" class="form-control" value="<%=customer.getCstmName()%>" required>
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="lastname">연락처</label>
                          <input id="phone" type="text" class="form-control" value="<%=customer.getCstmPhone()%>" required>
                        </div>
                      </div>
                    </div>
                    <!-- /.row-->
                    <div class="row">
                      <div class="col-md-12">
                        <div class="form-group">
                          <label for="address">주소</label>
                          <input id="address" type="text" class="form-control" value="<%=customer.getCstmAddress()%>">
                        </div>
                      </div>
                    </div>
                    <!-- /.row-->
                    
                    <br>
                    <br>
                    <h3>포인트</h3>
                    <div class="row">
                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="currPoint">가용포인트</label>
                          <input id="currPoint" name="currPoint" type="text" class="form-control" value="<%=customer.getCstmPoint()%>">
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="usePoint">사용포인트</label>
                          <input id="usePoint" name="usePoint" type="text" class="form-control" value="0" required>
                        </div>
                      </div>
                    </div>
                    <!-- /.row-->
                   
                    <br>
                    <br>
                    <h3>결제방법</h3>
                    <div class="row">
                      <div class="col-md-12">
                        <select name="payment" class="form-control">
                        	<option value="무통장입금">무통장입금</option>
                        	<option value="카드결제">카드결제</option>
                        </select>
                      </div>
                    </div>
                    <!-- /.row-->
                  </div>
                  <div class="box-footer d-flex justify-content-between"><a href="basket.html" class="btn btn-outline-secondary"><i class="fa fa-chevron-left"></i>장바구니</a>
                    <button type="submit" class="btn btn-primary">주문하기<i class="fa fa-chevron-right"></i></button>
                  </div>
                </form>
              </div>
              <!-- /.box-->
            </div>
            <!-- /.col-lg-9-->
            
            <!-- 주문정보 -->
            <div class="col-lg-3">
              <div id="order-summary" class="card">
                <div class="card-header">
                  <h3 class="mt-4 mb-4">주문정보</h3>
                </div>
                <div class="card-body">
                  <p class="text-muted">주문내용을 확인해주세요</p>
                  <div class="table-responsive">
                    <table class="table">
                      <tbody>
                        <tr>
                          <td>주문상품</td>
                          <th>
                          	<img src="<%=request.getContextPath()%>/product/productImg/<%=cart.get("productSaveFilename")%>" alt="이미지 준비중" height="10" width="auto">
							<br><%=cart.get("productName")%>
                          </th>
                        </tr>
                        <tr>
                          <td>상품금액</td>
                          <th><%=cart.get("productPrice")%>원</th>
                        </tr>
                        <tr>
                          <td>수량</td>
                          <th><%=cart.get("cartCnt")%></th>
                        </tr>
                        <tr class="total">
                          <td>합계</td>
                          <th><%=totalPrice%>원</th>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
            <!-- /.col-lg-3-->
          </div>
        </div>
      </div>
    </div>
    <!--
    *** FOOTER ***
    _________________________________________________________
    -->
    <jsp:include page="/inc/footer.jsp"></jsp:include>
    <!-- /#footer-->
    <!-- *** FOOTER END ***-->
    
    
    <!--
    *** COPYRIGHT ***
    _________________________________________________________
    -->
   <jsp:include page="/inc/copy.jsp"></jsp:include>
    <!-- *** COPYRIGHT END ***-->
    <!-- JavaScript files-->
    <jsp:include page="/inc/script.jsp"></jsp:include>
</body>
</html>