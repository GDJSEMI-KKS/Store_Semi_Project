<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="card sidebar-menu">
<div class="card-header">
  <h3 class="h4 card-title">고객 메뉴</h3>
</div>
<div class="card-body">
  <ul class="nav nav-pills flex-column">
   <a href="<%=request.getContextPath()%>/customer/customerOne.jsp" class="nav-link "><i class="fa fa-list"></i>프로필</a>
   <a href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?currentPage=1" class="nav-link"><i class="fa fa-user"></i>주문목록</a>
   <a href="<%=request.getContextPath()%>/id_list/logoutAction.jsp" class="nav-link"><i class="fa fa-sign-out"></i>로그아웃</a></ul>
  </div>
</div>