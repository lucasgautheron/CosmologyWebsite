var current_appendix = null;

$(document).ready(function() {
  $("div.interview_content").hide();

  $("a.interview-link").click(function() {
      $("div#" + $(this).data('iid') + " div.interview_content").show();
      return false;
  });
  $("a.appendix").click(function() {
      show_appendix($(this).data('rid'), true);
      return false;
  });
  $("div.spoiler a.spoiler_toggle").click(function() {
      $(this).parent().parent().find("div").toggle();
      return false;
  });
  $("a.note_indicator").click(function(event) {
         var x = event.pageX,
             y = event.pageY;
         var div = $("div.note[data-nid='" + $(this).data('nid') + "']");
         div.css({top: y+20, left: x+10});
         div.toggle();
         return false;
    });
   $("body").click(function() { $("div.note").hide(); });

  load_hash();
  window.onhashchange = load_hash;

  if(window.history && window.history.pushState) {
    $(window).on('popstate', function(event) {
      if(!!event.state) load_hash();
    });
    var url = build_hash();
    if(window.history && window.history.pushState) window.history.pushState({appendix_id: current_appendix, randomData: window.Math.random()}, "", url);
  }
});

function update()
{
    $("a.interview-link").unbind("click");
    $("a.interview-link").click(function() {
      $("div#" + $(this).data('iid') + " div.interview_content").show();
      return false;
    });
    $("a.appendix").unbind("click");
    $("a.appendix").click(function() {
         show_appendix($(this).data('rid'), true);
         return false;
    });
    $("div.spoiler a.spoiler_toggle").unbind();
    $("div.spoiler a.spoiler_toggle").click(function() {
         $(this).parent().parent().find("div").toggle();
         return false;
    });
    $("a.note_indicator").unbind();
    $("a.note_indicator").click(function(event) {
         var x = event.pageX,
             y = event.pageY;
         var div = $("div.note[data-nid='" + $(this).data('nid') + "']");
         div.css({top: y-10, left: x+10});
         div.toggle();
         return false;
    });
    $("body").unbind();
    $("body").click(function() { $("div.note").hide(); });
    MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
}

function build_hash()
{
    var url = '#!';
    if(current_appendix!=null)
    {
        url = '#!appendix=' + current_appendix;
    }
    return url;
}

function update_hash()
{
    var url = build_hash();
    if(window.history && window.history.pushState) window.history.pushState({appendix_id: current_appendix}, "", url);
    else window.location.hash = url;
}

function load_hash()
{

   var subject = window.location.hash.substring(2);
   var data = subject?JSON.parse('{"' + subject.replace(/&/g, '","').replace(/=/g,'":"') + '"}',
                 function(key, value) { return key===""?value:decodeURIComponent(value) }):{};

    data['appendix'] = data['appendix'] === undefined ? null : data['appendix'];

    var new_appendix = current_appendix != data['appendix'];
    var change = new_appendix;
    current_appendix = data['appendix'];
    if(change)
    {
        if(current_appendix != null)
        {
             if(new_appendix) show_appendix(current_appendix, false);
        }
        else
        {
            hide_appendix();
            $('#image').show();
        }
    }
    }
}

function show_appendix(id, updatehash)
{
  $.ajax({
    url: '/appendices/' + id + '/index.html',
    type: 'GET',
    cache: false, // disable when ready
    success: function(data) {
      current_appendix = id;
      if(updatehash) update_hash();
      data_object = $($.parseHTML(data, document, true)); 
      $('#appendix .title').text(data_object.find('#title').text());
      $('#appendix .text').html(data_object.find('#text').html());
      $('#appendix .references').html(data_object.find('#references').html());
      $('#image').hide();
      $('#appendix').show();
      data_object.find('#text script').each(function(){
        $.globalEval(this.innerHTML);
      });
      setTimeout(update, 100);
    },
    error: function(e) {
      console.log(e.message);
    }
  });
}

function hide_appendix(id)
{
  current_appendix = null;
  $("#appendix").hide();
}
