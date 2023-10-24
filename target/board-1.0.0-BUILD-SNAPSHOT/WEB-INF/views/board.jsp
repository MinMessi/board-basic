<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ page session="true"%>
<c:set var="loginId" value="${sessionScope.id}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'ID:'+=loginId}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Bulletine Board Basic</title>
  <link rel="stylesheet" href="<c:url value='/css/menu.css'/>">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: "Noto Sans KR", sans-serif;
    }

    .container {
      width : 50%;
      margin : auto;
    }

    .writing-header {
      position: relative;
      margin: 20px 0 0 0;
      padding-bottom: 10px;
      border-bottom: 1px solid #323232;
    }

    input {
      width: 100%;
      height: 35px;
      margin: 5px 0px 10px 0px;
      border: 1px solid #e9e8e8;
      padding: 8px;
      background: #f8f8f8;
      outline-color: #e6e6e6;
    }

    textarea {
      width: 100%;
      background: #f8f8f8;
      margin: 5px 0px 10px 0px;
      border: 1px solid #e9e8e8;
      resize: none;
      padding: 8px;
      outline-color: #e6e6e6;
    }

    .frm {
      width:100%;
    }
    .btn {
      background-color: rgb(236, 236, 236); /* Blue background */
      border: none; /* Remove borders */
      color: black; /* White text */
      padding: 6px 12px; /* Some padding */
      font-size: 16px; /* Set a font size */
      cursor: pointer; /* Mouse pointer on hover */
      border-radius: 5px;
    }

    .btn:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
<div id="menu">
  <ul>
    <li id="logo">Bulletine Board Basic</li>
    <li><a href="<c:url value='/'/>">Home</a></li>
    <li><a href="<c:url value='/board/list'/>">Board</a></li>
    <li><a href="<c:url value='${loginOutLink}'/>">${loginOut}</a></li>
    <li><a href="<c:url value='/register/add'/>">Sign in</a></li>
    <li><a href=""><i class="fa fa-search"></i></a></li>
  </ul>
</div>
<script>
  let msg = "${msg}";
  if(msg=="WRT_ERR") alert("게시물 등록에 실패하였습니다. 다시 시도해 주세요.");
  if(msg=="MOD_ERR") alert("게시물 수정에 실패하였습니다. 다시 시도해 주세요.");
</script>
<div class="container">
  <h2 class="writing-header">게시판 ${mode=="new" ? "글쓰기" : "읽기"}</h2>
  <form id="form" class="frm" action="" method="post">
    <input type="hidden" name="bno" value="${boardDto.bno}">

    <input name="title" type="text" value="${boardDto.title}" placeholder="  제목을 입력해 주세요." ${mode=="new" ? "" : "readonly='readonly'"}><br>
    <textarea name="content" rows="20" placeholder=" 내용을 입력해 주세요." ${mode=="new" ? "" : "readonly='readonly'"}>${boardDto.content}</textarea><br>

    <c:if test="${mode eq 'new'}">
      <button type="button" id="writeBtn" class="btn btn-write"><i class="fa fa-pencil"></i> 등록</button>
    </c:if>
    <c:if test="${mode ne 'new'}">
      <button type="button" id="writeNewBtn" class="btn btn-write"><i class="fa fa-pencil"></i> 글쓰기</button>
    </c:if>
    <c:if test="${boardDto.writer eq loginId}">
      <button type="button" id="modifyBtn" class="btn btn-modify"><i class="fa fa-edit"></i> 수정</button>
      <button type="button" id="removeBtn" class="btn btn-remove"><i class="fa fa-trash"></i> 삭제</button>
    </c:if>
    <button type="button" id="listBtn" class="btn btn-list"><i class="fa fa-bars"></i> 목록</button>
  </form>
</div>
<script>
  $(document).ready(function(){
    let formCheck = function() {
      let form = document.getElementById("form");
      if(form.title.value=="") {
        alert("제목을 입력해 주세요.");
        form.title.focus();
        return false;
      }

      if(form.content.value=="") {
        alert("내용을 입력해 주세요.");
        form.content.focus();
        return false;
      }
      return true;
    }

    $("#writeNewBtn").on("click", function(){
      location.href="<c:url value='/board/write'/>";
    });

    $("#writeBtn").on("click", function(){
      let form = $("#form");
      form.attr("action", "<c:url value='/board/write'/>");
      form.attr("method", "post");

      if(formCheck())
        form.submit();
    });

    $("#modifyBtn").on("click", function(){
      let form = $("#form");
      let isReadonly = $("input[name=title]").attr('readonly');

      // 1. 읽기 상태이면, 수정 상태로 변경
      if(isReadonly=='readonly') {
        $(".writing-header").html("게시판 수정");
        $("input[name=title]").attr('readonly', false);
        $("textarea").attr('readonly', false);
        $("#modifyBtn").html("<i class='fa fa-pencil'></i> 등록");
        return;
      }

      // 2. 수정 상태이면, 수정된 내용을 서버로 전송
      form.attr("action", "<c:url value='/board/modify${searchCondition.queryString}'/>");
      form.attr("method", "post");
      if(formCheck())
        form.submit();
    });

    $("#removeBtn").on("click", function(){
      if(!confirm("정말로 삭제하시겠습니까?")) return;

      let form = $("#form");
      form.attr("action", "<c:url value='/board/remove${searchCondition.queryString}'/>");
      form.attr("method", "post");
      form.submit();
    });

    $("#listBtn").on("click", function(){
      location.href="<c:url value='/board/list${searchCondition.queryString}'/>";
    });
  });
</script>

<%-- ------------------------------Comments-------------------------------- --%>

<%--<h2>commentTest</h2>--%>
<%--comment : <input type="text" name="comment"><br>--%>
<%--<button id="sendBtn" type="button">SEND</button>--%>
<%--<button id="modBtn" type="button">수정 적용</button>--%>
<%--<div id="commentList"></div>   <!-- 댓글이 보여지는 영역 -->--%>
<%--<div id="replyForm" style="display: none">  <!-- 답글(대댓글)이 보여지는 영역(일단 display:none 으로 안보이게 하고 특정 답글 아래에 위치할 예정) -->--%>
<%--  <input type="text" name="replyComment">--%>
<%--  <button id="wrtRepBtn" type="button">등록</button>--%>
<%--</div>--%>
<%--<script>--%>
<%--  let bno = 1;--%>

<%--  let showList = function(bno){--%>
<%--    $.ajax({--%>
<%--      type:'GET',       // 요청 메서드--%>
<%--      url: '/board/comments?bno='+bno,  // 요청 URI--%>
<%--      dataType : 'json', // 전송받을 데이터의 타입--%>
<%--      success : function(result){--%>
<%--        $("#commentList").html(toHtml(result));    // 서버로부터 응답이 도착하면 호출될 함수--%>
<%--      },--%>
<%--      error   : function(){ alert("error from showList") } // 에러가 발생했을 때, 호출될 함수--%>
<%--    }); // $.ajax()--%>
<%--  }--%>

<%--  $(document).ready(function(){--%>
<%--    showList(bno);--%>

<%--    $("#modBtn").click(function(){--%>
<%--      let cno = $(this).attr("data-cno");--%>
<%--      let comment = $("input[name=comment]").val();--%>

<%--      if(comment.trim()==''){--%>
<%--        alert("댓글을 입력하세요");--%>
<%--        $("input[name=comment]").focus();--%>
<%--        return;--%>
<%--      }--%>

<%--      $.ajax({--%>
<%--        type:'PATCH',       // 요청 메서드--%>
<%--        url: '/board/comments/'+cno,  // 요청 URI--%>
<%--        headers : { "content-type": "application/json"}, // 요청 헤더--%>
<%--        data : JSON.stringify({cno:cno, comment:comment}),  // 서버로 전송할 데이터. stringify()로 직렬화 필요.--%>
<%--        success : function(result){--%>
<%--          alert(result);--%>
<%--          showList(bno);--%>
<%--        },--%>
<%--        error   : function(){ alert("error from sendBtn") } // 에러가 발생했을 때, 호출될 함수--%>
<%--      }); // $.ajax()--%>
<%--    });--%>

<%--    // 답글등록 버튼--%>
<%--    $("#wrtRepBtn").click(function(){--%>
<%--      let comment = $("input[name=replyComment]").val();--%>
<%--      let pcno = $("#replyForm").parent().attr("data-pcno");   // .parent()는 replyForm의 부모인 <li>를 의미--%>

<%--      if(comment.trim()==''){--%>
<%--        alert("댓글을 입력하세요");--%>
<%--        $("input[name=replyComment]").focus()--%>
<%--        return;--%>
<%--      }--%>

<%--      $.ajax({--%>
<%--        type:'POST',       // 요청 메서드--%>
<%--        url: '/board/comments?bno=' +bno,  // 요청 URI--%>
<%--        headers : { "content-type": "application/json"}, // 요청 헤더--%>
<%--        data : JSON.stringify({pcno:pcno, bno:bno, comment:comment}),  // 서버로 전송할 데이터. stringify()로 직렬화 필요.--%>
<%--        success : function(result){--%>
<%--          alert(result);--%>
<%--          showList(bno);--%>
<%--        },--%>
<%--        error   : function(){ alert("error from sendBtn") } // 에러가 발생했을 때, 호출될 함수--%>
<%--      }); // $.ajax()--%>

<%--      $("#replyForm").css("display", "none")--%>
<%--      $("input[name=replyComment]").val('')--%>
<%--      $("#replyForm").appendTo("body");--%>
<%--    });--%>

<%--    // send(등록) 버튼--%>
<%--    $("#sendBtn").click(function(){--%>
<%--      let comment = $("input[name=comment]").val();--%>

<%--      if(comment.trim()==''){--%>
<%--        alert("댓글을 입력하세요");--%>
<%--        $("input[name=comment").focus()--%>
<%--        return;--%>
<%--      }--%>

<%--      $.ajax({--%>
<%--        type:'POST',       // 요청 메서드--%>
<%--        url: '/board/comments?bno=' +bno,  // 요청 URI--%>
<%--        headers : { "content-type": "application/json"}, // 요청 헤더--%>
<%--        data : JSON.stringify({bno:bno, comment:comment}),  // 서버로 전송할 데이터. stringify()로 직렬화 필요.--%>
<%--        success : function(result){--%>
<%--          alert(result);--%>
<%--          showList(bno);--%>
<%--        },--%>
<%--        error   : function(){ alert("error from sendBtn") } // 에러가 발생했을 때, 호출될 함수--%>
<%--      }); // $.ajax()--%>
<%--    });--%>

<%--    // 수정 버튼--%>
<%--    $("#commentList").on("click", ".modBtn", function(){    // 이방법이 동적으로 생성되는 요소에 이벤트를 거는 방법임--%>
<%--      let cno = $(this).parent().attr("data-cno");        // html 태그마다 속성이 매우 많지만 "data-"를 접두사로 붙이는게 규칙임--%>
<%--      let bno = $(this).parent().attr("data-bno");--%>
<%--      let comment = $("span.comment", $(this).parent()).text();--%>

<%--      // 1. 수정 버튼을 comment의 내용을 input태그에 뿌려주기--%>
<%--      $("input[name=comment]").val(comment);--%>
<%--      // 2. cno 전달하기--%>
<%--      $("#modBtn").attr("data-cno", cno);--%>
<%--    });--%>

<%--    $("#commentList").on("click", ".replyBtn", function(){--%>
<%--      // 1. replyForm을 댓글 아래위치에 옮기고--%>
<%--      $("#replyForm").appendTo($(this).parent());--%>
<%--      // 2. 답글을 입력할 폼을 보여준다.--%>
<%--      $("#replyForm").css("display", "block");--%>

<%--    });--%>


<%--    // 삭제 버튼--%>
<%--    //$(".delBtn").click(function(){    // 이시점에 delBtn이 없으므로 고정요소에 클릭이벤트를 걸어야함--%>
<%--    $("#commentList").on("click", ".delBtn", function(){    // 이방법이 동적으로 생성되는 요소에 이벤트를 거는 방법임--%>
<%--      let cno = $(this).parent().attr("data-cno");        // html 태그마다 속성이 매우 많지만 "data-"를 접두사로 붙이는게 규칙임--%>
<%--      let bno = $(this).parent().attr("data-bno");--%>

<%--      $.ajax({--%>
<%--        type:'DELETE',       // 요청 메서드--%>
<%--        url: '/board/comments/'+cno+'?bno='+bno,  // 요청 URI--%>
<%--        success : function(result){--%>
<%--          alert(result);--%>
<%--          //showList(bno);--%>
<%--        },--%>
<%--        error   : function(){ alert("error from showList") } // 에러가 발생했을 때, 호출될 함수--%>
<%--      }); // $.ajax()--%>
<%--    });--%>
<%--  });--%>

<%--  let toHtml = function (comments) {--%>
<%--    let tmp = "<ul>";--%>

<%--    comments.forEach(function(comment) {--%>
<%--      tmp += '<li data-cno=' + comment.cno;--%>
<%--      tmp += ' data-pcno=' + comment.pcno;--%>
<%--      tmp += ' data-bno=' + comment.bno + '>';--%>
<%--      if (comment.cno != comment.pcno)--%>
<%--      tmp += "L";--%>
<%--      tmp += ' commenter=<span class="commenter">' + comment.commenter + '</span>';--%>
<%--      tmp += ' comment=<span class="comment">' + comment.comment + '</span>';--%>
<%--      tmp += ' up_date=' + comment.up_date;--%>
<%--      tmp += '<button class="delBtn">삭제</button>'--%>
<%--      tmp += '<button class="modBtn">수정</button>'--%>
<%--      tmp += '<button class="replyBtn">답글</button>'--%>
<%--      tmp += '</li>';--%>
<%--    })--%>

<%--    return tmp + "</ul>";--%>
<%--  }--%>

<%--</script>--%>

<%--<style>--%>
<%--  .comment-header {--%>
<%--    margin-top: 20px;--%>
<%--    padding-bottom: 10px;--%>
<%--    border-bottom: 1px solid #323232;--%>
<%--  }--%>

<%--  .comment-form {--%>
<%--    margin-top: 10px;--%>
<%--    padding: 20px 0;--%>
<%--  }--%>

<%--  .comment-form input[type="text"],--%>
<%--  .comment-form textarea {--%>
<%--    width: 100%;--%>
<%--    margin-bottom: 10px;--%>
<%--    padding: 8px;--%>
<%--    border: 1px solid #e9e8e8;--%>
<%--    background: #f8f8f8;--%>
<%--    outline-color: #e6e6e6;--%>
<%--  }--%>

<%--  .comment-form .btn {--%>
<%--    background-color: rgb(236, 236, 236);--%>
<%--    border: none;--%>
<%--    color: black;--%>
<%--    padding: 6px 12px;--%>
<%--    font-size: 16px;--%>
<%--    cursor: pointer;--%>
<%--    border-radius: 5px;--%>
<%--    text-decoration: none;--%>
<%--  }--%>

<%--  .comment-form .btn:hover {--%>
<%--    text-decoration: underline;--%>
<%--  }--%>

<%--  .comment-list {--%>
<%--    list-style: none;--%>
<%--    margin-top: 20px;--%>
<%--  }--%>

<%--  .comment-item {--%>
<%--    border: 1px solid #e5e5e5;--%>
<%--    border-radius: 5px;--%>
<%--    margin: 10px 0;--%>
<%--    padding: 10px;--%>
<%--    background: #f8f8f8;--%>
<%--  }--%>

<%--  .comment-item .commenter {--%>
<%--    font-size: 12pt;--%>
<%--    font-weight: bold;--%>
<%--  }--%>

<%--  .comment-item .comment-content {--%>
<%--    margin: 10px 0;--%>
<%--  }--%>

<%--  .comment-item .comment-actions {--%>
<%--    text-align: right;--%>
<%--  }--%>

<%--  .comment-item .comment-actions .btn {--%>
<%--    margin-left: 10px;--%>
<%--  }--%>
<%--</style>--%>


</body>
</html>