<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:doc="http://cosmology.education"
    exclude-result-prefixes="xs doc">
    <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
    <xsl:template match="/">
      <xsl:for-each-group select=".//ref[@doi]" group-by="@doi">
          doi:<xsl:value-of select="./@doi" />
      </xsl:for-each-group>
      <xsl:for-each-group select=".//ref[@arxiv]" group-by="@arxiv">
          arxiv:<xsl:value-of select="./@arxiv" />
      </xsl:for-each-group>
      <xsl:for-each-group select=".//ref[@isbn]" group-by="@isbn">
          isbn:<xsl:value-of select="./@isbn" />
      </xsl:for-each-group>
    </xsl:template>
</xsl:stylesheet>
