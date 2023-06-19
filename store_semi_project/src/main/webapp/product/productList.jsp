<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%	
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	// 현재페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	int discountNo = 1;
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
	// 할인 적용을 위한 오늘 날짜 계산
	Calendar today = Calendar.getInstance();
	int todayYear = today.get(Calendar.YEAR);
	int todayMonth = today.get(Calendar.MONTH);
	int todayDate = today.get(Calendar.DATE);
	// 할인 날짜 적용을 위한 변수 선언
	// 할인율 적용을 위한 변수 선언
	double dRate = 1.0;

	// 할인율, 날짜 적용을 위한 ArrayList 값 가져오기
	// 수정 필요 분기 필요 
	
	int dStartYear = 0;
	int dStartMonth = 0;
	int dStartDay =0;
	int dEndYear = 0;
	int	dEndMonth = 0;
	int	dEndDay = 0;
	String productSaveFilename = null;
	for(HashMap<String, Object> p : dList) {
		if(p.get("discount_no") != null) {
		dStartYear = Integer.parseInt((p.get("discountStart").toString()).substring(0, 4));
		dStartMonth = Integer.parseInt((p.get("discountStart").toString()).substring(5, 7));
		dStartDay = Integer.parseInt((p.get("discountStart").toString()).substring(8, 10));
		dEndYear = Integer.parseInt((p.get("discountEnd").toString()).substring(0, 4));
		dEndMonth = Integer.parseInt((p.get("discountEnd").toString()).substring(5, 7));
		dEndDay = Integer.parseInt((p.get("discountEnd").toString()).substring(8, 10));
		}
	}
	
	System.out.println(SJ+productSaveFilename + RE );
	System.out.print(SJ+todayYear );
	System.out.print(todayMonth+1);
	System.out.println(todayDate + "<-- productList.jsp 오늘날짜 확인" + RE );
	
	System.out.println(SJ+ dEndYear + RE );
	System.out.println(SJ+ dEndMonth + RE );
	System.out.println(SJ+ dEndDay + RE );
	if((dStartYear >= todayYear && dStartMonth >= todayMonth&& dStartDay >= todayDate)
			|| dEndYear >= todayYear && dEndMonth >= todayMonth&& dEndDay >= todayDate) 
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 상품리스트</title>
</head>
<body>
<div>
	<h1>관리페이지 : 상품 리스트</h1>
	<div>
		<a href="<%=request.getContextPath()%>/product/addProduct.jsp">
			<button type="button" >추가</button>
		</a>
	</div>
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
				for(HashMap<String, Object> p : dList) {
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
							<div >
								<a href="<%=request.getContextPath()%>/product/removeProductAction.jsp?p.productNo=<%=p.get("p.productNo")%>">
									<button type="button">삭제</button>
								</a>
							</div>
						</td>
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
			<a href="<%=request.getContextPath()%>/productList.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>
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
				<a href="<%=request.getContextPath()%>/productList.jsp?currentPage=<%=i%>"><%=i%></a>
	<%				
			}
		}
		// 다음 페이지
		// 최대 페이지가 마지막 페이지와 다를 경우 다음 페이지 표시
		if(maxPage != lastPage) {
	%>
			<a href="<%=request.getContextPath()%>/productList.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
	<%	
		}
	%>
	</div>
</body>
</html>