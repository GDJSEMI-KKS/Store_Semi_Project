<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	OrdersDao oDao = new OrdersDao();
	ArrayList<Orders> list = oDao.SelectOrdersListByPage(0, 10);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/test.jsp" method="post">
		<input type = "radio" name = "createdate" value="onewWeek" selected>
		<input type = "radio" name = "createdate" value="oneMonth">
		<input type = "radio" name = "createdate" value="all">
		<input type = "radio" name = ""
	</form>
	<table>
		<tr></tr>
		<%
			for(Orders o : list){
		%>
				<tr>
					<td><%=o.getOrderNo()%></td>
					<td><%=o.getId()%></td>
					<td><%=o.getProductNo()%></td>
					<td><%=o.getPaymentStatus()%></td>
					<td><%=o.getDeliveryStatus()%></td>
					<td><%=o.getOrderCnt()%></td>
					<td><%=o.getOrderPrice()%></td>
					<td><%=o.getCreatedate()%></td>
					<td><%=o.getUpdatedate()%></td>
				</tr>
		<%
			}
		%>
		
	</table>
</body>
</html>