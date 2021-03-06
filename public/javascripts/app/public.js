var clearTextValueArray = [];
var recoverTextValueArray = []

function initTextNotifyEvent() {
  $(".textarea-notify").each(function(){
    if($(this).data("events")) {
      if($(this).data("events")["focus"]) {
        alert("has register:: "+$(this).val());
        return; //means it has been init.
      }
    }
    var emptyValue = $(this).val();
    var isEmpty = true;
    var text = $(this);
    
    text.focus(function(){
      if(isEmpty) {
        text.val("");
        text.removeClass("textarea-notify");
      }
    });
    text.blur(function(){
      if($(this).val()=="") {
        isEmpty = true;
        text.val(emptyValue);
        text.addClass("textarea-notify");
      } else {
        isEmpty = false;
      }
    });
    clearTextValueArray.push(function(){
      if(isEmpty && text.val()==emptyValue) {
        text.val("");
      }
    });
    recoverTextValueArray.push(function(){
      if(isEmpty) {
        if(text.val()=="") {
          text.val(emptyValue);
        } else {
          isEmpty = false;
          text.removeClass("textarea-notify");
        }
      } else if(text.val()=="") {
        isEmpty = true;
        text.addClass("textarea-notify");
      }
    });
  });
}

function clearTextValue() {
  for(var i=0; i<clearTextValueArray.length; ++i) {
    clearTextValueArray[i]();
  }
}

function recoverTextValue() {
  for(var i=0; i<recoverTextValueArray.length; ++i) {
    recoverTextValueArray[i]();
  }
}

function initMoveAddArea() {

    var addArea = $('#add-area');
    if(addArea.length <= 0) { return; }
    
    var marginLeft = parseInt(addArea.css('margin-left').match(/\d+/)[0]);
    
    $(window).scroll(function(){
        addArea.css({
            'margin-left': (marginLeft - $(this).scrollLeft())+'px'
        });
    });
};

$(function(){
  initTextNotifyEvent();
  initMoveAddArea();
});
