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
	Object o = null;
	String loginId = "";
	Employees emp = null;
	if(session.getAttribute("loginId") != null){
		o = session.getAttribute("loginId");
		if(o instanceof String){
			loginId = (String)o;
		}
		//관리자여부 확인
		EmployeesDao eDao = new EmployeesDao();
		emp = eDao.selectEmployee(loginId);
	}
%>
	 <header class="header mb-5">
      <!--
      *** TOPBAR ***
      _________________________________________________________
      -->
      <div id="top">
        <div class="container">
          <div class="row">
            <div class="col-lg-12 text-center text-lg-right">
              <ul class="menu list-inline mb-0">
              	<%
              		if(session.getAttribute("loginId") == null){ //로그인이 안되어 있는 경우
              	%>
              			<li class="list-inline-item"><a href="<%=request.getContextPath()%>/id_list/login.jsp" data-toggle="modal" data-target="#login-modal">로그인</a></li>
                		<li class="list-inline-item"><a href="<%=request.getContextPath()%>/id_list/signUp.jsp">회원가입</a></li>
              	<%
              		} else if(emp != null){ //로그인이 되어있고, 관리자인 경우
              	%>
              			 <li class="list-inline-item"><a href="<%=request.getContextPath()%>/id_list/logoutAction.jsp">로그아웃</a></li>
              			 <li class="list-inline-item"><a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=loginId%>">마이페이지</a></li>
              			 <li class="list-inline-item"><a href="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?id=<%=loginId%>">관리페이지</a></li>
              			 <li class="list-inline-item"><a href="<%=request.getContextPath()%>/home.jsp?id=<%=loginId%>">고객페이지</a></li>
              	<% 
              		} else { //로그인 되어있고, 관리자가 아닌 경우
              	%>
              			 <li class="list-inline-item"><a href="<%=request.getContextPath()%>/id_list/logoutAction.jsp">로그아웃</a></li>
              			 <li class="list-inline-item"><a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=loginId%>">마이페이지</a></li>
              	<%
              		}
              	%>
	                <li class="list-inline-item"><a href="<%=request.getContextPath()%>/board_question/boardQuestion.jsp">Q&A</a></li>
              	
              </ul>
            </div>
          </div>
        </div>
        <div id="login-modal" tabindex="-1" role="dialog" aria-labelledby="Login" aria-hidden="true" class="modal fade">
          <div class="modal-dialog modal-sm">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">로그인</h5>
                <button type="button" data-dismiss="modal" aria-label="Close" class="close"><span aria-hidden="true">×</span></button>
              </div>
              <div class="modal-body">
                <form action="<%=request.getContextPath()%>/id_list/loginAction.jsp" method="post">
                  <div class="form-group">
                    <input id="email-modal" type="text" name="id" placeholder="ID" class="form-control">
                  </div>
                  <div class="form-group">
                    <input id="password-modal" type="password" name="pw" placeholder="PASSWORD" class="form-control">
                  </div>
                  <p class="text-center">
                    <button class="btn btn-primary"><i class="fa fa-sign-in"></i>로그인</button>
                  </p>
                </form>
              </div>
            </div>
          </div>
        </div>
        <!-- *** TOP BAR END ***-->
        
        
      </div>
      <nav class="navbar navbar-expand-lg">
        <div class="container"><a href="<%=request.getContextPath()%>/home.jsp" class="navbar-brand home"><img src="img/logo.png" alt="Obaju logo" class="d-none d-md-inline-block"><img src="img/logo-small.png" alt="Obaju logo" class="d-inline-block d-md-none"><span class="sr-only">판다뮤직</span></a>
          <div class="navbar-buttons">
            <button type="button" data-toggle="collapse" data-target="#navigation" class="btn btn-outline-secondary navbar-toggler"><span class="sr-only">토글 nav</span><i class="fa fa-align-justify"></i></button>
            <button type="button" data-toggle="collapse" data-target="#search" class="btn btn-outline-secondary navbar-toggler"><span class="sr-only">토글 검색</span><i class="fa fa-search"></i></button><a href="basket.html" class="btn btn-outline-secondary navbar-toggler"><i class="fa fa-shopping-cart"></i></a>
          </div>
          <div id="navigation" class="collapse navbar-collapse">
            <ul class="navbar-nav mr-auto">
              <li class="nav-item"></li>
            </ul>
            <div class="navbar-buttons d-flex justify-content-end">
              <!-- /.nav-collapse-->
              <div id="search-not-mobile" class="navbar-collapse collapse"></div><a data-toggle="collapse" href="#search" class="btn navbar-btn btn-primary d-none d-lg-inline-block"><span class="sr-only">검색</span><i class="fa fa-search"></i></a>
              <div id="basket-overview" class="navbar-collapse collapse d-none d-lg-block"><a href="basket.html" class="btn btn-primary navbar-btn"><i class="fa fa-shopping-cart"></i><span>장바구니</span></a></div>
            </div>
          </div>
        </div>
      </nav>
      <div id="search" class="collapse">
        <div class="container">
          <form role="search" class="ml-auto" action="<%=request.getContextPath()%>/product/searchProduct.jsp" method="post">
            <div class="input-group">
              <input type="text" name = "search" placeholder="검색" class="form-control">
              <div class="input-group-append">
                <button type="submit" class="btn btn-primary"><i class="fa fa-search"></i></button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </header>