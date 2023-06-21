<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%	
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	// 아이디 레벨 검사 
	IdListDao iDao = new IdListDao();
	IdList idList = new IdList();
	int idLevel = idList.getIdLevel();
	System.out.println(SJ+idLevel + RE );
	
	// 현재페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	
	int productNo = 1;
	// sql 메서드들이 있는 클래스의 객체 생성
	ProductDao pDao = new ProductDao();
	DiscountDao dDao = new DiscountDao();
	
	// 전체 행의 수
	int totalRow = pDao.selectProductCnt();
	// 페이지 당 행의 수
	int rowPerPage = 10;
	// 시작 행 번호
	int beginRow = (currentPage-1) * rowPerPage;
	// 마지막 페이지 번호
	int lastPage = totalRow / rowPerPage;
	// 표시하지 못한 행이 있을 경우 페이지 + 1
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	
	
	// 현재 페이지에 표시 할 리스트
	ArrayList<HashMap<String, Object>> list = pDao.selectProductNoByPage(true, beginRow, rowPerPage);
	ArrayList<HashMap<String, Object>> dList = dDao.selectDiscount(beginRow, rowPerPage);
	ArrayList<HashMap<String, Object>> dayList = pDao.selectProduct(productNo);	
	
	// 다양한 상품 출력을 위한 리스트
	// 판매량 순
	ArrayList<HashMap<String, Object>> cntList = pDao.selectSumCntByPage(true, beginRow, rowPerPage);
	// pop
	ArrayList<HashMap<String, Object>> popList = pDao.selectPopByPage(true, beginRow, rowPerPage);
	// kpop
	ArrayList<HashMap<String, Object>> kpopList = pDao.selectKpopByPage(true, beginRow, rowPerPage);
	// classic
	ArrayList<HashMap<String, Object>> classicList = pDao.selectClassicByPage(true, beginRow, rowPerPage);
	
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
<div>
	<h1>고객 : 상품 리스트</h1>
	<form action="<%=request.getContextPath()%>/product/searchProduct.jsp" method="post">
		<input type="text" name = "search">
		<button type="submit" >검색</button>
	</form>
	<h1>판매량순 전체 리스트</h1>
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
				for(HashMap<String, Object> p : cntList) {
					// 할인 기간 확인을 위한 변수와 분기
			%>
					<tr>
						<td>
							<a href="<%=request.getContextPath()%>/product/productDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>">
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
						<td>
							<div>상품 이미지  
								<img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" id="preview" width="300px">
								<input type="hidden" name = "beforeProductImg" value="<%=productSaveFilename%>">
								<input type="hidden" name = "productImg" onchange="previewImage(event)">
								<input type = "hidden" name = "productSaveFilename" value="<%=productSaveFilename%>">
							</div> 
						</td>
					</tr>
			<%		
				}
			%>
			
		</table>
		<h1>pop 리스트</h1>
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
				for(HashMap<String, Object> p : popList) {
					// 할인 기간 확인을 위한 변수와 분기
			%>
					<tr>
						<td>
							<a href="<%=request.getContextPath()%>/product/productDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>">
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
		<h1>kpop 리스트</h1>
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
				for(HashMap<String, Object> p : kpopList) {
					// 할인 기간 확인을 위한 변수와 분기
			%>
					<tr>
						<td>
							<a href="<%=request.getContextPath()%>/product/productDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>">
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
		<h1>classic 리스트</h1>
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
				for(HashMap<String, Object> p : classicList) {
					// 할인 기간 확인을 위한 변수와 분기
			%>
					<tr>
						<td>
							<a href="<%=request.getContextPath()%>/product/productDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>">
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
	<%
		// 페이징 수
		int pagePerPage = 10;
		// 최소 페이지
		int minPage = (currentPage-1) / pagePerPage * pagePerPage + 1;
		// 최대 페이지
		int maxPage = minPage + pagePerPage - 1;
		// 최대 페이지가 마지막 페이지 보다 크면 최대 페이지 = 마지막 페이지
		if(maxPage > lastPage) {
			maxPage = lastPage;
		}
		// 이전 페이지
		// 최소 페이지가 1보타 클 경우 이전 페이지 표시
		if(minPage>1) {
	%>
			<a href="<%=request.getContextPath()%>/productHome.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>
	<%			
		}
		// 최소 페이지부터 최대 페이지까지 표시
		for(int i = minPage; i<=maxPage; i=i+1) {
			if(i == currentPage) {	// 현재페이지는 링크 비활성화
	%>	
			<%=i%>
	<%			
			}else {					// 현재페이지가 아닌 페이지는 링크 활성화
	%>	
				<a href="<%=request.getContextPath()%>/productHome.jsp?currentPage=<%=i%>"><%=i%></a>
	<%				
			}
		}
		// 다음 페이지
		// 최대 페이지가 마지막 페이지와 다를 경우 다음 페이지 표시
		if(maxPage != lastPage) {
	%>
			<a href="<%=request.getContextPath()%>/productHome.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
	<%	
		}
	%>
	</div>
</body>
</html>