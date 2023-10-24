<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
</head>
<body>
<h2>commentTest</h2>
comment : <input type="text" name="comment"><br>
<button id="sendBtn" type="button">SEND</button>
<button id="modBtn" type="button">수정 적용</button>
<div id="commentList"></div>   <!-- 댓글이 보여지는 영역 -->
<div id="replyForm" style="display: none">  <!-- 답글(대댓글)이 보여지는 영역(일단 display:none 으로 안보이게 하고 특정 답글 아래에 위치할 예정) -->
    <input type="text" name="replyComment">
    <button id="wrtRepBtn" type="button">등록</button>
</div>
<script>
    let bno = 1;

    let showList = function(bno){
        $.ajax({
            type:'GET',       // 요청 메서드
            url: '/board/comments?bno='+bno,  // 요청 URI
            dataType : 'json', // 전송받을 데이터의 타입
            success : function(result){
                $("#commentList").html(toHtml(result));    // 서버로부터 응답이 도착하면 호출될 함수
            },
            error   : function(){ alert("error from showList") } // 에러가 발생했을 때, 호출될 함수
        }); // $.ajax()
    }

    $(document).ready(function(){
        showList(bno);

        $("#modBtn").click(function(){
            let cno = $(this).attr("data-cno");
            let comment = $("input[name=comment]").val();

            if(comment.trim()==''){
                alert("댓글을 입력하세요");
                $("input[name=comment]").focus();
                return;
            }

            $.ajax({
                type:'PATCH',       // 요청 메서드
                url: '/board/comments/'+cno,  // 요청 URI
                headers : { "content-type": "application/json"}, // 요청 헤더
                data : JSON.stringify({cno:cno, comment:comment}),  // 서버로 전송할 데이터. stringify()로 직렬화 필요.
                success : function(result){
                    alert(result);
                    showList(bno);
                },
                error   : function(){ alert("error from sendBtn") } // 에러가 발생했을 때, 호출될 함수
            }); // $.ajax()
        });

        // 답글등록 버튼
        $("#wrtRepBtn").click(function(){
            let comment = $("input[name=replyComment]").val();
            let pcno = $("#replyForm").parent().attr("data-pcno");   // .parent()는 replyForm의 부모인 <li>를 의미

            if(comment.trim()==''){
                alert("댓글을 입력하세요");
                $("input[name=replyComment]").focus()
                return;
            }

            $.ajax({
                type:'POST',       // 요청 메서드
                url: '/board/comments?bno=' +bno,  // 요청 URI
                headers : { "content-type": "application/json"}, // 요청 헤더
                data : JSON.stringify({pcno:pcno, bno:bno, comment:comment}),  // 서버로 전송할 데이터. stringify()로 직렬화 필요.
                success : function(result){
                    alert(result);
                    showList(bno);
                },
                error   : function(){ alert("error from sendBtn") } // 에러가 발생했을 때, 호출될 함수
            }); // $.ajax()

            $("#replyForm").css("display", "none")
            $("input[name=replyComment]").val('')
            $("#replyForm").appendTo("body");
        });

        // send(등록) 버튼
        $("#sendBtn").click(function(){
            let comment = $("input[name=comment]").val();

            if(comment.trim()==''){
                alert("댓글을 입력하세요");
                $("input[name=comment").focus()
                return;
            }

            $.ajax({
                type:'POST',       // 요청 메서드
                url: '/board/comments?bno=' +bno,  // 요청 URI
                headers : { "content-type": "application/json"}, // 요청 헤더
                data : JSON.stringify({bno:bno, comment:comment}),  // 서버로 전송할 데이터. stringify()로 직렬화 필요.
                success : function(result){
                   alert(result);
                   showList(bno);
                },
                error   : function(){ alert("error from sendBtn") } // 에러가 발생했을 때, 호출될 함수
            }); // $.ajax()
        });

        // 수정 버튼
        $("#commentList").on("click", ".modBtn", function(){    // 이방법이 동적으로 생성되는 요소에 이벤트를 거는 방법임
            let cno = $(this).parent().attr("data-cno");        // html 태그마다 속성이 매우 많지만 "data-"를 접두사로 붙이는게 규칙임
            let bno = $(this).parent().attr("data-bno");
            let comment = $("span.comment", $(this).parent()).text();

            // 1. 수정 버튼을 comment의 내용을 input태그에 뿌려주기
            $("input[name=comment]").val(comment);
            // 2. cno 전달하기
            $("#modBtn").attr("data-cno", cno);
        });

        // 답글(대댓글) 버튼
        $("#commentList").on("click", ".replyBtn", function(){
            // 1. replyForm을 댓글 아래위치에 옮기고
            $("#replyForm").appendTo($(this).parent());
            // 2. 답글을 입력할 폼을 보여준다.
            $("#replyForm").css("display", "block");

        });


        // 삭제 버튼
        //$(".delBtn").click(function(){    // 이시점에 delBtn이 없으므로 고정요소에 클릭이벤트를 걸어야함
        $("#commentList").on("click", ".delBtn", function(){    // 이방법이 동적으로 생성되는 요소에 이벤트를 거는 방법임
            let cno = $(this).parent().attr("data-cno");        // html 태그마다 속성이 매우 많지만 "data-"를 접두사로 붙이는게 규칙임
            let bno = $(this).parent().attr("data-bno");

            $.ajax({
                type:'DELETE',       // 요청 메서드
                url: '/board/comments/'+cno+'?bno='+bno,  // 요청 URI
                success : function(result){
                    alert(result);
                    //showList(bno);
                },
                error   : function(){ alert("error from showList") } // 에러가 발생했을 때, 호출될 함수
            }); // $.ajax()
        });
    });

    let toHtml = function (comments) {
        let tmp = "<ul>";

            comments.forEach(function(comment) {
                tmp += '<li data-cno=' + comment.cno;
                tmp += ' data-pcno=' + comment.pcno;
                tmp += ' data-bno=' + comment.bno + '>';
              if (comment.cno != comment.pcno)
                tmp += "L";
                tmp += ' commenter=<span class="commenter">' + comment.commenter + '</span>';
                tmp += ' comment=<span class="comment">' + comment.comment + '</span>';
                tmp += ' up_date=' + comment.up_date;
                tmp += '<button class="delBtn">삭제</button>'
                tmp += '<button class="modBtn">수정</button>'
                tmp += '<button class="replyBtn">답글</button>'
                tmp += '</li>';
            })

        return tmp + "</ul>";
    }


</script>
</body>
</html>