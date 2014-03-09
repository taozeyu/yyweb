var commitLock = false;

var paragraphsCount = 0;
var nextId = 0;

function countTitleLength(title) {
  var count = 0;
  var reg = /^[\u4E00-\u9FA5]$/;
  for(var i=0; i<title.length; ++i) {
    char = title.substr(i, 1);
    if(reg.test(char)) {
      count += 3;
    } else {
      count += 1;
    }
  }
  return count;
}

function checkTitleAndContent(title, postContent) {
  
  if(title=="") {
    alert("标题不能为空！");
    return false;
  }else if(countTitleLength(title) > 120) {
    alert("中文标题不能超过40字，英文标题不能超过120个字。");
    return false;
  }
  if(postContent.length > 2000) {
    alert("内容不得超过2000字！");
    recoverTextValue();
    return false;
  }
  return true
}

function clickCommitEdit() {
  if(commitLock) {
    return false;
  }
  commitLock = true;
  
  clearTextValue();
  var title = $.trim($("#title").val());
  var postContent = $("#post-content").val();
  
  if(!checkTitleAndContent(title, postContent)){
    commitLock = false;
    recoverTextValue();
    return false;
  }
  var url = "/post/"+postId;
  var data = {
    _method : "put",
    title : title,
    content : postContent
  };
  recoverTextValue();
  
  $.ajax({
      type : "POST",
      url : url,
      dataType : "html",
      data : data,
      cache : false,
      success : function(rs) {
        if(rs=="error") {
          alert("错误！");
        } else {
          window.location.href= "/post/" + postId;
        }
      }
  });
  return false;
}

function commitPost(paragraphs) {

  var title = $.trim($("#title").val());
  var postContent = $("#post-content").val();
  
  if(!checkTitleAndContent(title, postContent)){
    commitLock = false;
    recoverTextValue();
    return false;
  }
  
  var url = "/post/";
  var data = {
    title : title,
    content : postContent,
    node : nodeId,
    type : type,
    paragraphs : paragraphs
  };
  recoverTextValue();
  
  $.ajax({
      type : "POST",
      url : url,
      dataType : "html",
      data : data,
      cache : false,
      success : function(rs) {
        if(rs=="error") {
          alert("错误！");
        } else {
          window.location.href= "/post/" + rs;
        }
      }
  });
  return false;
}

function clickCommitTranslation() {

  if(commitLock) {
    return false;
  }
  commitLock = true;
  clearTextValue();
  
  var paragraphs = [];
  $("#translation-box").children("div.paragraph").each(function(){
    var paragraph = $("#body-"+$(this).attr("id").replace("paragraph-", "")).val();
    paragraphs.push(paragraph);
  });
  commitPost(paragraphs);
  return false;
}

function clickCommitPost() {

  if(commitLock) {
    return false;
  }
  commitLock = true;
  clearTextValue();
  
  commitPost();
  return false;
}

function clickSplitArticle() {

  clearTextValue();
  var text = $("#source-text").val();
  recoverTextValue();
  
  var paragraphs = splitArticle(text);
  
  if(paragraphs.length <= 0) {
    alert("请填写申请翻译的原文。");
    return false;
  }
  paragraphsCount = paragraphs.length;
  nextId = paragraphs.length;
  
  var html = '<span>申请翻译的原文：<br/></span>';
  for(var i=0; i<paragraphs.length; ++i) {
    html += createParagraphHtml(i, paragraphs[i]);
  }
  html += '<div class="button"><a href="#" id="commit-translation">立即发表</a></div>';
  
  $("#translation-box").html(html);
  
  for(i=0; i<paragraphs.length; ++i) {
    regEvents(i);
  }
  $("#commit-translation").click(clickCommitTranslation);
  
  return false;
}

function createParagraphHtml(id, content) {
  var html = "";
  html += '<div id="paragraph-'+id+'" class="paragraph">';
  html += '<textarea id="body-'+id+'" >';
  html += content;
  html += '</textarea>';
  html += '<div style="float:right">';
  html += '<a href="#" id="insert-'+id+'">[插入新段]</a> ';
  html += '<a href="#" id="delte-'+id+'">[删除本段]</a> ';
  html += '</div><div>';
  html += '<a href="#" id="up-'+id+'">[向上移动]</a> ';
  html += '<a href="#" id="down-'+id+'">[向下移动]</a> ';
  html += '</div></div>';
  return html;
}

function regEvents(idx) {
  $("#insert-"+idx).click(function(){
    clickInsert(idx);
    return false;
  });
  $("#delte-"+idx).click(function(){
    clickDelete(idx);
    return false;
  });
  $("#up-"+idx).click(function(){
    clickUp(idx);
    return false;
  });
  $("#down-"+idx).click(function(){
    clickDown(idx);
    return false;
  });
}

function clickInsert(id) {
  var newIdx = nextId;
  paragraphsCount++;
  nextId++;
  $("#paragraph-"+id).after(createParagraphHtml(newIdx, ""));
  regEvents(newIdx);
}

function clickDelete(id) {
  var content = $("#body-"+id).val();
  if(paragraphsCount <= 1) {
    alert("这是最后一段了，不能再删除了。");
    return;
  }
  if(confirm("你确实要删除这段吗？")) {
    $("#paragraph-"+id).remove();
    paragraphsCount--;
  }
}

function clickUp(id) {
  var curr = $("#paragraph-"+id)
  var prev = curr.prev();
  if(prev.attr("id")) {
    exchange(curr, prev);
  }
}

function clickDown(id) {
  var curr = $("#paragraph-"+id)
  var next = curr.next();
  if(next.attr("id")) {
    exchange(curr, next);
  }
}

function exchange(p1, p2) {
  var t1 = $("#body-"+p1.attr("id").replace("paragraph-", ""));
  var t2 = $("#body-"+p2.attr("id").replace("paragraph-", ""));
  
  var temp = t1.val();
  t1.val(t2.val());
  t2.val(temp);
}

function splitArticle(text) {

  var arr = text.split("\n");
  var rsarr = [];
  for(var i=0; i<arr.length; ++i) {
    var content = $.trim(arr[i]);
    if(content != "") {
      rsarr.push(content);
    }
  }
  return rsarr;
}

$(function(){
  $("#btn-split-article").click(clickSplitArticle);
  $("#btn-edit").click(clickCommitEdit);
  $("#commit-topic").click(clickCommitPost);
});
