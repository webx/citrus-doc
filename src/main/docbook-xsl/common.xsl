<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xslthl="http://xslthl.sf.net"
    xmlns:sverb="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Verbatim"
    xmlns:xverb="com.nwalsh.xalan.Verbatim" xmlns:lxslt="http://xml.apache.org/xslt"
    xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="xlink d xslthl sverb xverb lxslt exsl " version="1.0">

    <xsl:param name="formal.title.placement"><![CDATA[
        figure after
        example before
        equation after
        table before
        procedure before
        task before
    ]]></xsl:param>

    <xsl:param name="generate.toc"><![CDATA[
        appendix toc
        article/appendix nop
        article toc
        book toc
        chapter toc
        part toc
        preface toc
        qandadiv toc
        qandaset toc
        reference toc
        sect1 toc
        sect2 toc
        sect3 toc
        sect4 toc
        sect5 toc
        section toc
        set toc
    ]]></xsl:param>

    <xsl:param name="use.extensions">1</xsl:param>
    <xsl:param name="tablecolumns.extension">1</xsl:param>
    <xsl:param name="graphicsize.extension">0</xsl:param>

    <xsl:param name="highlight.source">1</xsl:param>

    <xsl:param name="callout.unicode">0</xsl:param>
    <xsl:param name="callout.graphics">1</xsl:param>
    <xsl:param name="navig.graphics">0</xsl:param>
    <xsl:param name="admon.graphics">1</xsl:param>

    <xsl:param name="section.autolabel">1</xsl:param>
    <xsl:param name="section.label.includes.component.label">1</xsl:param>

    <xsl:param name="formal.object.break.after">0</xsl:param>

    <xsl:param name="table.frame.border.color">#6666cc</xsl:param>
    <xsl:param name="table.cell.border.color">#6666cc</xsl:param>

</xsl:stylesheet>
