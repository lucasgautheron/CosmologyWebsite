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
          <xsl:choose>
            <xsl:when test="$cid">
              <a href="/{$cid}/{$linkword[1]}/" class="appendix" data-rid="{$linkword[1]}" title="{$linkword[3]}"><xsl:value-of select="$linkword[2]"/></a>
            </xsl:when>
            <xsl:otherwise>
              <a href="#!appendix={$linkword[1]}" class="appendix" data-rid="{$linkword[1]}" title="{$linkword[3]}"><xsl:value-of select="$linkword[2]"/></a>
            </xsl:otherwise>
          </xsl:choose>
        <xsl:copy-of select="doc:add-links($cid, substring-after($text, $linkword[2]))"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xsl:template match="text//text()">
    <xsl:copy-of select="doc:add-links(ancestor::content/@id, .)"/>
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

  <xsl:template name="common-header">
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
  </xsl:template>
  
<xsl:template match="/">
  <html>
    <head>
      <xsl:call-template name="common-header"/>
      <title>Chronologie - Histoire de la Cosmologie</title>
    </head>
    <body>
      <div id="navigation">
        <a href="/" id="show_timeline">Frise</a> |
        <a href="/a-propos/">A propos du site</a> | 
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
        <div class="meta">
          Pour signaler toute erreur, ou simplement pour poser des questions relatives au contenu, vous pouvez : 
          <ul>
            <li><a href="https://github.com/lucasgautheron/CosmologyWebsite">Enregistrer un ticket sur github</a></li>
            <li><a href="mailto:lucas.gautheron@gmail.com">Envoyer un email à l'adresse</a> lucas <i>dot</i> gautheron <i>at</i> gmail <i>dot</i> com</li>
          </ul>
        </div>

      </div>
    <div class="clear"></div>
    </body>
  </html>

<xsl:result-document method="html" href="a-propos/index.html">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
  <html>
    <head>
      <xsl:call-template name="common-header" />
      <title>A propos - Histoire de la Cosmologie</title>
    </head>
    <body>
      <div id="navigation">
        <a href="/" id="show_timeline">Frise</a> |
        <a href="/a-propos/">A propos du site</a> | 
        Cette version est une <b>ébauche</b>. L'avancement de la relecture est disponible <a href="graph.html" target="_blank">ici</a>.
      </div>

      <div class="meta">
        <h1>Histoire de la Cosmologie Moderne </h1>
        <h2>Qu'est-ce que la cosmologie ?</h2>
        <p>
          La cosmologie est le domaine de la physique qui se préoccupe de l'Univers à grande échelle, de sa dynamique globale, de son contenu.
        </p>


        <h2>Pourquoi la cosmologie ?</h2>
        <p>
          D'abord, elle a la première qualité d'être une synthèse de toute la physique moderne. Donc, étudier la cosmologie et ses enjeux, cela implique d'aborder la relativité générale, la physique statistique et la thermodynamique, la théorie quantique des champs, le modèle standard, et même certaines de ses extensions. C'est en partie pour ces raisons, et également grâce à la grande richesse des conditions physiques offertes au cours du Big Bang, que l'on compte beaucoup à l'avenir sur la cosmologie pour nous donner des indications expérimentales afin de mesurer la réalité physique de théories non testables autrement.
          Donc, la cosmologie ouvre à de nombreux pans de la physique, et les recherches qui y sont consacrées peuvent potentiellement améliorer considérablement notre vision de la nature dans le futur.
        </p>
        <p>
          Par ailleurs, l'histoire de la cosmologie représente en elle-même un sujet passionnant. Il est fascinant de voir comment notre conception de l'Univers a radicalement changé en un siècle, au fil de divers rebondissements et révolutions majeures, parfois accidentellement. C'est aussi un bon sujet pour la sociologie des sciences, tant la nouveauté des idées physiques soulevées et leurs enjeux ont pu déstabiliser et susciter parfois des débats d'ordre philosophiques. Aujourd'hui encore, cette science jeune mais très prometteuse suscite parfois des controverses.
        </p>

        <h2>Pourquoi ce site ?</h2>
        <p>
          A l'origine, le projet a été lancé durant un stage que j'ai effectué au LAPTh, et supervisé par <a href="#richard-taillet">Richard Taillet</a>. Alors en pleine préparation de nouveaux <a href="http://podcast.grenet.fr/podcast/cours-de-cosmologie/">cours au format vidéo sur la cosmologie</a>, il m'avait suggéré de réaliser une sorte de frise chronologique des événements clés de la cosmologie moderne, sous un format à définir, éventuellement un site Internet. J'ai alors réfléchi à une mise en page qui rende l'essentiel accessible à un public plutôt large (mais au moins des étudiants de première année) tout en permettant à ceux qui le souhaitent d'approfondir certaines notions au cours de la lecture sans en interrompre le flux. Conformément à l'idée initiale, la navigation est centrée sur une frise chronologique qui énumère des événements marquants de l'histoire de la cosmologie. 
        </p>

        <h2>Comment naviguer ?</h2>
        <p>
          <ul>
            <li>Le point de départ est bien-sûr la <a href="/">frise chronologique</a>.</li>
            <li>Chaque <b>événement</b> marquant est relié à un <b>article</b> décrivant une page associée de l'histoire de la cosmologie.</li>
            <li>Des mots-clés cliquables permettent d'avoir accès à des <b>annexes</b> développant un aspect en particulier, en parallèle du contenu principal (à sa droite).</li>
          </ul>
        </p>

        <h2>Que peut-on trouver d'original ?</h2>
        <p>
          <ul>
            <li>Les <b>annexes</b> couvrent de nombreux domaines de la physique. Leur construction permet au site d'être enrichi progressivement.</li>
            <li>Autant que possible, les <b>graphiques</b> ont été produits spécialement pour le site, et le <b>code</b> des simulations utilisé pour les générer est <b>téléchargeable</b>.</li>
            <li>Des <b>interviews</b> de physiciens permettent de mieux saisir les enjeux de la recherche actuelle, et le travail concret de chercheur.</li>
            <li>Des liens vers des <b>papiers</b> ayant joué un rôle important sont proposés, et leur lecture est très riche d'enseignement sur la pensée de leurs auteurs à l'époque de leur écriture.</li>
          </ul>
        </p>

        <h2>Qui est l'auteur ?</h2>
        <div class="interview">
          <div class="interview_short">
           <img src="/images/people/lucas_gautheron.jpg" />
           <div class="description"><span class="who">Lucas Gautheron</span>. 
             Actuellement étudiant en physique à l'ENS de Cachan (M1), originaire de Haute-Savoie, mes intérêts portent principalement sur la physique des particules et l'astrophysique. Je travaille sur plusieurs projets open-source, disponibles tout comme mes simulations sur <a href="http://github.com/lucasgautheron/">github</a>.
           </div>
          </div>
        </div>


        <h2>Remerciements</h2>
        <p>
          <ul>
            <li><a name="richard-taillet"></a><b><a href="http://lapth.cnrs.fr/pg-nomin/taillet/">Richard Taillet</a></b> bien sûr, qui m'a encadré pendant plusieurs mois et qui a permis de lancer ce projet.</li>
            <li><b><a href="https://www.scalawilliam.com/">William Vykintas Narmontas</a></b>, pour ses précieux conseils lors de la réalisation technique du site.</li>
            <li><b><a href="http://www.coepp.org.au/people/martin-white">Martin White</a></b>, qui a accepté de répondre à mes questions, malgré un calendrier chargé.</li>
            <li>Le <a href="http://lapth.in2p3.fr/">LAPTh</a>, le <a href="http://lapp.in2p3.fr/">LAPP</a> et le <a href="http://lpnhe.in2p3.fr/">LPNHE</a> pour leur accueil.</li>
          </ul>
        </p>
      </div>

    <div class="clear"></div>
    </body>
  </html>
</xsl:result-document>

<xsl:for-each select="root/contents/content">
 <xsl:variable name="uid" select="./@uid"/>
<xsl:result-document method="html" href="./{./@id}/index.html">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
  <html>
    <head>
      <xsl:call-template name="common-header" />
      <title><xsl:value-of select="./title" /> - Histoire de la Cosmologie</title>
    </head>
    <body>
      <div id="navigation">
        <a href="/" id="show_timeline">Frise</a> |
        <a href="/a-propos/">A propos du site</a> | 
        <xsl:if test="./preceding-sibling::content[1]/@id">
          <a href="/{./preceding-sibling::content[1]/@id}">Précédent</a> |
        </xsl:if>
        <xsl:if test="./following-sibling::content[1]/@id">
          <a href="/{./following-sibling::content[1]/@id}">Suivant</a> |
        </xsl:if>
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
      
      <div id="appendix" class="hidden">
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

<xsl:for-each select="//root/contents/content">
<xsl:variable name="pagecontent" select="."/>
<xsl:variable name="cuid" select="./@uid"/>
<xsl:for-each select="//root/appendices/appendix">
<xsl:variable name="appendixcontent" select="."/>
<xsl:result-document method="html" href="./{$pagecontent/@id}/{$appendixcontent/@id}/index.html">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
  <html>
    <head>
      <xsl:call-template name="common-header"/>
      <title><xsl:value-of select="$pagecontent/title" /> - Histoire de la Cosmologie</title>
    </head>
    <body>
      <div id="navigation">
        <a href="/" id="show_timeline">Frise</a> |
        <a href="/a-propos/">A propos du site</a> | 
        <xsl:if test="$pagecontent/preceding-sibling::content[1]/@id">
          <a href="/{$pagecontent/preceding-sibling::content[1]/@id}">Précédent</a> |
        </xsl:if>
        <xsl:if test="$pagecontent/following-sibling::content[1]/@id">
          <a href="/{$pagecontent/following-sibling::content[1]/@id}">Suivant</a> |
        </xsl:if>
        Cette version est une <b>ébauche</b>. L'avancement de la relecture est disponible <a href="graph.html" target="_blank">ici</a>.
      </div>
      
    <div id="content">
      <div id="horizontal-timeline">
        <ul>
        <xsl:for-each select="/root/events/event[@content-id=$cuid]">
          <xsl:sort select="./@date" />
          <li><b><xsl:value-of select="./@date" /></b> : <xsl:value-of select="." /></li>
        </xsl:for-each>
        </ul>
      </div>
      <h2 class="title"><xsl:value-of select="$pagecontent/title" /></h2>
      <div class="text"><xsl:apply-templates select="$pagecontent/text" />
        <xsl:for-each select="$pagecontent/text//note">
          <div class="note" data-nid="{generate-id(.)}"><xsl:apply-templates /></div>
        </xsl:for-each></div>

      <div class="interviews">
        <xsl:for-each select="$pagecontent/interviews/interview">
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
          <xsl:for-each select="$pagecontent/references/reference">
            <xsl:sort select="./date" />
            <li><i><a href="references/{./file}" target="_blank" title="{./text}"><xsl:value-of select="./title" /></a></i>, <xsl:value-of select="./author" /> (<xsl:value-of select="./date" />)</li>
          </xsl:for-each>
        </ul>
      </div>
      </div>
      
      <div id="appendix">
      <h2 class="title"><xsl:value-of select="$appendixcontent/title" /></h2>
      <xsl:variable name="appendixtext">
        <content id="{$pagecontent/@id}">
          <text><xsl:copy-of select="$appendixcontent/text"/></text>
        </content>
      </xsl:variable>
      <div class="text"><xsl:apply-templates select="$appendixtext/content/text" />
      <xsl:for-each select="$appendixcontent/text//note">
        <div class="note" data-nid="{generate-id(.)}"><xsl:apply-templates /></div>
      </xsl:for-each></div>
      </div>

      <div id="image">
        <img src="/images/{./image/@src}" />
        <span class="caption"><xsl:value-of select="$pagecontent/image/." /></span>
      </div>
    <div class="clear"></div>
    </body>
  </html>
</xsl:result-document>
</xsl:for-each>
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
    </div>
  </body>
</html>
  </xsl:result-document>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
