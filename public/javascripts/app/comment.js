function initCommentsContainers(containers) {
  $(".btn-comment-praise").each(function(){
    var btn = $(this);
    var praiseId = btn.attr("praise-id");
    var commentId = btn.attr("comment-id");
    var lock = false;
    btn.click(function(){
      if(lock) {
        return false;
      }
      if(!hasUserLogin) {
        alert("登录以后才可以赞哦！");
        return false;
      }
      lock = true;
      if(praiseId) {
        //cancel praise.
        var data = {
          _method :"delete"
        };
        $.ajax({
          type : "POST",
          url : "/comment_praise/"+praiseId,
          data : data,
          dataType : "html",
          cache : false,
          success : function(rs) {
            if(rs=="error") {
              alert("错误："+rs);
              return;
            }
            btn.find(".comment-praise-body").html("赞");
            btn.find(".comment-praise-count").html(
              parseInt(btn.find(".comment-praise-count").html())-1
            );
            praiseId = null;
            lock = false;
          }
        });
      } else {
        //praise
        var data = {
          id : commentId
        };
        $.ajax({
          type : "POST",
          url : "/comment_praise/",
          data : data,
          dataType : "html",
          cache : false,
          success : function(id) {
            if(id=="error") {
              alert("错误："+rs);
              return;
            }
            btn.find(".comment-praise-body").html("取消赞");
            btn.find(".comment-praise-count").html(
              parseInt(btn.find(".comment-praise-count").html())+1
            );
            praiseId = id;
            lock = false;
          }
        });
      }
      return false;
    });
  });
  $(".btn-reply").click(function(){
    var name = $(this).attr("author-name");
    clearTextValue();
    $("#comment-content").val(
      $("#comment-content").val()+"@"+name
    );
    recoverTextValue();
    return false;
  });
  $(".btn-delete-comment").click(function(){
    if(deleteCommentLock) {
      return false;
    }
    deleteCommentLock = true;
    
    var commentId = $(this).attr("comment-id");
    $.ajax({
      type : "POST",
      url : "/comment/"+commentId,
      data : {_method : "delete"},
      dataType : "html",
      cache : false,
      success : function (rs) {
        if(rs=="ok") {
          loadCommentsFrom(currCommentsUrl);
        } else {
          alert("错误："+rs);
        }
        deleteCommentLock = false;
      }
    });
    return false;
  });
}

var deleteCommentLock = false;
var currCommentsUrl = null;
var lockCommentsContainers = false;
var lockCommitComment = false;

function setCommentsPage(content) {
  lockCommentsContainers = false;
  var containers = $("#comment-containers");
  containers.html(content);
  initCommentsContainers(containers);
  containers.find("a").each(function(){
    
    if($(this).data("events")) {
      if($(this).data("events")["click"]) {
        return;
      }
    }
    $(this).click(function(){
      if(lockCommentsContainers) {
        return false;
      }
      loadCommentsFrom($(this).attr("href"));
      return false;
      });
  });
}

function loadCommentsFrom(url, data) {
  if(url=="#") {
    return;
  }
  if(!(data)) {
    data = {};
  }
  lockCommentsContainers = true;
  
  currCommentsUrl = url;
  $.ajax({
      type : "GET",
      url : url,
      data : data,
      dataType : "html",
      cache : false,
      success : setCommentsPage
  });
}

function loadComments() {
  loadCommentsFrom("/comment", {
    post_id : postId,
    page : commentPage
  });
}

function clickCommitComment() {
  if(lockCommitComment) {
    alert("正在提交评论...");
    return;
  }
  clearTextValue();
  var content = $("#comment-content").val();
  recoverTextValue();
  
  if($.trim(content)=="") {
    alert("评论内容不能为空");
    return;
  }
  if(content.length > 500) {
    alert("评论必须在500字以内");
    return;
  }
  var data = {
    post_id : postId,
    content : content
  };
  $.ajax({
      type : "POST",
      url : "/comment",
      dataType : "html",
      data : data,
      cache : false,
      success : function(rs){
        if(rs=="ok") {
          loadComments();
          clearTextValue();
          $("#comment-content").val("");
          recoverTextValue();
          alert("评论成功！");
        } else {
          alert("评论失败："+rs);
        }
        lockCommitComment = false;
      }
  });
  lockCommitComment = true;
}

var commentInScreen = false;
var hasCallLoadComment = false;

$(function(){
  $("#btn-commit-comment").click(function(){
    clickCommitComment();
    return false;
  });
  $(window).scroll(function () {
    //当用户滚动到底部评论区域时，才开始载入评论。
    if(hasCallLoadComment) {
      return;
    }
    var eleTop = $("#comment-containers").offset().top
    var screenButtom = $(window).height() + $(window).scrollTop();
    if (eleTop < screenButtom) {
      if(!commentInScreen) {
        commentInScreen = true;
        hasCallLoadComment = true;
        loadComments();
      }
    }else {
      commentInScreen = false;
    }
  }); 
});
