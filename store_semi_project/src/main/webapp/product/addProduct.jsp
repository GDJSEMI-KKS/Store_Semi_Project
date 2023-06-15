<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
final String RE = "\u001B[0m"; 
final String SJ = "\u001B[44m";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 상품 추가 페이지</title>
</head>
<body>
	<div >
		<a href="<%=request.getContextPath()%>/product/productList.jsp">
			<button type="button">목록으로</button>
		</a>
	</div>
	<div class="container">
	<h1>관리자 페이지 : 상품추가</h1>
	<form action = "<%=request.getContextPath()%>/product/addProductAction.jsp" method="post" encType="multipart/form-data">
		<table>
			
			<tr>
				<th>카테고리</th>
				<td><input type="text" name="categoryName"></td>
			</tr>
			<tr>
				<th>상품 이름</th>
				<td><input type="text" name="productName"></td>
			</tr>
			<tr>
				<th>상품 가격</th>
				<td><input type="number" name="productPrice"></td>
			</tr>
			<tr>
				<th>상품 상태</th>
				<td>
					<select name = "productStatus">
						<option value = "예약판매">예약판매</option>
						<option value = "판매중">판매중</option>
						<option value = "품절">품절</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>재고</th>
				<td><input type="number" name="productStock"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><input type="text" name="productInfo"></td>
			</tr>
			<tr>
				<th>상품이미지 업로드</th>
				<td>
					<input type="file" name="boardFile" required="required">
				</td>
			</tr>
		</table>
		<button type="submit">추가</button>
	</form>
	</div>
</body>
</html>