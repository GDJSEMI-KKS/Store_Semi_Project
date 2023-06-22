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
	int startNum = 0;
	ArrayList<HashMap<String, Object>> cntList = pDao.selectSumCntByPage(true, beginRow, rowPerPage);
	ArrayList<HashMap<String, Object>> cntList1 = pDao.selectSumCntByPage(true, startNum, 1);
	
	
	
	// 상품이미지 코드
	String productSaveFilename = null;
	String dir = request.getContextPath() + "/product/productImg/" + productSaveFilename;
	System.out.println(SJ+ dir + "<-dir" +RE);
	System.out.println(SJ+productSaveFilename + RE );
%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Home</title>
    <jsp:include page="/inc/link.jsp"></jsp:include>
  </head>
  <body>
    <!-- navbar-->
    <jsp:include page="/inc/menu.jsp"></jsp:include>
    
    
    <!-- main -->
    <div id="all">
      <div id="content">
        <div class="container">
          <div class="row">
            <div class="col-md-12">
              <div id="main-slider" class="owl-carousel owl-theme">음반 타이틀 이미지 넣기
                <div class="item"><img src="img/main-slider1.jpg" alt="" class="img-fluid"></div>
                <div class="item"><img src="img/main-slider2.jpg" alt="" class="img-fluid"></div>
                <div class="item"><img src="img/main-slider3.jpg" alt="" class="img-fluid"></div>
                <div class="item"><img src="img/main-slider4.jpg" alt="" class="img-fluid"></div>
              </div>
              <!-- /#main-slider-->
            </div>
          </div>
        </div>
        <!--
        *** ADVANTAGES HOMEPAGE ***
        _________________________________________________________
        -->
        <div id="advantages">
          <div class="container">
            <div class="row mb-4">
              <div class="col-md-4">
                <div class="box clickable d-flex flex-column justify-content-center mb-0 h-100">
                  <div class="icon"><i class="fa fa-heart"></i></div>
                  <form action="<%=request.getContextPath()%>/product/categoryProduct.jsp" method="post">
                  <h3><a href="<%=request.getContextPath()%>/product/categoryProduct.jsp?category=pop">POP</a></h3>
                  <p class="mb-0">We are known to provide best possible service ever</p>
                  </form>
                </div>
                <h3><a href="#"></a></h3>
              </div>
              <div class="col-md-4">
                <div class="box clickable d-flex flex-column justify-content-center mb-0 h-100">
                  <div class="icon"><i class="fa fa-tags"></i></div>
                  <form action="<%=request.getContextPath()%>/product/categoryProduct.jsp" method="post">
                  <h3><a href="<%=request.getContextPath()%>/product/categoryProduct.jsp?category=kpop">K-POP</a></h3>
                  <p class="mb-0">We are known to provide best possible service ever</p>
                  </form></div>
                <h3><a href="#"></a></h3>
              </div>
              <div class="col-md-4">
                <div class="box clickable d-flex flex-column justify-content-center mb-0 h-100">
                  <div class="icon"><i class="fa fa-thumbs-up"></i></div>
                  <form action="<%=request.getContextPath()%>/product/categoryProduct.jsp" method="post">
                  <h3><a href="<%=request.getContextPath()%>/product/categoryProduct.jsp?category=classic">CLASSIC</a></h3>
                  <p class="mb-0">We are known to provide best possible service ever</p>
                  </form></div>
                <h3><a href="#"></a></h3>
              </div>
            </div>
            <!-- /.row-->
          </div>
          <!-- /.container-->
        </div>
        <!-- /#advantages-->
        <!-- *** ADVANTAGES END ***-->
        <!--
        *** HOT PRODUCT SLIDESHOW ***
        _________________________________________________________
        -->
        
        <div id="hot">
          <div class="box py-4">
            <div class="container">
              <div class="row">
                <div class="col-md-12">
                  <h2 class="mb-0">Hot this week</h2>
                </div>
              </div>
            </div>
          </div>
          
          <div class="container">
            <div class="product-slider owl-carousel owl-theme">
            <%ArrayList<HashMap<String, Object>> cntList2 = pDao.selectSumCntByPage(true, ++startNum, 1);
                for(HashMap<String, Object> p : cntList1) {
			%>
              <div class="item">
                <div class="product">
                  <div class="flip-container">
                    <div class="flipper">
                      <div class="front"><a href="detail.html"><img src="img/product1.jpg" alt="" class="img-fluid"></a></div>
                      <div class="back"><a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>"><img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" id="preview" height  = "200px" width="300px" alt="" class="img-fluid">
                      <img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" id="preview" height  = "50px" width="300px">
                      <input type="hidden" name = "beforeProductImg" value="<%=productSaveFilename%>">
					  <input type="hidden" name = "productImg" onchange="previewImage(event)">
					  <input type = "hidden" name = "productSaveFilename" value="<%=productSaveFilename%>">
                      </a></div>
                    </div>
                  </div><a href="detail.html" class="invisible"><img src="img/product1.jpg" alt="" class="img-fluid"></a>
                  
                  <div class="text">
                    <h3><a href="detail.html">
                    </a></h3>
                    <br></br>
					<br></br>
					
                    <p class="price"> 
                      <del></del>
                    </p>
                  </div>
                  <div >
                  <h3><%=p.get("categoryName")%></h3>
                  <h2><%=p.get("productName")%></h2>
				  <h4><%=p.get("productPrice")%>원</h4>
        		  </div>
                  <!-- /.text-->
                 
                </div>
                <!-- /.product-->
              </div>
              <%		
              
				}
				%>
               <%ArrayList<HashMap<String, Object>> cntList3 = pDao.selectSumCntByPage(true, ++startNum, 1);
                for(HashMap<String, Object> p : cntList2) {
                	
			%>
              <div class="item">
                <div class="product">
                  <div class="flip-container">
                    <div class="flipper">
                      <div class="front"><a href="detail.html"><img src="img/product1.jpg" alt="" class="img-fluid"></a></div>
                      <div class="back"><a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>"><img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" id="preview" height  = "200px" width="300px" alt="" class="img-fluid">
                      <img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" id="preview" height  = "50px" width="300px">
                      <input type="hidden" name = "beforeProductImg" value="<%=productSaveFilename%>">
					  <input type="hidden" name = "productImg" onchange="previewImage(event)">
					  <input type = "hidden" name = "productSaveFilename" value="<%=productSaveFilename%>">
                      </a></div>
                    </div>
                  </div><a href="detail.html" class="invisible"><img src="img/product1.jpg" alt="" class="img-fluid"></a>
                  
                  <div class="text">
                    <h3><a href="detail.html">
                    </a></h3>
                    <br></br>
					<br></br>
					
                    <p class="price"> 
                      <del></del>
                    </p>
                  </div>
                  <div >
                  <h3><%=p.get("categoryName")%></h3>
                  <h2><%=p.get("productName")%></h2>
				  <h4><%=p.get("productPrice")%>원</h4>
        		  </div>
                  <!-- /.text-->
                  
                  <!-- /.ribbon-->
                </div>
                <!-- /.product-->
              </div>
              <%		
				}
			  %>
               
                <%ArrayList<HashMap<String, Object>> cntList4 = pDao.selectSumCntByPage(true, ++startNum, 1);
                for(HashMap<String, Object> p : cntList3) {
			%>
              <div class="item">
                <div class="product">
                  <div class="flip-container">
                    <div class="flipper">
                      <div class="front"><a href="detail.html"><img src="img/product1.jpg" alt="" class="img-fluid"></a></div>
                      <div class="back"><a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>"><img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" id="preview" height  = "200px" width="300px" alt="" class="img-fluid">
                      <img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" id="preview" height  = "50px" width="300px">
                      <input type="hidden" name = "beforeProductImg" value="<%=productSaveFilename%>">
					  <input type="hidden" name = "productImg" onchange="previewImage(event)">
					  <input type = "hidden" name = "productSaveFilename" value="<%=productSaveFilename%>">
                      </a></div>
                    </div>
                  </div><a href="detail.html" class="invisible"><img src="img/product1.jpg" alt="" class="img-fluid"></a>
                  
                  <div class="text">
                    <h3><a href="detail.html">
                    </a></h3>
                    <br></br>
					<br></br>
					
                    <p class="price"> 
                      <del></del>
                    </p>
                  </div>
                  <div >
                  <h3><%=p.get("categoryName")%></h3>
                  <h2><%=p.get("productName")%></h2>
				  <h4><%=p.get("productPrice")%>원</h4>
        		  </div>
                  <!-- /.text-->
                 
                  <!-- /.ribbon-->
                </div>
                <!-- /.product-->
              </div>
              <%		
				}
			  %>
                <%
                for(HashMap<String, Object> p : cntList4) {
                	beginRow +=1;
			%>
              <div class="item">
                <div class="product">
                  <div class="flip-container">
                    <div class="flipper">
                      <div class="front"><a href="detail.html"><img src="img/product1.jpg" alt="" class="img-fluid"></a></div>
                      <div class="back"><a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>"><img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" id="preview" height  = "200px" width="300px" alt="" class="img-fluid">
                      <img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" id="preview" height  = "50px" width="300px">
                      <input type="hidden" name = "beforeProductImg" value="<%=productSaveFilename%>">
					  <input type="hidden" name = "productImg" onchange="previewImage(event)">
					  <input type = "hidden" name = "productSaveFilename" value="<%=productSaveFilename%>">
                      </a></div>
                    </div>
                  </div><a href="detail.html" class="invisible"><img src="img/product1.jpg" alt="" class="img-fluid"></a>
                  
                  <div class="text">
                    <h3><a href="detail.html">
                    </a></h3>
                    <br></br>
					<br></br>
					
                    <p class="price"> 
                      <del></del>
                    </p>
                  </div>
                  <div >
                  <h3><%=p.get("categoryName")%></h3>
                  <h2><%=p.get("productName")%></h2>
				  <h4><%=p.get("productPrice")%>원</h4>
        		  </div>
                  <!-- /.text-->
                
                  <!-- /.ribbon-->
                </div>
                <!-- /.product-->
              </div>
              <%		
				}
			  %>
                <%ArrayList<HashMap<String, Object>> cntList5 = pDao.selectSumCntByPage(true, ++startNum, 1);
                for(HashMap<String, Object> p : cntList5) {
                	startNum +=1;
			%>
              <div class="item">
                <div class="product">
                  <div class="flip-container">
                    <div class="flipper">
                      <div class="front"><a href="detail.html"><img src="img/product1.jpg" alt="" class="img-fluid"></a></div>
                      <div class="back"><a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>"><img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" id="preview" height  = "200px" width="300px" alt="" class="img-fluid">
                      <img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" id="preview" height  = "10px" width="300px">
                      <input type="hidden" name = "beforeProductImg" value="<%=productSaveFilename%>">
					  <input type="hidden" name = "productImg" onchange="previewImage(event)">
					  <input type = "hidden" name = "productSaveFilename" value="<%=productSaveFilename%>">
                      </a></div>
                    </div>
                  </div><a href="detail.html" class="invisible"><img src="img/product1.jpg" alt="" class="img-fluid"></a>
                  
                  <div class="text">
                    <h3><a href="detail.html">
                    </a></h3>
                    <br></br>
					<br></br>
					
                    <p class="price"> 
                      <del></del>
                    </p>
                  </div>
                  <div >
                  <h3><%=p.get("categoryName")%></h3>
                  <h2><%=p.get("productName")%></h2>
				  <h4><%=p.get("productPrice")%>원</h4>
        		  </div>
                  <!-- /.text-->
                  
                  <!-- /.ribbon-->
                </div>
                <!-- /.product-->
              </div>
              <%		
				}
			  %>
              </div>
              <!-- /.product-slider-->
            </div>
            <!-- /.container-->
          </div>
          <!-- /#hot-->
          <!-- *** HOT END ***-->
        </div>
        <!--
        *** GET INSPIRED ***
        _________________________________________________________
        -->
        <div class="container">
          <div class="col-md-12">
            <div class="box slideshow">
              <h3>음반 목록</h3>
              <p class="lead">Get the inspiration from our world class designers</p>
              <div id="get-inspired" class="owl-carousel owl-theme">
                <div class="item"><a href="<%=request.getContextPath()%>/product/productHome.jsp"><img src="img/getinspired1.jpg" alt="Get inspired" class="img-fluid"></a></div>
              </div>
            </div>
          </div>
        </div>
        <!-- *** GET INSPIRED END ***-->
        <!--
        *** BLOG HOMEPAGE ***
        _________________________________________________________
        -->
        <div class="box text-center">
          <div class="container">
            <div class="col-md-12">
              <h3 class="text-uppercase">From our blog</h3>
              <p class="lead mb-0">What's new in the world of fashion? <a href="blog.html">Check our blog!</a></p>
            </div>
          </div>
        </div>
        <div class="container">
          <div class="col-md-12">
            <div id="blog-homepage" class="row">
              <div class="col-sm-6">
                <div class="post">
                  <h4><a href="post.html">Fashion now</a></h4>
                  <p class="author-category">By <a href="#">John Slim</a> in <a href="">Fashion and style</a></p>
                  <hr>
                  <p class="intro">Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.</p>
                  <p class="read-more"><a href="post.html" class="btn btn-primary">Continue reading</a></p>
                </div>
              </div>
              <div class="col-sm-6">
                <div class="post">
                  <h4><a href="post.html">Who is who - example blog post</a></h4>
                  <p class="author-category">By <a href="#">John Slim</a> in <a href="">About Minimal</a></p>
                  <hr>
                  <p class="intro">Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.</p>
                  <p class="read-more"><a href="post.html" class="btn btn-primary">Continue reading</a></p>
                </div>
              </div>
            </div>
            <!-- /#blog-homepage-->
          </div>
        </div>
        <!-- /.container-->
        <!-- *** BLOG HOMEPAGE END ***-->
      </div>
    </div>
    
  
    <!--
    *** FOOTER ***
    _________________________________________________________
    -->
    <jsp:include page="/inc/footer.jsp"></jsp:include>
    
    
    <!--
    *** COPYRIGHT ***
    _________________________________________________________
    -->
	<jsp:include page="/inc/copy.jsp"></jsp:include>
    <!-- JavaScript files-->
    <jsp:include page="/inc/script.jsp"></jsp:include>
  </body>
</html>