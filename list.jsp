<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--

  データベースへのコネクションを取得

--%>
<sql:setDataSource driver="org.h2.Driver" url="jdbc:h2:sdev" />

<%--

  データベースからデータを取得して、変数rsに結果を入れる。

  [PRODUCT_INFO]テーブルから [PRODUCT_CODE], [PRODUCT_NAME],
  [CATEGORY_NAME], [MAKER_NAME], [DETAIL], [MATERIAL], [SIZE], [IMAGE],
  [PRICE] を [PRODUCT_CODE]の昇順で検索するSQL文。

--%>
<sql:query var="rs">
SELECT PRODUCT_CODE, PRODUCT_NAME, CATEGORY_NAME, MAKER_NAME, DETAIL, MATERIAL, SIZE, IMAGE, PRICE
  FROM PRODUCT_INFO ORDER BY PRODUCT_CODE;
</sql:query>

<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<TITLE>衣料品販売</TITLE>

<%--

  表示方法の設定

--%>
<STYLE type="text/css">
body {background-color:white;}
table {border-collapse:separate; border-spacing:2px; width:100%;}
th {background-color:#333333; text-align:center; font-size:large; font-weight:bold; color:white;}
td {background-color:#EFEFEF; font-size:normal; color:black;}
img {vertical-align: middle;}
</STYLE>
</HEAD>
<BODY>
	<CENTER>

		<FORM action="detail.jsp" method="POST">

			<H2>販売</H2>

			<TABLE>
				<TR>
					<TH>イメージ</TH>
					<TH>製品名</TH>
					<TH>カテゴリー</TH>
					<TH>メーカー</TH>
					<TH>サイズ</TH>
					<TH>販売価格</TH>
				</TR>

<%--

  検索結果レコードの表示処理。
  c:forEachタグは、itemsの行数分ループを行う。

--%>

<c:forEach var="row" items="${rs.rows}">

  <TR>
    <%-- 商品を選択するラジオボタンを出力 --%>
    <TD>
      <input type="radio" name="selectedProductCode" value="${row.PRODUCT_CODE}">
      <img src="image/${row.IMAGE}" height="60" />
    </TD>
    <%-- 商品名 --%>
    <TD>${row.PRODUCT_NAME}</TD>
    <TD>${row.CATEGORY_NAME}</TD>
    <TD>${row.MAKER_NAME}</TD>
    <TD>${row.SIZE}</TD>
    <%-- 価格 --%>
    <TD>${row.PRICE}円</TD>
</TR>

</c:forEach> <%-- rsのループ --%>

			</TABLE>
			<BR> <INPUT type="submit" value="詳細" name="detail">

		</FORM>
	</CENTER>
</BODY>
</HTML>
