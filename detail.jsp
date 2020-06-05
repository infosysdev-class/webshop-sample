<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" import="java.sql.*"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--

  データベースへのコネクションを取得

--%>
<sql:setDataSource driver="org.h2.Driver" url="jdbc:h2:sdev" />


<%--

  販売画面で選択した衣料品の情報を取得する

  商品コードを取得し、変数[formProductCode]に格納する

--%>
<fmt:requestEncoding value="utf-8" />
<c:set var="formProductCode" value="${param.selectedProductCode}" />
<%--

  商品の在庫を検索する
  [PRODUCT_STOCK]テーブルから[PRODUCT_CODE], [MAKER_ID], [PC_NAME],
   [PC_TYPE], [SAL_VALUE], [SPEC], [STOCK_NUM]を検索するSQL文

--%>
<sql:query var="rs">
SELECT STOCK_NUM
  FROM PRODUCT_STOCK WHERE PRODUCT_CODE = ?;
<sql:param value="${formProductCode}" />
</sql:query>

<%-- 在庫数を変数[stockNum]に格納する --%>
<c:choose>
  <c:when test="${rs.rowCount == 0}">
    <c:set var="stockNum" value="0" />
  </c:when>
  <c:otherwise>
    <c:set var="row" value="${rs.rows[0]}" />
    <c:set var="stockNum" value="${row.STOCK_NUM}" />
  </c:otherwise>
</c:choose>

<%--

  商品の情報を検索する
  [PRODUCT_INFO]テーブルから [PRODUCT_CODE], [PRODUCT_NAME],
  [CATEGORY_NAME], [MAKER_NAME], [DETAIL], [MATERIAL], [SIZE], [IMAGE],
  [PRICE] を [PRODUCT_CODE]の昇順で検索するSQL文。

--%>
<sql:query var="rs">
SELECT PRODUCT_CODE, PRODUCT_NAME, CATEGORY_NAME, MAKER_NAME, DETAIL, MATERIAL, SIZE, IMAGE, PRICE
  FROM PRODUCT_INFO WHERE PRODUCT_CODE=? ORDER BY PRODUCT_CODE;
<sql:param value="${formProductCode}" />
</sql:query>

<%-- 一行目を変数rowに代入 --%>
<c:set var="row" value="${rs.rows[0]}" />

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>詳細情報</TITLE>
<%--

  表示方法の設定

--%>
<STYLE type="text/css">
body {background-color:white;}
table {border-collapse:separate; border-spacing:2px; width:100%;}
th {background-color:#333333; text-align:center; font-size:large; font-weight:bold; color:white;}
td {background-color:#EFEFEF; font-size:normal; color:black;}
</STYLE>
</head>
<BODY>

		<H2>詳細画面</H2>

<%--

  詳細情報を出力する

--%>
<%-- 画像を出力 --%>
<img src="image/${row.IMAGE}" /><BR>
<%-- メーカーを出力 --%>
メーカー：${row.MAKER_NAME}<BR>
<%-- 製品名を出力 --%>
製品名：${row.PRODUCT_NAME}<BR>
<%-- 素材を出力 --%>
素材：${row.MATERIAL}<BR>
<%-- カテゴリを出力 --%>
カテゴリ：${row.CATEGORY_NAME}<BR>
<%-- 説明を出力 --%>
説明：${row.DETAIL}<BR><BR>

<%-- 販売価格を出力 --%>
販売価格：${row.PRICE}<BR>

<%--

  在庫数を確認して結果を表示する
  在庫数が1より少ないかどうかで在庫の確認を行っている

--%>
<c:choose>
  <c:when test="${stockNum < 1}">
<%-- 商品の在庫が存在しない場合は、品切れの情報を出力する --%>
申し訳ございません。${row.PRODUCT_NAME} は品切れです。<BR>
  </c:when>
  <c:otherwise>

	<FORM action="buy.jsp" method="POST">

<%--

  次の購入のページに製品コードを渡すための処理　
  画面上には出力されない

--%>
<%-- 製品コードのデータ --%>
<input type="hidden" name="hiddenCode" value="${row.PRODUCT_CODE}" />
<input type="hidden" name="hiddenPrice" value="${row.PRICE}" />

購入者氏名：<input type="text" name="customerName" value="">
<BR>
<INPUT type="submit" name="buttonBuy" value="購入する">

	</FORM>

</c:otherwise>
</c:choose>

</BODY>
</HTML>
