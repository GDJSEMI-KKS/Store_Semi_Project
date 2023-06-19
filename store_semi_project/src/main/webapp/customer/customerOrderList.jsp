<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 유효성 검사
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println(KMJ + "customerOrderList 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	System.out.println(KMJ + loginId + " <--customerOrderList loginId");
	
	//요청값 유효성 검사
	if(request.getParameter("id") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	int beginRow = (currentPage - 1)*rowPerPage;
	System.out.println(KMJ + currentPage + " <--customerOrderList currentPage" + RESET);
	System.out.println(KMJ + rowPerPage + " <--customerOrderList rowPerPage" + RESET);
	System.out.println(KMJ + beginRow + " <--customerOrderList beginRow" + RESET);
	
	//id에 따른 주문목록 출력
	OrdersDao oDao = new OrdersDao();
	ArrayList<HashMap<String, Object>> list = oDao.selectOrderById(loginId, beginRow, rowPerPage);
	System.out.println(KMJ + list.size() + " <--orderList list.size()" + RESET);
	String dir = request.getServletContext().getRealPath("/productImg");
	
	//주문번호별 리뷰 수 (리뷰는 한 주문(상품) 당 1개만 가능) 출력
	ReviewDao rDao = new ReviewDao();
	
	//페이지네이션에 필요한 변수 선언: ordersCnt, lastPage, pagePerPage, startPage, endPage
	int ordersCnt = oDao.selectOrderCntById(loginId);
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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Order List</title>
<jsp:include page="/inc/link.jsp"></jsp:include>
</head>
<body>
<!-- 메뉴 -->
<jsp:include page="/inc/menu.jsp"></jsp:include>
	<div id="all">
      <div id="content">
        <div class="container">
          <div class="row">
            <div class="col-lg-12">
              <!-- breadcrumb-->
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a href="#">마이페이지</a></li>
                  <li aria-current="page" class="breadcrumb-item active">주문목록</li>
                </ol>
              </nav>
            </div>
            <div class="col-lg-3">
              <!--
              *** CUSTOMER MENU ***
              _________________________________________________________
              -->
              <div class="card sidebar-menu">
				<div class="card-header">
				  <h3 class="h4 card-title">고객 메뉴</h3>
				</div>
				<div class="card-body">
				  <ul class="nav nav-pills flex-column">
				   <a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=loginId%>" class="nav-link"><i class="fa fa-list"></i>프로필</a>
				   <a href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=1" class="nav-link active"><i class="fa fa-user"></i>주문목록</a>
				   <a href="<%=request.getContextPath()%>/id_list/logoutAction.jsp" class="nav-link"><i class="fa fa-sign-out"></i>로그아웃</a></ul>
				  </div>
				</div>
				<!-- /.col-lg-3-->
              <!-- *** CUSTOMER MENU END ***-->
            </div>
            <div id="customer-orders" class="col-lg-9">
              <div class="box">
                <h1>주문목록</h1>
                <hr>
                <div class="table-responsive">
                  <table class="table table-hover">
                    <thead>
                      <tr>
						<td colspan="2">주문상품</td>
						<td>주문수량</td>
						<td>주문금액</td>
						<td>결제상태</td>
						<td>배송상태</td>
						<td>주문일자</td>
						<td>리뷰작성</td>
                      </tr>
                    </thead>
                    <tbody>
                   	<%
                   		for(HashMap<String, Object> m : list){
                   			int orderNo = rDao.selectReviewCntByOrderNo((Integer)m.get("orderNo"));
                   	%>
                   			<tr>
								<td colspan="2">
									<!-- <img src="<%=request.getContextPath()%>/product/productImg/" alt="이미지준비중"> -->
									<%=(String)m.get("productName")%>
								</td>
								<td><%=(Integer)m.get("orderCnt")%></td>
								<td><%=(Integer)m.get("orderCnt") * (Integer)m.get("orderPrice")%></td>
								<td><span id="paymentStatus" class="badge badge-info"><%=(String)m.get("paymentStatus")%></span></td>
								<td><span id="deliveryStatus" class="badge badge-info"><%=(String)m.get("deliveryStatus")%></span></td>
								<td><%=m.get("createdate").toString().substring(0, 11)%></td>
								<%
									if(orderNo == 0){ //해당 주문번호의 리뷰 수가 0일 경우에는 리뷰작성 출력
								%>
										<td><a class="btn btn-primary" href="<%=request.getContextPath()%>/review/addReview.jsp?orderNo=<%=(Integer)m.get("orderNo")%>">리뷰작성</a></td>
								<%
									} else {
										HashMap<String, Object> review = rDao.selectReviewByOrderNo(orderNo);
										int reviewNo = (Integer)review.get("reviewNo");
								%>
										<td><a class="btn btn-outline-primary" href="<%=request.getContextPath()%>/review/reviewOne.jsp?reviewNo=<%=reviewNo%>&id=<%=loginId%>">리뷰보기</a></td>
								<%
									}
								%>
							</tr>
                   	<%
                   		}
                   	%>
                    </tbody>
                  </table>
                  <!-- 페이지네이션 -->
                  <div class="d-flex justify-content-center">
					<ul class="pagination">
						<!-- 첫페이지 -->
						<li class="page-item">
							<a class="page-link" href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=1">&#60;&#60;</a>
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
									<a class="page-link" href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=<%=startPage-1%>">&#60;</a>
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
									<a class="page-link" href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=<%=i%>">
										<%=i%>
									</a>
								</li>
						<%
								} else {
						%>
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=<%=i%>">
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
									<a class="page-link" href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=<%=endPage+1%>">&#62;</a>
								</li>
						<%
							}
						%>
						
						<!-- 마지막페이지 -->
						<li class="page-item">
							<a class="page-link" href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=<%=lastPage%>">&#62;&#62;</a>
						</li>
					</ul>
				</div>
				<!-- 페이지네이션 끝 -->
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
	
<!-- footer -->
<jsp:include page="/inc/footer.jsp"></jsp:include>
<!-- copy -->
<jsp:include page="/inc/copy.jsp"></jsp:include>
<!-- 자바스크립트 -->
<jsp:include page="/inc/script.jsp"></jsp:include>
<script>
	//결제상태, 배송상태 색 바꾸기
	const paymentStatus = document.querySelector("span #paymentStatus");
	const deliveryStatus = document.querySelector("span #deliveryStatus");
	if(paymentStatus === '결제대기'){
		paymentStatus.className = 'badge badge-warning';
	} else if (paymentStatus === '결제완료'){
		paymentStatu.className = 'badge badge-success';
	} else if (paymentStatus === '취소'){
		paymentStatus.className = 'badge badge-danger';
	} else {
		paymentStatus.className = 'badge badge-info';
	}
	
	if(deliveryStatus === '발송준비'){
		paymentStatus.className = 'badge badge-secondary';
	} else if (deliveryStatus === '발송완료'){
		paymentStatu.className = 'badge badge-primary';
	} else if (deliveryStatus === '배송중'){
		paymentStatus.className = 'badge badge-warning';
	} else if(deliveryStatus === '배송완료'){
		paymentStatus.className = 'badge badge-info';
	} else {
		paymentStatus.className = 'badge badge-success';
	}

</script>
</body>
</html>