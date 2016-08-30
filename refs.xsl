<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:doc="http://cosmology.education"
    exclude-result-prefixes="xs doc">
    <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
    <xsl:template match="/">
      <xsl:for-each-group select=".//ref" group-by="@doi">
          <xsl:value-of select="./@doi" /><xsl:text>&#xa;</xsl:text>
      </xsl:for-each-group>
    </xsl:template>
</xsl:stylesheet>
