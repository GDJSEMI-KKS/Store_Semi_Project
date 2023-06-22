<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%	
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	System.out.println(SJ+ request.getParameter("category") + "<-radio category" +RE);
	// 아이디 레벨 검사 
	IdListDao iDao = new IdListDao();
	IdList idList = new IdList();
	int idLevel = idList.getIdLevel();
	System.out.println(SJ+idLevel + RE );
	
	if(request.getParameter("category") == null  
			|| request.getParameter("category").equals("")) {
			// subjectList.jsp으로
			response.sendRedirect(request.getContextPath() + "/product/productHome.jsp");
			return;
		}
	
	int productNo = 1;
	// sql 메서드들이 있는 클래스의 객체 생성
	ProductDao pDao = new ProductDao();
	DiscountDao dDao = new DiscountDao();
	
	int beginRow=0;
	int rowPerPage = 10;
	// 현재 페이지에 표시 할 리스트
	ArrayList<HashMap<String, Object>> list = pDao.selectProductNoByPage(true, beginRow, rowPerPage);
	ArrayList<HashMap<String, Object>> dList = dDao.selectDiscount(beginRow, rowPerPage);
	ArrayList<HashMap<String, Object>> dayList = pDao.selectProduct(productNo);	
	
	// 다양한 상품 출력을 위한 리스트
	// 카테고리 분류 변수 및 분기
	String category = request.getParameter("category");
	ArrayList<HashMap<String, Object>> clist = null;
	// 판매량 순
	ArrayList<HashMap<String, Object>> cntList = pDao.selectSumCntByPage(true, beginRow, rowPerPage);
	// pop
	ArrayList<HashMap<String, Object>> popList = pDao.selectPopByPage(true, beginRow, rowPerPage);
	// kpop
	ArrayList<HashMap<String, Object>> kpopList = pDao.selectKpopByPage(true, beginRow, rowPerPage);
	// classic
	ArrayList<HashMap<String, Object>> classicList = pDao.selectClassicByPage(true, beginRow, rowPerPage);
	if(category.equals("pop")) {
		clist = pDao.selectPopByPage(true, beginRow, rowPerPage);
	} else if(category.equals("kpop")){
		clist = pDao.selectKpopByPage(true, beginRow, rowPerPage);
	} else {
		clist = pDao.selectClassicByPage(true, beginRow, rowPerPage);
	}
	
	
	// 상품이미지 코드
	String productSaveFilename = null;
	String dir = request.getContextPath() + "/product/productImg/" + productSaveFilename;
	System.out.println(SJ+ dir + "<-dir" +RE);
	System.out.println(SJ+productSaveFilename + RE );
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객 상품리스트</title>
</head>
<body>

	<h1>고객 : 상품 리스트</h1>
	<form action="<%=request.getContextPath()%>/product/searchProduct.jsp" method="post">
		<input type="text" name = "search">
		<button type="submit" >검색</button>
	</form>
	<form action="<%=request.getContextPath()%>/product/categoryProduct.jsp" method="post">
		<input type="radio" name ="category"  value="pop">pop
		<input type="radio" name ="category"  value="kpop">k-pop
		<input type="radio" name ="category"  value="classic">classic
		<button type="submit" >카테고리 선택</button>
	</form>
	
		<h1><%=category %> 리스트</h1>
		<table >
			<tr>
				<th >p no.</th>
				<th >카테고리</th>
				<th >이름</th>
				<th >가격</th>
				<th >상태</th>
				<th >재고</th>
				<th >등록일</th>
				<th >수정일</th>
			</tr>
			<%
				for(HashMap<String, Object> p : clist) {
					// 할인 기간 확인을 위한 변수와 분기
			%>
					<tr>
						<td>
							<a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>">
								<%=p.get("p.productNo")%>
							</a>
						</td>
						<td><%=p.get("categoryName")%></td>
						<td><%=p.get("productName")%></td>
						<td><%=p.get("productPrice")%></td>
						<td><%=p.get("productStatus")%></td>
						<td><%=p.get("productStock")%></td>
						<td><%=p.get("p.createdate")%></td>
						<td><%=p.get("p.updatedate")%></td>
					</tr>
			<%		
				}
			%>
			
		</table>

</body>
</html>