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
						discountRate = Double.parseDouble(p.get("discountRate").toString());
						if(p.get("discountRate") == null) {
							
					%>		<%=0.0%>
					<%	} else {
							if(p.get("productNo") == p.get("dProductNo")) {
								 
									
					%>
								<%=Double.parseDouble(p.get("discountRate").toString())*100%> %
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
								<%=Double.parseDouble(p.get("productPrice").toString())*(1-Double.parseDouble(p.get("discountRate").toString()))%>
					<%
							}
						}
		
					%> 
				</td>
			</tr>
			<tr>
				<th >할인 시작</th>
				<td><%=p.get("discountStart")%></td>
			</tr>
			<tr>
				<th >할인 종료</th>
				<td><%=p.get("discountEnd")%></td>
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
				<td>
					<div >
						<button type="submit">수정</button>
						<input type = "hidden" name = "p.productNo" value = "<%=p.get("p.productNo")%>">
						<input type = "hidden" name = "dproductNo" value = "<%=p.get("dproductNo")%>">
						<input type = "hidden" name = "discountRate" value = "<%=p.get("discountRate")%>">
						<input type = "hidden" name = "discountStart" value = "<%=p.get("discountStart")%>">
						<input type = "hidden" name = "discountEnd" value = "<%=p.get("discountEnd")%>">
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
		<div>상품 이미지  
			<img src="<%=dir%>" id="preview" width="300px">
			<input type="hidden" name = "beforeProductImg" value="<%=productSaveFilename%>">
			<input type="hidden" name = "productImg" onchange="previewImage(event)">
			<input type = "hidden" name = "productSaveFilename" value="<%=productSaveFilename%>">
			<input type = "hidden" name = "discountRate" value="<%=discountRate%>">
		</div> 
		</form>
	</div>
</body>
</html>