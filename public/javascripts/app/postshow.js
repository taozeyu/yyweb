var lockParagraphId = -1;
var commitLock = false;

function refreshPanel(paragraph, id, single) {
  paragraph.html('<div class="p-translation" style="text-align: center;">请稍后...</div>');
  var data = {};
  var url = "/paragraph/"+id;
  if(single) {
    url += "/single";
  }
  $.ajax({
      type : "GET",
      url : url,
      dataType : "html",
      data : data,
      cache : false,
      success : function(rs){
        paragraph.html(rs);
        initShowPanel(paragraph, id);
        if(single) {
          lockParagraphId = -1;
          paragraph.attr("class", "paragraph");
        }
      }
  });
  lockParagraphId = id;
}

function clickVote(paragraph, id, tid) {
  var data = {
    id : tid
  };
  $.ajax({
      type : "POST",
      url : "/translated_text_vote/",
      dataType : "html",
      data : data,
      cache : false,
      success : function(rs){
         onCommit(rs, paragraph, id);
      }
  });
  commitLock = true;
}

function clickCancelVote(paragraph, id, vid) {
  var data = {
    _method :"delete"
  };
  $.ajax({
      type : "POST",
      url : "/translated_text_vote/"+vid,
      dataType : "html",
      data : data,
      cache : false,
      success : function(rs){
         onCommit(rs, paragraph, id);
      }
  });
  commitLock = true;
}

var deleteTranslatedTextLock = false;

function clickDelete(paragraph, id, tid) {
  if(deleteTranslatedTextLock) {
    return;
  }
  if(!confirm("确实要删除这篇译文吗？")) {
    return;
  }
  deleteTranslatedTextLock = true;
  var data = {
    _method : "delete"
  };
  $.ajax({
      type : "POST",
      url : "/translated_text/"+tid,
      dataType : "html",
      data : data,
      cache : false,
      success : function(rs){
        deleteTranslatedTextLock = false;
         onCommit(rs, paragraph, id);
      }
  });
}

function clickEdit(paragraph, id, tid) {
  var content = $("#t-"+tid).html();
  $("#p-rear").html(
    '<div class="p-line"></div>' +
    '<div class="p-title">编辑我的翻译：</div>' +
    '<textarea id="translation-textarea" >'+
    content+
    '</textarea>'+
    '<div class="p-button"><a id="edit-translation" href="#">编辑</a></div>'
  );
  $("#edit-translation").click(function(){
    var content = $("#translation-textarea").val();
    if(!checkTranslatedText(content)) {
      return;
    }
    var data = {
      _method : "PUT",
      content : content
    };
    $.ajax({
      type : "POST",
      url : "/translated_text/"+tid,
      dataType : "html",
      data : data,
      cache : false,
      success : function(rs) {
        onCommit(rs, paragraph, id);
      }
  });
    return false;
  });
}

function clickShowParagraph(paragraph, id) {
  if(lockParagraphId != -1) {
    alert("不可以同时展开多个段落。");
    return;
  }
  refreshPanel(paragraph, id);
}

function checkTranslatedText(content) {
  if($.trim(content)=="") {
    alert("译文不能为空！");
    return false;
  }
  if(content.length > 1000) {
    alert("译文不得超过1000字！");
    return false;
  }
  return true;
}

function clickCommitTranslattion(paragraph, id) {
  if(commitLock) {
    alert("已经在提交了...别性急嘛。（如果半天都没反应则可能是挂了哦，那你就悲剧了。）");
    return;
  }
  var content = $("#translation-textarea").val();
  if(!checkTranslatedText(content)) {
    return;
  }
  var data = {
    id : id,
    content : content
  };
  $.ajax({
      type : "POST",
      url : "/translated_text",
      dataType : "html",
      data : data,
      cache : false,
      success : function(rs) {
        onCommit(rs, paragraph, id);
      }
  });
  commitLock = true;
}

function clickCloseParagraph(paragraph, id) {
  if(commitLock) {
    alert("正在提交...");
    return;
  }
  refreshPanel(paragraph, id, true);
}

function onCommit(rs, paragraph, id) {
  commitLock = false;
  if(rs=="ok") {
    refreshPanel(paragraph, id);
  } else {
    alert("错误："+rs);
  }
}

function initShowPanel(paragraph, id) {
  paragraph.attr("class", "paragraph-light");
  $("#close-paragraph").click(function(){
    clickCloseParagraph(paragraph, id);
    return false;
  });
  $("#commit-translation").click(function() {
    clickCommitTranslattion(paragraph, id);
    return false;
  });
  $("#show-paragraph-"+id).click(function(){
    clickShowParagraph(paragraph, id);
    return false;
  });
  $("#p-edit").click(function(){
    clickEdit(paragraph, id, $(this).attr("t-id"));
    $(this).attr("style", "visibility:hidden;");
    return false;
  });
  $("#p-delete").click(function(){
    clickDelete(paragraph, id, $(this).attr("t-id"));
    return false;
  });
  $(".btn-vote").click(function(){
    clickVote(paragraph, id, $(this).attr("t-id"));
    return false;
  });
  $(".btn-cancel-vote").click(function(){
    clickCancelVote(paragraph, id, $(this).attr("v-id"));
    return false;
  });
}

function mouseenter(paragraph) {
  if(lockParagraphId!=-1) {
    return;
  }
  paragraph.attr("class", "paragraph-light");
  paragraph.children(".p-state").attr("style", "visibility:visible;");
}

function mouseleave(paragraph) {
  if(lockParagraphId!=-1) {
    return;
  }
  paragraph.attr("class", "paragraph");
  paragraph.children(".p-state").attr("style", "visibility:hidden;");
}

var editOrDeleteLock = false;

function clickDeletePost() {
  if(editOrDeleteLock) {
    return false;
  }
  if(!confirm("你确定要删除整张贴子和全部回复，以及全部译文吗？")) {
    return false;
  }
  editOrDeleteLock = true;
  
  var data={
    _method : "delete"
  };
  $.ajax({
      type : "POST",
      url : "/post/"+postId,
      dataType : "html",
      data : data,
      cache : false,
      success : function(rs){
        if(rs=="ok") {
          alert("删除成功！");
           window.location.href = nodePath;
        } else {
          alert("错误："+rs);
        }
      }
  });
  return false;
}

$(function(){
  $(".paragraph").each(function(){
    var paragraph = $(this);
    var id = paragraph.attr("id").replace("p-", "");
    paragraph.mouseenter(function(){
      mouseenter(paragraph);
    });
    paragraph.mouseleave(function(){
      mouseleave(paragraph);
    });
    $("#show-paragraph-"+id).click(function(){
      clickShowParagraph(paragraph, id);
      return false;
    });
  });
  $("#btn-delete-post").click(clickDeletePost);
});
