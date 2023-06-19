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
		System.out.println(KMJ + "adminOrders 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId" + " <--adminOrders loginId");
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
	
	String id = "user1"; //테스트용 삭제예정
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("beginRow") + " <--adminOrders param beginRow" + RESET);
	System.out.println(KMJ + request.getParameter("rowPerPage") + " <--adminOrders param rowPerPage" + RESET);
	System.out.println(KMJ + request.getParameter("paymentStatus") + " <--adminOrders param paymentStatus" + RESET);
	System.out.println(KMJ + request.getParameter("deliveryStatus") + " <--adminOrders param deliveryStatus" + RESET);
	
	//요청값 유효성 검사: currentPage, rowPerPage
	int currentPage = 1;
	int rowPerPage = 10;
	//beginRow와 rowPerPage가 null이 아닌 경우에 변수에 저장
	if(request.getParameter("currentPage") != null 
		&& request.getParameter("rowPerPage") != null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	//검색조건이 null인 경우에는 length가 0인 배열을 매개변수로 보낸다
	String[] paymentStatus = null;
	String[] deliveryStatus = null;
	if(request.getParameterValues("paymentStatus") != null){
		paymentStatus = request.getParameterValues("paymentStatus");
		for(int i=0; i<paymentStatus.length; i++){ 
			System.out.println(KMJ + paymentStatus[i] + " <--adminOrders param paymentStatus["+i+"]" + RESET);
		}
	} else if(request.getParameterValues("deliveryStatus") != null){
		deliveryStatus = request.getParameterValues("deliveryStatus");
		for(int i=0; i<deliveryStatus.length; i++){
			System.out.println(KMJ + deliveryStatus[i] + " <--adminOrders param deliveryStatus["+i+"]" + RESET);
		}
	}
	
	System.out.println(KMJ + currentPage + " <--adminOrders currentPage" + RESET);
	System.out.println(KMJ + rowPerPage + " <--adminOrders rowPerPage" + RESET);
	System.out.println(KMJ + paymentStatus + " <--adminOrders paymentStatus" + RESET);
	System.out.println(KMJ + deliveryStatus + " <--adminOrders deliveryStatus" + RESET);

	int beginRow = (currentPage - 1)*rowPerPage;
	
	//주문목록 출력
	OrdersDao oDao = new OrdersDao();
	ArrayList<HashMap<String, Object>> list = oDao.selectOrdersListBySearch(paymentStatus, deliveryStatus, beginRow, rowPerPage);
	System.out.println(KMJ + list.size() + " <--adminOrders list.size()" + RESET);
	
	//페이지네이션에 필요한 변수 선언: ordersCnt, lastPage, pagePerPage, startPage, endPage
	int ordersCnt = oDao.selectOrdersListCnt(paymentStatus, deliveryStatus);
	int lastPage = ordersCnt / rowPerPage;
	//ordersCnt를 rowPerPage로 나눈 나머지가 있으면 lastPage + 1
	if(ordersCnt % rowPerPage != 0){
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
	System.out.println(KMJ + ordersCnt + " <--adminOrders ordersCnt" + RESET);
	System.out.println(KMJ + lastPage + " <--adminOrders lastPage" + RESET);
	System.out.println(KMJ + startPage + " <--adminOrders startPage" + RESET);
	System.out.println(KMJ + lastPage + " <--adminOrders endPage" + RESET);
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
	                  <a href="#" class="nav-link "><i class="fa fa-list"></i>상품관리</a>
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
					
					<form action="<%=request.getContextPath()%>/admin_orders/adminOrders.jsp" method="post">
					  <fieldset>
						<legend>검색</legend>
						<input type="hidden" name="currentPage" value="<%=currentPage%>">
						<input type="hidden" name="rowPerPage" value="<%=rowPerPage%>">
							<div class="d-flex justify-content-between">
							<div class="content-lg-10">
								<table class="table table-borderless"><!-- 검색조건 -->
								<tr>
									<th>결제상태</th>
									<td>
										<input id="wait" type="checkbox" name="paymentStatus" value="결제대기"><label for="wait">결제대기</label>
										&nbsp;<input id="complete" type="checkbox" name="paymentStatus" value="결제완료"><label for="complete">결제완료</label>
										&nbsp;<input id="cancel" type="checkbox" name="paymentStatus" value="취소"><label for="cancel">취소</label>
										&nbsp;<input id="refund" type="checkbox" name="paymentStatus" value="환불"><label for="refund">환불</label>
									</td>
								</tr>
								<tr>
									<th>배송상태</th>
									<td>
										<input id="ready" type="checkbox" name="deliveryStatus" value="발송준비"><label for="ready">발송준비</label>
										&nbsp;<input id="done" type="checkbox" name="deliveryStatus" value="발송완료"><label for="done">발송완료</label>
										&nbsp;<input id="onDelivery" type="checkbox" name="deliveryStatus" value="배송중"><label for="onDelivery">배송중</label>
										&nbsp;<input id="cplDelivery" type="checkbox" name="deliveryStatus" value="배송완료"><label for="cplDelivery">배송완료</label>
										&nbsp;<input id="cplOrder" type="checkbox" name="deliveryStatus" value="구매확정"><label for="cplOrder">구매확정</label>
									</td>
								</tr>
							 </table>
							</div>
							<div>
								<button type="submit" class="btn btn-primary">
		                    	<i class="fa fa-save"></i>
								검색</button>
							</div>
						</div>
					  </fieldset>
					</form>
					<br>
					<br>
					<!-- 주문목록 -->
					<h1>주문정보</h1>
					<div>
						<button type="submit" class="btn btn-primary btn-sm">
                    	<i class="fa fa-save"></i>
						변경적용</button>
					</div>
					<hr>
					<table class="table">
						<tr>
							<th>주문번호</th>
							<th>아이디</th>
							<th>카테고리</th>
							<th>상품번호</th>
							<th>주문수량</th>
							<th>주문금액</th>
							<th>결제상태</th>
							<th>배송상태</th>
							<th>주문일시</th>
							<th>수정일시</th>
						</tr>
						<%
							for(HashMap<String, Object> m : list){
						%>
								<tr>
									<td><%=m.get("orderNo")%></td>
									<td><%=m.get("id")%></td>
									<td><%=m.get("categoryName")%></td>
									<td><%=m.get("productNo")%></td>
									<td><%=m.get("orderCnt")%></td>
									<td><%=m.get("orderPrice")%></td>
									<td>
										<select class="form-control">
											<option value="결제대기">결제대기</option>
											<option value="결제완료">결제완료</option>
											<option value="취소">취소</option>
											<option value="환불">환불</option>
										</select>
										<%=m.get("paymentStatus")%>
									</td>
									<td>
										<%=m.get("deliveryStatus")%>
									</td>
									<td><%=m.get("createdate").toString().substring(0,10)%></td>
									<td><%=m.get("updatedate").toString().substring(0,10)%></td>
								</tr>
						<%
							}
						%>
					</table>
					</div>
					<!-- 페이지네이션 -->
					<div class="d-flex justify-content-center">
					<ul class="pagination">
						<!-- 첫페이지 -->
						<li class="page-item">
							<a class="page-link" href="<%=request.getContextPath()%>/admin_orders/adminOrders.jsp?currentPage=1">&#60;&#60;</a>
						</li>
						<!-- 이전 페이지블럭 (startPage - 1) -->
						<%
							if(startPage < 1){ //startPage가 1인 페이지블럭에서는 '이전'버튼 비활성화
						%>
								<li class="page-item disabled"><a class="page-link" href="#">&#60;</a></li>
						<%	
							} else {
						%>
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/admin_orders/adminOrders.jsp?currentPage=<%=startPage-1%>">&#60;</a>
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
									<a class="page-link" href="<%=request.getContextPath()%>/admin_orders/adminOrders.jsp?currentPage=<%=i%>">
										<%=i%>
									</a>
								</li>
						<%
								} else {
						%>
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/admin_orders/adminOrders.jsp?currentPage=<%=i%>">
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
									<a class="page-link" href="<%=request.getContextPath()%>/admin_orders/adminOrders.jsp?currentPage=<%=endPage+1%>">&#62;</a>
								</li>
						<%
							}
						%>
						
						<!-- 마지막페이지 -->
						<li class="page-item">
							<a class="page-link" href="<%=request.getContextPath()%>/admin_orders/adminOrders.jsp?currentPage=<%=lastPage%>">&#62;&#62;</a>
						</li>
					</ul>
				  </div><!-- 페이지네이션 끝 -->
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