
function clickPraise() {
  if(praiseId) {
    sendCancelMsg("/post_praise/", praiseId, function(){
      $("#txt-praise").html("赞");
      $("#btn-praise").children("div").attr("class", "operation");
      $("#count-praise").html(parseInt($("#count-praise").html()) - 1);
      unlockButton("#btn-praise");
      praiseId = null;
    });
  } else {
    sendAddMsg("/post_praise/", function(id){
      $("#txt-praise").html("取消赞");
      $("#btn-praise").children("div").attr("class", "operation-cancel");
      $("#count-praise").html(parseInt($("#count-praise").html()) + 1);
      unlockButton("#btn-praise");
      praiseId = id;
    });
  }
}

function clickAttention() {
  if(attentionId) {
    sendCancelMsg("/post_attention/", attentionId, function(){
      $("#txt-attention").html("关注");
      $("#btn-attention").children("div").attr("class", "operation");
      $("#count-attention").html(parseInt($("#count-attention").html()) - 1);
      unlockButton("#btn-attention");
      attentionId = null;
    });
  } else {
    sendAddMsg("/post_attention/", function(id){
      $("#txt-attention").html("取消关注");
      $("#btn-attention").children("div").attr("class", "operation-cancel");
      $("#count-attention").html(parseInt($("#count-attention").html()) + 1);
      unlockButton("#btn-attention");
      attentionId = id;
    });
  }
}

function sendAddMsg(url, success) {
  var data = {
    id : postId
  };
  $.ajax({
      type : "POST",
      url : url,
      dataType : "html",
      data : data,
      cache : false,
      success : function(rs){
         if(rs!="error") {
            success(rs);
         } else {
            alert("错误："+rs);
         }
      }
  });
}

function sendCancelMsg(url, id, success) {
  var data = {
    _method :"delete"
  };
  $.ajax({
      type : "POST",
      url : url+id,
      dataType : "html",
      data : data,
      cache : false,
      success : function(rs){
         if(rs!="error") {
            success();
         } else {
            alert("错误："+rs);
         }
      }
  });
}

$(function(){

  console.log($("#btn-attention"));

  $("#btn-attention").click(function(){
    console.log('attention');
    if(lockButton("#btn-attention")) {
      clickAttention();
    }
    return false;
  });
  $("#btn-praise").click(function() {
    if(lockButton("#btn-praise")) {
      clickPraise();
    }
    return false;
  });
});
