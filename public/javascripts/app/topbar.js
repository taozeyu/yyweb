var connLockButtonSet = {};
var currTipsPanel = null;
var currWillClear = false;

var isPanelRefreshing = false;

function lockButton(btnName) {
  if(connLockButtonSet[btnName]) {
    return false;
  }else{
    connLockButtonSet[btnName] = btnName;
    $(btnName).css("cursor", "wait");
    return true;
  }
}

function unlockButton(btnName) {
  delete connLockButtonSet[btnName];
  $(btnName).css("cursor", "pointer");
}

function showTipsPanel(panelId, clearAfterHide, panelInitFun) {
  if(currTipsPanel == panelId) {
    return;
  }
  if(currTipsPanel != null ) {
    hideTipsPanel(currTipsPanel, currWillClear);
  }
  currTipsPanel = panelId;
  currWillClear = clearAfterHide;
  
  var panel = $(panelId);
  panel.show();
  
  var filterFun = function(evt){
    evt.stopPropagation();
  };
  var hideFun = function(){
    panel.unbind("click", filterFun);
    $("html").unbind("click", hideFun);
    hideTipsPanel(panelId, clearAfterHide);
  };
  panel.click(filterFun);
  $("html").click(hideFun);
  $(".inside-button").click(clickInsideButton);
  
  if(panelInitFun) {
    panelInitFun(panel);
  }
}

function hideTipsPanel(panelId, clearAfterHide) {
  var panel = $(panelId);
  panel.hide();
  if(clearAfterHide) {
    panel.html("");
  }
  currTipsPanel = null;
  $("html").unbind("click");
  $(".inside-button").unbind("click");
}

function clickInsideButton() {

  if(isPanelRefreshing) {
    return false;
  }
  clearTextValue();
  var submitData = $(this).parent().serialize(),
      submitUrl = $('#top-login .submit-url').attr('href');
  recoverTextValue();
  
  console.log("params: %s", submitData);
  
  isPanelRefreshing = true;
  var url = $(this).attr("href");
  setTipsPanelWaiting($(currTipsPanel));
  if(url) {
    clickInsidHref(url);
  } else {
    var form = $('#top-login form');
    submitInsideForm(form, submitUrl, submitData);
  }
  return false;
}

function clickInsidHref(url) {
  
  $.ajax({
      type : "GET",
      url : url,
      dataType : "html",
      cache : false,
      success : onPanelCommited
  });
}

function submitInsideForm(form, url, data) {
  $.ajax({
      type : "POST",
      url : url,
      dataType : "html",
      data : data,
      cache : false,
      success : onPanelCommited
  });
}

function setTipsPanelWaiting(panel) {
  //TODO next time, I will add a waiting-icon on the panel.
  panel.html("");
}

function onPanelCommited(rs) {
  if(rs=="refresh") {
    window.location.reload();
    return;
  }
  // currTipsPanel == null means the panel was close.
  if(currTipsPanel) {
    $(currTipsPanel).html(rs);
    isPanelRefreshing = false;
    $(".inside-button").click(clickInsideButton);
    initTextNotifyEvent(); // call public.js function.
  }
}

function linkButtonToPanel(buttonId, panelId, initUrl, panelInitFun) {
  $(buttonId).click(function(){
    if(currTipsPanel == panelId) {
      return false;
    }
    if(initUrl) {
      lockButton(buttonId);
      $.ajax({
        type : "GET",
        url : initUrl,
        dateType : "html",
        cache : false,
        success : function(rs){
          unlockButton(buttonId);
          $(panelId).html(rs);
          showTipsPanel(panelId, true, panelInitFun);
          initTextNotifyEvent(); // call public.js function.
        }
      });
    } else {
      showTipsPanel(panelId, false, panelInitFun);
      initTextNotifyEvent(); // call public.js function.
    }
    return false;
  });
}

function initNotifyPanel(panel) {
    
    var closeNotifyMessage = function(notify) {
        notify.remove();
        
        var notifyNum = 0;
        panel.find('.notify').each(function() {
          notifyNum += $(this).attr('notification-message-ids').split(',').length;
        });
        $('#notification').find('span').html(notifyNum);
        
        if(notifyNum <= 0) {
            $('#notification').html('提醒<span class="gray">0</span>');
            panel.html('<div class="notify"><div class="empty">当前没有任何提醒信息。</div></div>');
        }
        var data = {
          _method : "DELETE",
          message_ids : notify.attr('notification-message-ids'),
        };
        $.ajax({
            type : "POST",
            url : '/notification/1',
            dataType : "html",
            data : data,
            cache : false,
            
        });
    };
    panel.find('.notify').each(function(){
        var notify = $(this);
        notify.find('.close').click(function() {
            
            closeNotifyMessage(notify);
            return false;
        });
        notify.find('.content').find('a').click(function() {
            
            window.open($(this).attr('href'), "_blank");
            closeNotifyMessage(notify);
            return false;
        });
    })
}

$(function(){
  linkButtonToPanel("#sign", "#top-login", "/user/loginpage");
  linkButtonToPanel("#notification", "#top-notify", "/notification", initNotifyPanel);
  linkButtonToPanel("#user", "#top-user-list");
});
