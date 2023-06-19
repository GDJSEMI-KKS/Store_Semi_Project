<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	String productSaveFilename = null;
	
	// 요청값 유효성 검사
	if(request.getParameter("p.productNo") == null  
		|| request.getParameter("p.productNo").equals("")) {
		// subjectList.jsp으로
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	// 요청값 변수에 저장
	int productNo = Integer.parseInt(request.getParameter("p.productNo"));
	
	String productStatus = request.getParameter("productStatus");
	// sql 메서드들이 있는 클래스의 객체 생성
	ProductDao pDao = new ProductDao();
	DiscountDao dDao = new DiscountDao();
	QuestionDao qDao = new QuestionDao();
	Product product = new Product();
	
	product.setProductNo(productNo);
	System.out.println(SJ+ productNo + "<-- productDetail productNo" + RE );
	// 상세 페이지에 표시할 subject 객체
	ArrayList<HashMap<String, Object>> list = pDao.selectProduct(productNo);
	double discountRate = 0.0;
	for(HashMap<String, Object> p : list) {
		if(p.get("p.productNo") == p.get("dproductNo")){
			productSaveFilename = p.get("productSaveFilename").toString();
		}
	}
	String dir = request.getContextPath() + "/product/productImg/" + productSaveFilename;
	System.out.println(SJ+ dir + "<-dir" +RE);
	ArrayList<HashMap<String, Object>> dList = dDao.selectDiscountProduct(productNo);
	// 할인 적용을 위한 오늘 날짜 계산
	Calendar today = Calendar.getInstance();
	int todayYear = today.get(Calendar.YEAR);
	int todayMonth = today.get(Calendar.MONTH);
	int todayDate = today.get(Calendar.DATE);
	// 할인율, 날짜 적용을 위한 ArrayList 값 가져오기
	// 수정 필요 분기 필요 
	
	int dStartYear = 0;
	int dStartMonth = 0;
	int dStartDay =0;
	int dEndYear = 0;
	int	dEndMonth = 0;
	int	dEndDay = 0;
	
	for(HashMap<String, Object> d : dList) {
		if(d.get("dProductNo") != null) {
			dStartYear = Integer.parseInt((d.get("discountStart").toString()).substring(0, 4));
			dStartMonth = Integer.parseInt((d.get("discountStart").toString()).substring(5, 7));
			dStartDay = Integer.parseInt((d.get("discountStart").toString()).substring(8, 10));
			dEndYear = Integer.parseInt((d.get("discountEnd").toString()).substring(0, 4));
			dEndMonth = Integer.parseInt((d.get("discountEnd").toString()).substring(5, 7));
			dEndDay = Integer.parseInt((d.get("discountEnd").toString()).substring(8, 10));
			discountRate = Double.parseDouble(d.get("discountRate").toString());
			
			if((dStartYear >= todayYear && dStartMonth >= todayMonth && dStartDay >= todayDate)
					|| (dEndYear >= todayYear && dEndMonth >= todayMonth && dEndDay >= todayDate)) {
				dStartYear = Integer.parseInt((d.get("discountStart").toString()).substring(0, 4));
				dStartMonth = Integer.parseInt((d.get("discountStart").toString()).substring(5, 7));
				dStartDay = Integer.parseInt((d.get("discountStart").toString()).substring(8, 10));
				dEndYear = Integer.parseInt((d.get("discountEnd").toString()).substring(0, 4));
				dEndMonth = Integer.parseInt((d.get("discountEnd").toString()).substring(5, 7));
				dEndDay = Integer.parseInt((d.get("discountEnd").toString()).substring(8, 10));
				discountRate = Double.parseDouble(d.get("discountRate").toString());
				
			} else { 
				dStartYear = 0;
				dStartMonth = 0;
				dStartDay = 0;
				dEndYear = 0;
				dEndMonth = 0;
				dEndDay = 0;
				discountRate = 0.0;
			}
		}
	}
	
	System.out.println(SJ+productSaveFilename + RE );
	System.out.print(SJ+todayYear );
	System.out.print(todayMonth+1);
	System.out.println(todayDate + "<-- productDetail.jsp 오늘날짜 확인" + RE );
	
	System.out.print(SJ+ dEndYear + RE );
	System.out.print(SJ+ dEndMonth + RE );
	System.out.println(SJ+ dEndDay + "<-- productDetail.jsp 할인 종료 날짜 확인" + RE );
	
	// 상품문의 페이징 변수
	int beginRow = 0;
	int rowPerPage = 10;
	// 상품문의 출력을 위한 리스트
	ArrayList<Question> pList = qDao.selectQuestionListByPage(product, beginRow, rowPerPage);
		
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div >
		<h1>관리자 페이지 : 상품 상세</h1>
		<div >
			<a href="<%=request.getContextPath()%>/product/productList.jsp">
				<button type="button">목록으로</button>
			</a>
		</div>
		<form action="<%=request.getContextPath()%>/product/modifyProduct.jsp?p.productNo=<%=productNo%>" method="post">
			<table >
			<%
				for(HashMap<String, Object> p : list) {
					// 할인 기간 확인을 위한 변수와 분기
					
			%>
			<tr>
				<th >p no.</th>
				<td><%=productNo%></td>
				
			</tr>
			<tr>
				<th >카테고리</th>
				<td><%=p.get("categoryName")%></td>
			</tr>
			<tr>
				<th >이름</th>
				<td><%=p.get("productName")%></td>
			</tr>
			<tr>
				<th >가격</th>
				<td><%=p.get("productPrice")%></td>
			</tr>
			<tr>
				<th >할인율</th>
				<td><!-- 할인율 유무에 따른 분기 -->
					<%	// 할일율
						if(p.get("discountRate") == null) {
							
					%>		<%=0.0%>
					<%	} else {
							if(p.get("productNo") == p.get("dProductNo")) {
								 
									
					%>
								<%=discountRate*100%> %
					<%			
							}
						}
					%>
				</td>
			</tr>
			<tr>
				<th >할인가</th>
				<td> 
					<%	//할인가
						if(p.get("discountRate") == null) {
							
					%>	
							<%=p.get("productPrice")%> 
					<%	} else {
							if(p.get("productNo") == p.get("dProductNo")) {
					%>		
								<%=Math.round(Double.parseDouble(p.get("productPrice").toString())*(1-discountRate))%>
					<%
							}
						}
		
					%> 
				</td>
			</tr>
			<tr>
				<th >할인 시작</th>
				<td><%=" " + dStartYear +"년 "+ dStartMonth +"월 "+ dStartDay + "일 " %></td>
			</tr>
			<tr>
				<th >할인 종료</th>
				<td><%=" " + dEndYear +"년 "+ dEndMonth+"월 "+ dEndDay+ "일 "%></td>
			</tr>
			<tr>
				<th >상태</th>
				<td><%=p.get("productStatus")%></td>
			</tr>
			<tr>
				<th >재고</th>
				<td><%=p.get("productStock")%></td>
			</tr>
			<tr>
				<th >정보</th>
				<td><%=p.get("productInfo")%></td>
			</tr>
			<tr>
				<th >등록일</th>
				<td><%=p.get("p.createdate")%></td>
			</tr>
			<tr>
				<th >수정일</th>
				<td><%=p.get("p.updatedate")%></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td>
					<div>상품 이미지  
						<img src="<%=dir%>" id="preview" width="300px">
						<input type="hidden" name = "beforeProductImg" value="<%=productSaveFilename%>">
						<input type="hidden" name = "productImg" onchange="previewImage(event)">
						<input type = "hidden" name = "productSaveFilename" value="<%=productSaveFilename%>">
						<input type = "hidden" name = "discountRate" value="<%=discountRate%>">
					</div> 
				</td>
			</tr>
	
			<tr>
				<td>
					<div >
						<button type="submit">수정</button>
						<input type = "hidden" name = "dproductNo" value = "<%=p.get("dproductNo")%>">
						<input type = "hidden" name = "discountRate" value = "<%=p.get("discountRate")%>">
						<input type = "hidden" name = "discountStart" value = "<%=p.get("discountStart")%>">
						<input type = "hidden" name = "discountEnd" value = "<%=p.get("discountEnd")%>">
					</div>
				</td>
			</tr>
			<%	
				}
			%>
			<tr>
				<td>
					<a href="<%=request.getContextPath()%>/product/addProductDiscount.jsp?p.productNo=<%=productNo%>">
						<button type="button">할인추가</button>
					</a>
					<a href="<%=request.getContextPath()%>/question/removeQuestionAction.jsp?p.productNo=<%=productNo%>">
						<button type="button">삭제</button>
					</a>
				</td>
			</tr>
		</table>
		</form>
	</div>
	<form action="<%=request.getContextPath()%>/question/modifyQuestion.jsp?p.productNo=<%=productNo%>" method="post">
		<table>
			<tr>
				<th >p no.</th>
				<th >q no.</th>
				<th >id</th>
				<th >문의 카테고리</th>
				<th >문의 제목</th>
				<th >문의 내용</th>
				<th >등록일</th>
				<th >수정일</th>
			</tr>
			<%
				for(Question q : pList) {
					// 할인 기간 확인을 위한 변수와 분기
					
			%>
			<tr>
				<td><%=productNo%></td>
				<td>
					<a href="<%=request.getContextPath()%>/question/questionDetail.jsp?p.productNo=<%=productNo%>">
						<%=q.getqNo()%>
					</a>
				</td>
				<td><%=q.getId()%></td>
				<td><%=q.getqCategory()%></td>
				<td><%=q.getqTitle()%></td>
				<td><%=q.getqContent()%></td>
				<td><%=q.getCreatedate()%></td>
				<td><%=q.getUpdatedate()%></td>
			</tr>
			<%	
				}
			%>
		</table>
	</form>
</body>
</html>