<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CategoryDao"%>
<%@ page import="vo.Category"%>
<%@ page import="java.util.*"%>
<%
	CategoryDao categoryDao = new CategoryDao();
	ArrayList<Category> list = categoryDao.selectCategoryList();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>adminCategory</title>
</head>
<body>
	<div>
		<table>
			<tr>
				<th>카테고리</th>
			</tr>
			<%
				for(Category c : list){
			%>
				<tr>
					<td><%=c.getCategoryName()%></td>
				</tr>			
			<%		
				}
			%>
		</table>
	</div>
</body>
</html>