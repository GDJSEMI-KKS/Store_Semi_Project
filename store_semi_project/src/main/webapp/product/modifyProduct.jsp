<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	// 요청값 유효성 검사
	if(request.getParameter("p.productNo") == null  
		|| request.getParameter("p.productNo").equals("")) {
		
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	// 요청값 변수에 저장
	int productNo = Integer.parseInt(request.getParameter("p.productNo"));
	int beginRow = 1;
	int rowPerPage = 10;
	// sql 메서드들이 있는 클래스의 객체 생성
	ProductDao pDao = new ProductDao();
	DiscountDao dDao = new DiscountDao();
	
	ArrayList<HashMap<String, Object>> list = pDao.selectProduct(productNo);
	ArrayList<HashMap<String, Object>> dList = dDao.selectDiscount(beginRow, rowPerPage);
	Product product = new Product();
	ProductImg productImg = new ProductImg();
	Discount discount = new Discount();
	
	// product 정보 변수에 저장
	String productStatus = null;
	String categoryName = null;
	String productName = null;
	int productPrice = 0;
	int productStock = 0;
	double discountRate = 0.0;
	String productInfo = null;
	String productSaveFilename = null;
	String discountStart = null;
	String discountEnd = null;
	for(HashMap<String, Object> p : list) {
		productStatus = p.get("productStatus").toString();
		categoryName = p.get("categoryName").toString();
		productName = p.get("productName").toString();
		productPrice = Integer.parseInt(p.get("productPrice").toString());
		productStock = Integer.parseInt(p.get("productStock").toString());
		productInfo = p.get("productInfo").toString();
		productSaveFilename = p.get("productSaveFilename").toString();
	}
	// discount 정보 변수에 저장
	if(request.getParameter("discountRate") != null) {
		discountRate = Double.parseDouble(request.getParameter("discountRate").toString());
	} else {
		discountRate = 0.0;
	}
	if(request.getParameter("discountStart") != null) {
		discountStart = request.getParameter("discountStart").toString();
	} else {
		discountStart = null;
	}
	if(request.getParameter("discountEnd") != null) {
		discountEnd = request.getParameter("discountEnd").toString();
	} else {
		discountEnd = null;
	}
	String dir = request.getContextPath() + "/product/productImg/" + productSaveFilename;
	System.out.println(SJ+ dir + "<-dir" +RE);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<form action = "<%=request.getContextPath()%>/product/modifyProductAction.jsp" method="post" encType="multipart/form-data">
		<div> 상품 번호 <input type="number" readonly="readonly" name = "productNo" value = "<%=productNo%>"></div>
		<div> 상품 카테고리
			<input type="text" name = "categoryName" value = "<%=categoryName%>">
		</div>
		
		<div>상품명 
			<input type="text" name = "productName" value = "<%=productName%>">
		</div>
		
		<div>상품 설명 
			<textarea rows="3" cols="100" name = "productInfo"><%=productInfo%></textarea>
		</div>
		
		<div>상품 가격 
			<input type="number" name = "productPrice" value="<%=productPrice%>">
		</div>
		<div>상품 상태
			<select name="productStatus">
				<option <%if(productStatus.equals("판매중")){ %> selected <% } %>>판매중</option>
				<option <%if(productStatus.equals("품절")){ %> selected <% } %>>품절</option>
				<option <%if(productStatus.equals("예약판매")){ %> selected <% } %>>예약판매</option>
			</select>
		</div>
		
		<div>재고량 
			<input type="number" name = "productStock" value="<%=productStock%>">
		</div> 
		<div>할인율
			<input type="text" name = "discountRate" value="<%=discountRate%>">
		</div>
		<div>할인 시작 
			<input type="date" name = "discountStart" value="<%=discountStart%>">
		</div>
		<div>할인 종료
			<input type="date" name = "discountEnd" value="<%=discountEnd%>">
		</div>
		<div>상품 이미지  
			<img src="<%=dir%>" id="preview" width="300px">
			<input type="hidden" name = "beforeProductImg" value="<%=productSaveFilename%>">
			<input type="file" name = "productImg" onchange="previewImage(event)">
		</div> 
		
		<div>
			<button type="submit">수정</button>
			<button type="submit" formaction="<%=request.getContextPath()%>/product/productList.jsp">이전</button>
		</div>
	</form>
</body>
</html>