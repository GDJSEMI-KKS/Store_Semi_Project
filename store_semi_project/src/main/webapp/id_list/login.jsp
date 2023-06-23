<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* session 유효성 검사
	* session의 값이 null이 아니면 home.jsp 페이지로 리턴
	*/
	if(session.getAttribute("loginId") != null){
		response.sendRedirect(request.getContextPath()+"home.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>login</title>
<jsp:include page="/inc/link.jsp"></jsp:include>
</head>
<body>
	<!-- navbar-->
    <jsp:include page="/inc/menu.jsp"></jsp:include>
    
	<div id="all">
		<div id="content">
			<div class="container">
					<div class="row">
						<div class="col-lg-12">
							<!-- breadcrumb-->
							<nav aria-label="breadcrumb">
								<ol class="breadcrumb">
									<li class="breadcrumb-item"><a href="#">홈</a></li>
									<li aria-current="page" class="breadcrumb-item active">로그인</li>
								</ol>
							</nav>
						</div>
						<!-- Sign in form -->
						<div class="col-lg-6">
							<div class="box">
								<h1>로그인</h1>
								<hr>
								<form method="post" id="loginForm">
									<div class="form-group">
										<label for="id">아이디</label>
										<input id="id" name="id" type="text" class="form-control">
									</div>
									<div class="form-group">
										<label for="password">비밀번호</label>
										<input id="password" name="pw" type="password" class="form-control">
									</div>
									<div class="text-center">
										<button type="button" id="loginBtn" class="btn btn-primary"><i class="fa fa-sign-in"></i>로그인</button>
									</div>
								</form>
							</div>
						</div>
						<!-- img -->
						<div class="col-lg-6">
						<div class="box">
						          
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
      
    <!-- FOOTER -->
	<jsp:include page="/inc/footer.jsp"></jsp:include>   
    <!-- COPYRIGHT -->
    <jsp:include page="/inc/copy.jsp"></jsp:include>
    <!-- JavaScript files-->
    <jsp:include page="/inc/script.jsp"></jsp:include>
</body>
<script>
	$('#loginBtn').on('click', function(){
		
		// id, password 값 저장
		let id = $('#id').val();
		let password = $('#password').val();
		
		// 입력값이 비어있는지 확인
		if(id.trim() == ''){
			alert('아이디를 입력해주세요');
			 $('#id').focus();
			return;
		} else if(password.trim() == ''){
			alert('비밀번호를 입력해주세요');
			$('#password').focus();
			return;
		}
		// 입력값이 있을 경우, loginAction.jsp로 이동
		let loginActionFormUrl = '<%=request.getContextPath()%>/id_list/loginAction.jsp';
		$('#loginForm').attr('action', loginActionFormUrl);
	    $('#loginForm').submit();
	});
</script>
</html>