<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="card sidebar-menu">
<div class="card-header">
  <h3 class="h4 card-title">관리자 메뉴</h3>
</div>
<div class="card-body">
  <ul class="nav nav-pills flex-column">
	 <a href="<%=request.getContextPath()%>/category/adminCategoryList.jsp" class="nav-link "><i class="fa fa-list"></i>카테고리관리</a>
	 <a href="<%=request.getContextPath()%>/product/productList.jsp" class="nav-link "><i class="fa fa-list"></i>상품관리</a>
	 <a href="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=1" class="nav-link "><i class="fa fa-list"></i>회원관리</a>
	 <a href="<%=request.getContextPath()%>/admin_orders/adminOrders.jsp?" class="nav-link "><i class="fa fa-list"></i>주문관리</a>
	 <a href="<%=request.getContextPath()%>/admin_question/adminQnAList.jsp?" class="nav-link "><i class="fa fa-list"></i>문의관리</a>
	 <a href="<%=request.getContextPath()%>/admin_review_adminReview.jsp?" class="nav-link "><i class="fa fa-list"></i>리뷰관리</a>
  </div>
</div>