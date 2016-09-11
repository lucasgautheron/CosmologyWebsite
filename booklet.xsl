<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:doc="http://cosmology.education"
  xmlns:shell="java:java.lang.Runtime"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  exclude-result-prefixes="xs doc">
  <xsl:output encoding="UTF-8" method="text" omit-xml-declaration="yes" indent="no"/>
  
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
        \hyperref[ann:<xsl:value-of select="$linkword[1]" />]{<xsl:value-of select="$linkword[2]" />}
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
    
   <xsl:template match="h3">
       \section{<xsl:value-of select="." />}
   </xsl:template>
    
    <xsl:template match="h4">
        \subsection{<xsl:value-of select="." />}
    </xsl:template>
    
    <xsl:template match="h5">
        \subsubsection{<xsl:value-of select="." />}
    </xsl:template>
  
  <xsl:template match="text">
    <xsl:apply-templates />
  </xsl:template>
  
  <xsl:template match="b">\textbf{<xsl:apply-templates />}</xsl:template>
  
  <xsl:template match="i">\textit{<xsl:apply-templates />}</xsl:template>
  
   <xsl:template match="p">
    
      <xsl:apply-templates />
      
  </xsl:template>
    
  <xsl:template match="a">\href{<xsl:value-of select="./@href" />}{<xsl:value-of select="." />}</xsl:template>
  
  <xsl:template match="ref[@doi]"><xsl:variable name="safedoi" select="replace(replace(replace(./@doi, '/', '_'), '\(', '_'), '\)', '_')" />\cite{ref-<xsl:value-of select="$safedoi" />}</xsl:template>
  
  <xsl:template match="ref[@isbn]">\cite{ref-<xsl:value-of select="./@isbn" />}</xsl:template>
  
  <xsl:template name="ref-description">
    <xsl:param name="doi" />
    <xsl:param name="isbn" />
    
    <xsl:variable name="maxauthors" select="4" />
    
    <xsl:choose>
      <xsl:when test="$doi">
        <xsl:variable name="safedoi" select="replace(replace(replace(./@doi, '/', '_'), '\(', '_'), '\)', '_')" />
        <xsl:variable name="ref" select="document(concat('./tmp/ref_', $safedoi, '.xml'))" />
        
        @article{ref-<xsl:value-of select="$safedoi" />,
        title = "<xsl:value-of select="$ref//journal_article/titles/title[1]" />",
        author = "<xsl:for-each select="$ref//contributors/person_name[@contributor_role='author'][position() &lt;= $maxauthors]">
            <xsl:value-of select="./given_name" />&#160;<xsl:value-of select="./surname" />
            <xsl:if test="position() != last() and not(position() >= $maxauthors) ">, </xsl:if>
        </xsl:for-each>
          <xsl:if test="count($ref//contributors/person_name[@contributor_role='author']) > $maxauthors">
              et al.
          </xsl:if>",
          year = "<xsl:value-of select="$ref/doi_records/doi_record/crossref/journal/journal_article/publication_date[1]/year" />"
        }
      </xsl:when>
      <xsl:when test="$isbn">
          <xsl:variable name="ref" select="document(concat('./tmp/ref_', $isbn, '.xml'))//fn:map[@key='volumeInfo'][1]" />
        @book{ref-<xsl:value-of select="$isbn" />,
          title = "<xsl:value-of select="$ref//fn:string[@key='title']" />",
          author = "<xsl:for-each select="$ref//fn:array[@key='authors']/fn:string[position() &lt;= $maxauthors]">
              <xsl:value-of select="." />
              <xsl:if test="position() != last() and not(position() >= $maxauthors) ">, </xsl:if>
          </xsl:for-each>
          <xsl:if test="count($ref//fn:array[@key='authors']/fn:string) > $maxauthors">
              et al.
          </xsl:if>",
          year="<xsl:value-of select="substring(($ref//fn:string[@key='publishedDate'])[1], 1, 4)" />"
        }
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template name="list-references">
    <xsl:param name="text" />
    <xsl:if test="count($text//ref)">
      <h3>Références</h3>
      <div class="further-readings">
        <ul>
          <xsl:for-each-group select="$text//ref[@doi]" group-by="@doi">
            <li>
              <xsl:call-template name="ref-description">
                <xsl:with-param name="doi" select="./@doi" />
                <xsl:with-param name="isbn" select="''" />
              </xsl:call-template>
            </li>
          </xsl:for-each-group>
          <xsl:for-each-group select="$text//ref[@isbn]" group-by="@isbn">
            <li>
              <xsl:call-template name="ref-description">
                <xsl:with-param name="doi" select="''" />
                <xsl:with-param name="isbn" select="./@isbn" />
              </xsl:call-template>
            </li>
          </xsl:for-each-group>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="figure">
      \begin{figure}[H]
      \centering
      <xsl:variable name="extension" select="substring(./@src, string-length(./@src)-2, 3)" />
      <xsl:if test="$extension = 'jpg' or $extension = 'png'">
      \includegraphics[width=0.9\textwidth]{../images/<xsl:value-of select="./@src" />}
      </xsl:if>
      \caption{\textbf{<xsl:value-of select="./@title" />}. <xsl:apply-templates select="text()" />}
      \end{figure}
  </xsl:template>
  
  <xsl:template match="feynman">
    <div class="feynman" data-fid="{./@id}"><div class="diagram"></div><span class="caption"><b><xsl:value-of select="./@title" /> </b></span></div>
    <script>
      $('.feynman[data-fid="<xsl:value-of select="./@id" />"] .diagram').feyn({<xsl:value-of select="." />});
    </script>
  </xsl:template>
  
  <xsl:template match="spoiler">
    <xsl:apply-templates />
  </xsl:template>
  
  <xsl:template match="quote">
      \begin{quote}
      <xsl:apply-templates />
      \end{quote}
      (<xsl:value-of select="./@author" />, <xsl:value-of select="./@date" />)
  </xsl:template>
  
  <xsl:template match="note">\footnote{<xsl:value-of select="." />}</xsl:template>
  
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
  
  <xsl:template name="disclaimer">
    <xsl:param name="article" />
    <xsl:if test="not($article/@ready=1 and $article/@reviewed=1)">
      <div class="warning">
        La rédaction de contenu n'est pas achevée. Les informations peuvent être incomplètes ou contenir des erreurs.
      </div>
    </xsl:if>
  </xsl:template>
  
<xsl:template match="/">
    \documentclass[11pt,french]{book}              % Book class in 11 points
    \usepackage[french]{babel}
    \usepackage[utf8]{inputenc} 
    \usepackage[T1]{fontenc}
    \usepackage{import}
    \subimport{.}{header}
    
    
    \parindent0pt  \parskip10pt             % make block paragraphs
    %\raggedright                            % do not right justify
    
    \title{\bf Histoire de la cosmologie \\
    \large De la Relativité Générale à la première détection d'ondes gravitationnelles}    % Supply information
    \author{Lucas Gautheron}              %   for the title page.
    \date{\today}                           %   Use current date. 
    
    % Note that book class by default is formatted to be printed back-to-back.
    \begin{document}                        % End of preamble, start of text.
    
    \frontmatter                            % only in book class (roman page #s)
    \maketitle  
    % Print title page.
    \chapter*{Avant-Propos}
    
    \section*{Pourquoi la cosmologie ?}
    
    D'abord, elle a la première qualité d'être une synthèse de toute la physique moderne. Donc, étudier la cosmologie et ses enjeux, cela implique d'aborder la relativité générale, la physique statistique et la thermodynamique, la théorie quantique des champs, le modèle standard, et même certaines de ses extensions. La cosmologie s'est toujours construite sur les dernières avancées dans tous ces domaines, et contribue même à leur développement.
    
    Une autre excellente raison de s'intéresser à la cosmologie est justement son emploi pour sonder des domaines de la physique encore inexplorés. La physique contemporaine est aujourd'hui heurtée à un mur que constitue la limite en énergie de la plupart des expériences réalisables, qu'elles exploitent des collisions dans des accélérateurs de particules ou des sources astrophysique. En revanche, l'Univers ayant atteint des températures extrêmes à ses débuts, on s'attend à ce que la cosmologie soit peut-être la plus capable d'apporter des informations nouvelles et précieuses sur de la nouvelle physique aux hautes énergies.
    
    Par ailleurs, l'histoire de la cosmologie représente en elle-même un sujet passionnant. Il est d'abord fascinant de constater la façon dont notre vision de l'Univers a radicalement changé en un siècle, au fil de découvertes majeures, parfois accidentelles, parfois nécessitant des moyens fantastiques. C'est aussi un excellent sujet pour la sociologie des sciences, tant la nouveauté des idées physiques soulevées et leurs enjeux ont pu déstabiliser la communauté scientifique et susciter parfois des débats d'ordre plutôt philosophiques. Aujourd'hui encore, cette science toujours jeune mais très prometteuse suscite parfois des controverses.
    
    Enfin, l'histoire de la physique est une dimension de la discipline à part entière qui mérite d'être étudiée. Il est très enrichissant pour un étudiant voué à la recherche, de mieux approcher l'histoire de l'invention des théories physiques, de mieux comprendre leurs origines, et la longue lutte de l'esprit humain pour décrire l'Univers qui est le sien. Ceci n'est pas toujours facile à retrouver dans les livres qui fournissent plutôt une photographie des connaissances à un instant donné, en manquant parfois les errances de leur construction, qui font de la physique une aventure passionnante.
    
    \tableofcontents                        % Print table of contents
    \mainmatter                             % only in book class (arabic page #s)
    
    <xsl:for-each select="root/contents/content">
        \chapter{<xsl:value-of select="./title" />}
        <xsl:apply-templates select="./text" />        
    </xsl:for-each>
    
    \chapter{Annexes}
    
    <xsl:for-each select="root/appendices/appendix">
        \section{<xsl:value-of select="./title" />}
        \label{ann:<xsl:value-of select="./@id" />}
        <xsl:apply-templates select="./text" />        
    </xsl:for-each>
    
    \bibliographystyle{plain}
    \bibliography{booklet}
    
    \end{document}                          % The required last line
    
    <xsl:result-document method="text" href="booklet.bib">
        <xsl:for-each-group select="/root//ref[@doi]" group-by="@doi">
            <xsl:call-template name="ref-description">
                <xsl:with-param name="doi" select="./@doi" />
                <xsl:with-param name="isbn" select="''" />
            </xsl:call-template>
        </xsl:for-each-group>
        <xsl:for-each-group select="/root//ref[@isbn]" group-by="@isbn">
            <xsl:call-template name="ref-description">
                <xsl:with-param name="doi" select="''" />
                <xsl:with-param name="isbn" select="./@isbn" />
            </xsl:call-template>
        </xsl:for-each-group>
    </xsl:result-document>
</xsl:template>
</xsl:stylesheet>