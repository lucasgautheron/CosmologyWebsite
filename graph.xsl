<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:doc="http://cosmology.education"
    exclude-result-prefixes="xs doc">

    <xsl:template match="/">
        <html>
            <head>
                <title>Structure</title>
                <meta charset="utf-8" />
                <style type="text/css">
                .label-color {
	padding:2px 4px;
	font-size:12px;
	font-weight:bold;
	border-radius:2px;
	box-shadow:inset 0 -1px 0 rgba(0,0,0,0.12);
    color: white;
    margin-right: 5px;
                }
                </style>
            </head>
            <body>
                <ul>
                    <xsl:for-each select="root/contents/content">
                        <xsl:variable name="id" select="./@id"/>
                        <xsl:variable name="uid" select="./@uid"/>
                        <xsl:variable name="text" select="./text"/>

                        <li><h3><a href="/{$id}/"><xsl:value-of select="./title" /></a></h3>
                        <xsl:choose>
                        <xsl:when test="./@ready">
                           <span class="label-color" style="background-color: #fcfc29;" title="ready">ready</span>
                        </xsl:when>
                        <xsl:otherwise>
                        </xsl:otherwise>
                        </xsl:choose>

                        <xsl:choose>
                        <xsl:when test="./@reviewed">
                          <span class="label-color" style="background-color: #29fc29;" title="relecture faite">relecture faite</span>
                        </xsl:when>
                        <xsl:otherwise>
                          <span class="label-color" style="background-color: #fc2929;" title="relecture en attente">relecture en attente</span>
                        </xsl:otherwise>
                        </xsl:choose><br />
                            <h4>Evènements</h4>
                            <ul>
                                <xsl:for-each select="//root/events/event[@content-id=$uid]">
                                    <li><xsl:value-of select="."/></li>
                                </xsl:for-each>
                            </ul>
                            <h4>appendices</h4>
                            <ul>
                                <xsl:for-each-group select="//appendices/appendix/linkwords/linkword[contains($text, .)]" group-by="../../@id">
                                    <li><a href="/{$id}/{../../@id}/"><xsl:value-of select="../../title"/></a></li>
                                </xsl:for-each-group>
                            </ul>
                            <h4>Références</h4>
                            <ul>
                                <xsl:for-each select="//root/references/reference[@content-id=$id]">
                                    <li><xsl:value-of select="./title"/></li>
                                </xsl:for-each>
                            </ul>
                        </li>
                    </xsl:for-each>
                </ul>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
