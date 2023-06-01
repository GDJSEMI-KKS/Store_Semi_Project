package vo;

public class Review {
	private int orderNo;
	private String reviewTitle;
	private String reviewContent;
	private String createdate;
	private String updaetdate;
	
	public int getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(int orderNo) {
		this.orderNo = orderNo;
	}
	public String getReviewTitle() {
		return reviewTitle;
	}
	public void setReviewTitle(String reviewTitle) {
		this.reviewTitle = reviewTitle;
	}
	public String getReviewContent() {
		return reviewContent;
	}
	public void setReviewContent(String reviewContent) {
		this.reviewContent = reviewContent;
	}
	public String getCreatedate() {
		return createdate;
	}
	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}
	public String getUpdaetdate() {
		return updaetdate;
	}
	public void setUpdaetdate(String updaetdate) {
		this.updaetdate = updaetdate;
	}
	
}
