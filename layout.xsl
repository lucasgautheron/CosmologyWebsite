<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:doc="http://sciencestechniques.fr"
  exclude-result-prefixes="xs doc">
  
  <xsl:variable name="linkwords" select="//appendices/appendix/linkwords/linkword"/>
  <xsl:function name="doc:find-matching-linkword">
    <xsl:param name="cid"/>
    <xsl:param name="text"/>
    <xsl:copy-of select="(data(($linkwords[contains($text, .)])[1]/../../@id), ($linkwords[contains($text, .)])[1], data(($linkwords[contains($text, .)])[1]/../../title))"/>
  </xsl:function>
  <xsl:function name="doc:add-links" as="item()*">
    <xsl:param name="cid"/>
    <xsl:param name="text"/>
    <xsl:variable name="linkword" select="doc:find-matching-linkword($cid, $text)"/>
    <xsl:choose>
      <xsl:when test="$linkword[1]">
        <xsl:value-of select="substring-before($text, $linkword[2])"/>
        <a href="#!appendix={$linkword[1]}" class="appendix" data-rid="{$linkword[1]}" title="{$linkword[3]}"><xsl:value-of select="$linkword[2]"/></a>
        <xsl:copy-of select="doc:add-links($cid, substring-after($text, $linkword[2]))"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xsl:template match="text//text()">
    <xsl:copy-of select="doc:add-links(../@id, .)"/>
  </xsl:template>
  <xsl:template match="node()|@*">
    <xsl:copy><xsl:apply-templates select="node()|@*"/></xsl:copy>
  </xsl:template>
  
  <xsl:template match="text">
    <xsl:apply-templates />
  </xsl:template>
  
 <xsl:template match="b">
    <span style="font-weight:bold;">
      <xsl:apply-templates />
    </span>  
  </xsl:template>
  
  <xsl:template match="i">
    <span style="font-style:italic;">
      <xsl:apply-templates />
    </span>  
  </xsl:template>
  
   <xsl:template match="p">
    <p>
      <xsl:apply-templates />
    </p>  
  </xsl:template>
  
  <xsl:template match="figure">
    <div class="figure">
      <a href="/images/{./@src}" target="_blank">
        <xsl:choose>
          <xsl:when test="string(./@width)">
            <img src="/images/{./@src}" title="{.}" width="{./@width}" />
          </xsl:when>
          <xsl:otherwise>
            <img src="/images/{./@src}" title="{.}" />
          </xsl:otherwise>
        </xsl:choose>
      </a>
      <div class="label">
        <xsl:value-of select="./@title" />
        <xsl:choose>
           <xsl:when test="./@source and ./@plot">
                (<a href="/plots/{./@plot}.gnuplot">gnuplot</a> | <a href="/simulations/{./@source}.tar.gz">source</a>)
           </xsl:when>
           <xsl:when test="./@plot">
                (<a href="/plots/{./@plot}.gnuplot">gnuplot</a>)
           </xsl:when>
           <xsl:when test="./@source">
                (<a href="/simulations/{./@source}.tar.gz">source</a>)
           </xsl:when>
           </xsl:choose>
      </div>
      <div class="caption">
        <xsl:apply-templates />
      </div></div>
  </xsl:template>
  
  <xsl:template match="feynman">
    <div class="feynman" data-fid="{./@id}"><div class="diagram"></div><span class="caption"><b><xsl:value-of select="./@title" /> </b></span></div>
    <script>
      $('.feynman[data-fid="<xsl:value-of select="./@id" />"] .diagram').feyn({<xsl:value-of select="." />});
    </script>
  </xsl:template>
  
  <xsl:template match="spoiler">
    <div class="spoiler"><span><a href="#" class="spoiler_toggle" >Afficher/Masquer</a></span><div><xsl:apply-templates /></div></div>
  </xsl:template>
  
  <xsl:template match="quote">
    <div class="quote"><div><xsl:apply-templates /></div><span class="quote"><xsl:value-of select="./@author" />, <xsl:value-of select="./@date" /></span></div>
  </xsl:template>
  
  <xsl:template match="note">
    <a class="note_indicator" href="#" data-nid="{generate-id(.)}"><sup>[?]</sup></a>
  </xsl:template>
  
  <xsl:template match="video">
    <div class="video">
      <video width="{./@width}" height="{./@height}" controls="controls">
        <xsl:if test="./@mp4">
          <source src="/videos/{./@mp4}"  type='video/mp4; codecs="avc1.42E01E, mp4a.40.2"' />
        </xsl:if>
        <xsl:if test="./@webm">
          <source src="/videos/{./@webm}" type='video/webm; codecs="vp8, vorbis"' />
        </xsl:if>
      </video>
    <xsl:if test="./@source">
      (<a href="/simulations/{./@source}.tar.gz">source</a>)
    </xsl:if>
     <div class="caption">
       <xsl:apply-templates />
     </div>
   </div>
  </xsl:template>

  <xsl:template match="question">
    <p class="question"><b><xsl:value-of select="../../by/@initials" />: </b> <xsl:apply-templates /></p>
  </xsl:template>

  <xsl:template match="answer">
    <p class="answer"><b><xsl:value-of select="../../who/@initials" />: </b> <xsl:apply-templates /></p>
  </xsl:template>
  
  <xsl:template match="contentlink">
    <xsl:variable name="id" select="./@id"/>
    <a class="content-link" href="/{./@id}/" data-cid="{./@id}"><xsl:value-of select="/root/contents/content[@id=$id][1]/title" /></a>
  </xsl:template>
  
<xsl:template match="/">
  <html>
    <head>
      <title>Histoire de la Cosmologie</title>
      <meta charset="utf-8" />
      <link rel="stylesheet" type="text/css" href="/style.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script src="/feynman.js"></script>
    <script type="text/x-mathjax-config">
    MathJax.Hub.Config({
      config: ["MMLorHTML.js"],
      jax: ["input/TeX","input/MathML","input/AsciiMath","output/HTML-CSS","output/NativeMML", "output/CommonHTML"],
      extensions: ["tex2jax.js","mml2jax.js","asciimath2jax.js","MathMenu.js","MathZoom.js", "CHTML-preview.js"],
      TeX: {
        extensions: ["AMSmath.js","AMSsymbols.js","noErrors.js","noUndefined.js"]
      },
      tex2jax: {
          inlineMath: [ ['$','$'], ["\\(","\\)"] ],
          displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
          processEscapes: true
      },
      "HTML-CSS": {
          availableFonts: ["TeX"]
      }
    });
    </script>
    <script type="text/javascript"
      src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"> 
    </script>
    <script type="text/javascript" src="/navigation.js">
    </script>
    <script type="text/javascript">
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

      ga('create', 'UA-82070644-1', 'auto');
      ga('send', 'pageview');
    </script>
    </head>
    <body>
      <div id="navigation">
        <a href="/" id="show_timeline">Frise</a>
        <ul class="share-buttons">
          <li><a href="https://www.facebook.com/sharer/sharer.php?u=http%3A%2F%2Fcosmology.sciencestechniques.fr%2F&amp;t=History%20of%20Modern%20Cosmology" title="Share on Facebook" target="_blank"><img src="/images/icons/Facebook.png" /></a></li>
          <li><a href="https://twitter.com/intent/tweet?source=http%3A%2F%2Fcosmology.sciencestechniques.fr%2F&amp;text=History%20of%20Modern%20Cosmology:%20http%3A%2F%2Fcosmology.sciencestechniques.fr%2F" target="_blank" title="Tweet"><img src="/images/icons/Twitter.png" /></a></li>
          <li><a href="https://plus.google.com/share?url=http%3A%2F%2Fcosmology.sciencestechniques.fr%2F" target="_blank" title="Share on Google+"><img src="/images/icons/Google+.png" /></a></li>
          <li><a href="http://www.reddit.com/submit?url=http%3A%2F%2Fcosmology.sciencestechniques.fr%2F&amp;title=History%20of%20Modern%20Cosmology" target="_blank" title="Submit to Reddit"><img src="/images/icons/Reddit.png" /></a></li>
          <li><a href="http://www.linkedin.com/shareArticle?mini=true&amp;url=http%3A%2F%2Fcosmology.sciencestechniques.fr%2F&amp;title=History%20of%20Modern%20Cosmology&amp;summary=&amp;source=http%3A%2F%2Fcosmology.sciencestechniques.fr%2F" target="_blank" title="Share on LinkedIn"><img src="/images/icons/LinkedIn.png" /></a></li>
      </ul>
        Cette version est une <b>ébauche</b>. L'avancement de la relecture est disponible <a href="graph.html" target="_blank">ici</a>.
      </div>
      <div id="timeline-container">
      <h1>Histoire de la Cosmologie Moderne</h1>
        <ul id="timeline">
          <xsl:for-each select="root/events/event[not(@hidden=1)]">
            <xsl:sort select="./@date" />
            <xsl:variable name="cid" select="./@content-id"/>
            <xsl:if test="/root/contents/content[@uid=$cid][1]/color">            
            <style type="text/css">#timeline<xsl:value-of select="generate-id(.)" />.timeline-content:before { background-color: <xsl:value-of select="/root/contents/content[@uid=$cid][1]/color" />;}</style>
            </xsl:if>
            <li><p class="timeline-date"><xsl:value-of select="./@date" /></p><div id="timeline{generate-id(.)}" class="timeline-content"><a class="content-link" href="/{/root/contents/content[@uid=$cid][1]/@id}"><xsl:value-of select="." /></a></div></li>
          </xsl:for-each>
        </ul>

        <div class="meta">
          <h2>Activités</h2>
          <ul id="activities">
            <xsl:for-each select="/root/contents/content[@type='activity']">
              <li><a class="content-link" href="/{./@content-id}/"><xsl:value-of select="./title" /></a></li>
            </xsl:for-each>
          </ul>
        </div>

        <div class="meta">Les conventions suivantes sont utilisées :
          <ul>
            <li>Signature métrique $(+,-,-,-)$</li>
            <li>$c$ apparait explicitement dans les équations (les distances sont donc exprimées en mètres et les temps en secondes) sauf mention contraire</li>
            <li>L'origine du temps cosmologique $t=0$ correspond au temps actuel (la coordonnée $t$ du big bang est donc égale à l'opposé de l'âge de l'Univers)</li>
            <li>Pour un univers homogène et isotrope, $R$ est le rayon de courbure de l'Univers, et $k$ un entier relatif pouvant valoir $-1$ (géométrie sphérique), $0$ (géométrie euclidienne), $1$ (géométrie hyperbolique)</li>
          </ul>
        </div>

        <div class="meta">
          Le site fait appel aux technologies et programmes suivants :
          <ul>
            <li><a href="http://www.w3schools.com/xml/xml_xsl.asp">XML/XSLT</a> pour le contenu et sa traduction en HTML</li>
            <li><a href="https://www.mathjax.org/">MathJax</a> pour les équations LaTeX</li>
            <li><a href="http://photino.github.io/jquery-feyn">JQuery Feyn</a> pour les diagrammes de Feynman</li>
            <li><a href="http://gnuplot.sourceforge.net/">Gnuplot</a> pour les plots</li>
            <li><a href="https://root.cern.ch/">ROOT</a> et le langage C pour les simulations</li>
            <li><a href="http://github.com/">github</a> pour la gestion du projet</li>
          </ul>
        </div>
        <div>
          Pour signaler toute erreur, ou simplement pour poser des questions relatives au contenu, vous pouvez : 
          <ul>
            <li><a href="https://github.com/lucasgautheron/CosmologyWebsite">Enregistrer un ticket sur github</a></li>
            <li><a href="mailto:lucas.gautheron@gmail.com">Envoyer un email à l'adresse</a> lucas <i>dot</i> gautheron <i>at</i> gmail <i>dot</i> com</li>
          </ul>
        </div>

      </div>
      
      <div id="content">
        <h2 class="title"></h2>
        <div id="horizontal-timeline"></div>
        <div class="text"></div>
        <div class="interviews"></div>
        <div class="references"></div>
      </div>
      
      <div id="appendix">
        <h2 class="title"></h2>
        <div class="text"></div>
        <div class="references"></div>
      </div>
      
        <div id="image"></div>

    <div class="clear"></div>
    </body>
  </html>

<xsl:for-each select="root/contents/content">
 <xsl:variable name="uid" select="./@uid"/>
<xsl:result-document method="html" href="./{./@id}/index.html">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
  <html>
    <head>
      <title>Histoire de la Cosmologie</title>
      <meta charset="utf-8" />
      <link rel="stylesheet" type="text/css" href="/style.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script src="/feynman.js"></script>
    <script type="text/x-mathjax-config">
    MathJax.Hub.Config({
      config: ["MMLorHTML.js"],
      jax: ["input/TeX","input/MathML","input/AsciiMath","output/HTML-CSS","output/NativeMML", "output/CommonHTML"],
      extensions: ["tex2jax.js","mml2jax.js","asciimath2jax.js","MathMenu.js","MathZoom.js", "CHTML-preview.js"],
      TeX: {
        extensions: ["AMSmath.js","AMSsymbols.js","noErrors.js","noUndefined.js"]
      },
      tex2jax: {
          inlineMath: [ ['$','$'], ["\\(","\\)"] ],
          displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
          processEscapes: true
      },
      "HTML-CSS": {
          availableFonts: ["TeX"]
      }
    });
    </script>
    <script type="text/javascript"
      src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"> 
    </script>
    <script type="text/javascript" src="/navigation.js">
    </script>
    <script type="text/javascript">
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

      ga('create', 'UA-82070644-1', 'auto');
      ga('send', 'pageview');
    </script>
    </head>
    <body>
      <div id="navigation">
        <a href="/" id="show_timeline">Frise</a> |
        <xsl:if test="./preceding-sibling::content[1]/@id">
          <a href="/{./preceding-sibling::content[1]/@id}">Précédent</a> |
        </xsl:if>
        <xsl:if test="./following-sibling::content[1]/@id">
          <a href="/{./following-sibling::content[1]/@id}">Suivant</a> |
        </xsl:if>
        <ul class="share-buttons">
          <li><a href="https://www.facebook.com/sharer/sharer.php?u=http%3A%2F%2Fcosmology.sciencestechniques.fr%2F&amp;t=History%20of%20Modern%20Cosmology" title="Share on Facebook" target="_blank"><img src="/images/icons/Facebook.png" /></a></li>
          <li><a href="https://twitter.com/intent/tweet?source=http%3A%2F%2Fcosmology.sciencestechniques.fr%2F&amp;text=History%20of%20Modern%20Cosmology:%20http%3A%2F%2Fcosmology.sciencestechniques.fr%2F" target="_blank" title="Tweet"><img src="/images/icons/Twitter.png" /></a></li>
          <li><a href="https://plus.google.com/share?url=http%3A%2F%2Fcosmology.sciencestechniques.fr%2F" target="_blank" title="Share on Google+"><img src="/images/icons/Google+.png" /></a></li>
          <li><a href="http://www.reddit.com/submit?url=http%3A%2F%2Fcosmology.sciencestechniques.fr%2F&amp;title=History%20of%20Modern%20Cosmology" target="_blank" title="Submit to Reddit"><img src="/images/icons/Reddit.png" /></a></li>
          <li><a href="http://www.linkedin.com/shareArticle?mini=true&amp;url=http%3A%2F%2Fcosmology.sciencestechniques.fr%2F&amp;title=History%20of%20Modern%20Cosmology&amp;summary=&amp;source=http%3A%2F%2Fcosmology.sciencestechniques.fr%2F" target="_blank" title="Share on LinkedIn"><img src="/images/icons/LinkedIn.png" /></a></li>
      </ul>
        Cette version est une <b>ébauche</b>. L'avancement de la relecture est disponible <a href="graph.html" target="_blank">ici</a>.
      </div>
      
    <div id="content">
      <div id="horizontal-timeline">
        <ul>
        <xsl:for-each select="/root/events/event[@content-id=$uid]">
          <xsl:sort select="./@date" />
          <li><b><xsl:value-of select="./@date" /></b> : <xsl:value-of select="." /></li>
        </xsl:for-each>
        </ul>
      </div>
      <h2 class="title"><xsl:value-of select="./title" /></h2>
      <div class="text"><xsl:apply-templates select="text" />
        <xsl:for-each select="./text//note">
          <div class="note" data-nid="{generate-id(.)}"><xsl:apply-templates /></div>
        </xsl:for-each></div>

      <div class="interviews">
        <xsl:for-each select="./interviews/interview">
          <div class="interview" id="{generate-id(.)}">
            <div class="interview_short">
              <img src="/images/{./who/@src}" />
              <div class="description">
                <span class="who"><xsl:value-of select="./who/@name" /></span>.
                <xsl:value-of select="./description" />.<br /><a href="#" class="interview-link" data-iid="{generate-id(.)}">Lire l'interview</a>.</div>
            </div>
            <div class="interview_content">
              <xsl:if test="./record">
                <h4>Interview record (<xsl:value-of select="./record/@language" />)</h4>
                <div class="interview_record">
                  <audio controls="controls">
                    <source src="records/{./record}.ogg" type="audio/ogg" />
                    <source src="records/{./record}.mp3" type="audio/mpeg" />
                    Your browser does not support the audio element.
                  </audio> 
                </div>
              </xsl:if>
              <h4>Script</h4>
              <xsl:apply-templates select="questions" />
            </div>
          </div>
        </xsl:for-each>
      </div>
    
      <div class="references">
        <ul>
          <xsl:for-each select="./references/reference">
            <xsl:sort select="./date" />
            <li><i><a href="references/{./file}" target="_blank" title="{./text}"><xsl:value-of select="./title" /></a></i>, <xsl:value-of select="./author" /> (<xsl:value-of select="./date" />)</li>
          </xsl:for-each>
        </ul>
      </div>
      </div>
      
      <div id="appendix">
        <h2 class="title"></h2>
        <div class="text"></div>
        <div class="references"></div>
      </div>

      <div id="image">
        <img src="/images/{./image/@src}" />
        <span class="caption"><xsl:value-of select="./image/." /></span>
      </div>
    <div class="clear"></div>
    </body>
  </html>
</xsl:result-document>
</xsl:for-each>
  
<xsl:for-each select="root/appendices/appendix">
  <xsl:variable name="id" select="./@id"/>
  <xsl:result-document method="html" href="./appendices/{./@id}/index.html">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
<html lang="fr">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  </head>
  <body>
    <div id="appendix">
      <h2 id="title"><xsl:value-of select="./title" /></h2>
      <div id="text"><xsl:apply-templates select="text" />
      <xsl:for-each select="./text//note">
        <div class="note" data-nid="{generate-id(.)}"><xsl:apply-templates /></div>
      </xsl:for-each></div>
      <div id="references">
        <ul>
          <xsl:for-each select="/root/references/reference[@appendix-id=$id]">
            <xsl:sort select="./date" />
            <li><i><a href="references/{./file}" target="_blank"><xsl:value-of select="./title" /></a></i>, <xsl:value-of select="./author" /> (<xsl:value-of select="./date" />)</li>
          </xsl:for-each>
        </ul>
      </div>
    </div>
  </body>
</html>
  </xsl:result-document>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
