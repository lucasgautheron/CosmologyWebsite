var current_content = null;
var current_appendix = null;

$(document).ready(function() {
  $("a.content-link").click(function() {
      show_content($(this).data('cid'), true);
      return false;
  });
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
  $("#show_timeline").click(function() {
      show_timeline();
      update_hash();
      return false;
  });
  $("#show_previous").click(function() {
      show_previous();
      return false;
  });
  $("#show_next").click(function() {
      show_next();
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
    if(window.history && window.history.pushState) window.history.pushState({content_id: current_content, appendix_id: current_appendix, randomData: window.Math.random()}, "", url);
  }
});

function update()
{
    $("a.content-link").unbind("click");
    $("a.content-link").click(function() {
      show_content($(this).data('cid'), true);
      return false;
    });
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
    if(current_content!=null)
    {
        if(current_appendix!=null)
        {
            url = '#!content=' + current_content + '&appendix=' + current_appendix;
        }
        else url = '#!content=' + current_content;
    }
    return url;
}

function update_hash()
{
    var url = build_hash();
    if(window.history && window.history.pushState) window.history.pushState({content_id: current_content, appendix_id: current_appendix}, "", url);
    else window.location.hash = url;
}

function load_hash()
{

   var subject = window.location.hash.substring(2);
   var data = subject?JSON.parse('{"' + subject.replace(/&/g, '","').replace(/=/g,'":"') + '"}',
                 function(key, value) { return key===""?value:decodeURIComponent(value) }):{};

    if(!data || data['content'] === undefined)
    {
        show_timeline();
        return;
    }
    data['content'] = data['content'] === undefined ? null : data['content'];
    data['appendix'] = data['appendix'] === undefined ? null : data['appendix'];

    var new_content = current_content != data['content'];
    var new_appendix = current_appendix != data['appendix'];
    var change = new_content || new_appendix;
    current_content = data['content'];
    current_appendix = data['appendix'];
    if(change)
    {
        if(!current_content && !current_appendix) show_timeline();
        else
        {
            if(current_content != null)
            {
                if(new_content) show_content(current_content, false);
            }
            else hide_content();
            if(current_appendix != null)
            {
                 if(new_appendix) show_appendix(current_appendix, false);
            }
            else
            {
                hide_appendix();
                if(current_content) $('#image').show();
            }
        }
    }
}

function show_timeline()
{
  hide_content();
  hide_appendix();
  //$("#show_timeline").hide();
  $("#timeline-container").show();
}

function hide_timeline()
{
  $("#timeline-container").hide();
  //$("#show_timeline").show();
}

function show_previous()
{
    var index = parseInt(current_content);
    show_content(index > 1 ? index-1 : 1, true);
}

function show_next()
{
    var index = parseInt(current_content);
    show_content(index > 0 ? index+1 : 1, true);
}

function show_content(id, updatehash)
{
  $.ajax({
    url: 'html/contents/content_' + id + '.html',
    type: 'GET',
    cache: false, // disable when ready
    success: function(data) {
      current_content = id;
      if(updatehash) update_hash();
      hide_timeline();
      $('#image').hide();
      data_object = $($.parseHTML(data, document, true)); 
      $('#content #horizontal-timeline').html(data_object.find('#horizontal-timeline').html());
      $('#content .title').text(data_object.find('#title').text());
      $('#content .text').html(data_object.find('#text').html());
      $('#content .interviews').html(data_object.find('#interviews').html());
      $('#content .references').html(data_object.find('#references').html());
      $('#image').html(data_object.find('#image').html());
      if(!current_appendix) $('#image').show();
      $('#content').show();
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

function hide_content(id)
{
  current_content = null;
  $("#image").hide();
  $("#content").hide();
}

function show_appendix(id, updatehash)
{
  hide_timeline();
  $.ajax({
    url: 'html/appendices/appendix_' + id + '.html',
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
