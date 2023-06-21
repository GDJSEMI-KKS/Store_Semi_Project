<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	ArrayList<HashMap<String, Object>> cartList = null;
	
	//로그아웃 상태인 경우는 장바구니 목록이 세션에 저장되어 있음
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "로그인 안되어 있어 cart에서 리다이렉션" + RESET);
		return;
	} 
	
	//로그인 상태면 id에 맞는 장바구니정보 불러오기
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} 
	CartDao cDao = new CartDao();
	cartList = cDao.selectCartListByPage(loginId);
	
	//이미지 저장경로
	String dir = request.getContextPath()+"/product/productImg";
	
	//장바구니 금액 합계
	int cartSum = 0;
	//상품재고량
	int productStock = 0;
	
	//할인률 출력
	DiscountDao disDao = new DiscountDao();
	Discount discount = null;
	double disRate = 0;
	int cartPrice = 0;
	int disPrice = 0;
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Cart</title>
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
                  <li class="breadcrumb-item"><a href="#">홈</a></li>
                  <li aria-current="page" class="breadcrumb-item active">장바구니</li>
                </ol>
              </nav>
            </div>
            <div id="basket" class="col-lg-12">
              <div class="box">
                 <h1>장바구니</h1>
                  <%
                  	if(cartList == null || cartList.size() < 1){
                  %>
                  	<p>장바구니가 비어있습니다.</p>
                  <%
                  	} else {
                  %>
	                  <p class="text-muted">주문은 번호별로 가능합니다.</p>
	                  <hr>
	                  <form method="post" action="<%=request.getContextPath()%>/orders/orderSheet.jsp">
	                  <div class="table-responsive">
	                    <table class="table">
	                      <thead>
	                      	<tr>
	                          <th>주문상품선택</th>
	                          <th colspan="2">제품</th>
	                          <th colspan="2">수량</th>
	                          <th>가격</th>
	                          <th>할인금액</th>
	                          <th colspan="2">합계</th>
	                        </tr>
	                      </thead>
	                      <tbody>
	                      	<%
	                      		for(HashMap<String, Object> m : cartList){
	                      			productStock = cDao.productCartStock((Integer)m.get("productNo"));
	                      			cartSum += (Integer)m.get("cartCnt") * (Integer)m.get("productPrice");
	                      			discount = disDao.selectProductCurrentDiscount((Integer)m.get("productNo"));
	                      			disRate = discount.getDiscountRate();
	                      			cartPrice = (Integer)m.get("productPrice") * (Integer)m.get("cartCnt");
	                      			disPrice = (int)Math.floor(cartPrice - cartPrice*(1-disRate));
	                      	%>
	                      			<tr>
	                      			  <td><input type="radio" name="cartNo" value="<%=m.get("cartNo")%>"></td> <!-- 선택한 cartNo가 넘어간다! -->
                      			  	  <td><a href="#"><img src="<%=dir%>/<%=m.get("productSaveFilename")%>" height="50" width="auto" alt="이미지준비중"></a></td>
			                          <td><a href="#"><%=(String)m.get("productName")%></a></td>
			                          <td>
			                          	<input name="cartCnt" type="number" value="<%=(Integer)m.get("cartCnt")%>" class="form-control" min="1" max="<%=productStock%>">
			                          </td>
			                          <td>
			                          	<button id="changeCtn" class="btn btn-sm btn-primary" type="button">수량변경</button>
			                          </td>
			                          <td><%=cartPrice%></td>
			                          <td><%=disPrice%><input type="hidden" name="disPrice" value="<%=disPrice%>"></td>
			                          <td><%=cartPrice-disPrice%></td>
			                          <td><a href="<%=request.getContextPath()%>/cart/removeCartNo.jsp?cartNo=<%=m.get("cartNo")%>"><i class="fa fa-trash-o"></i></a></td>
			                        </tr>
	                      	<%
	                      		}
	                      	%>
	                      </tbody>
	                      <tfoot>
	                        <tr>
	                          <th colspan="7">합계</th>
	                          <th colspan="2"><%=cartSum%></th>
	                        </tr>
	                      </tfoot>
	                    </table>
	                  </div>
	                  <!-- /.table-responsive-->
	                  <div class="box-footer d-flex justify-content-between flex-column flex-lg-row">
	                    <div class="left"><a href="<%=request.getContextPath()%>/home.jsp" class="btn btn-outline-secondary"><i class="fa fa-chevron-left"></i> 쇼핑계속하기</a></div>
	                    <div class="right">
	                      <button class="btn btn-outline-secondary"><i class="fa fa-refresh"></i> 주문하기</button>
	                      <button type="submit" class="btn btn-primary">주문하기 <i class="fa fa-chevron-right"></i></button>
	                    </div>
	                  </div>
	                </form>
	              </div>
	              <!-- /.box-->
	              <%
                  	}
				  %>
            </div>
            <!-- /.col-lg-12-->
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