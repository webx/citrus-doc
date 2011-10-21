<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook" xmlns:xslthl="http://xslthl.sf.net"
    xmlns="http://www.w3.org/1999/xhtml" version="1.0" exclude-result-prefixes="d xslthl">

    <xsl:import href="urn:docbkx:stylesheet" />
    <xsl:import href="urn:docbkx:stylesheet/highlight.xsl" />
    <xsl:include href="../common.xsl" />

    <xsl:output indent="no" />

    <xsl:template name="user.head.content">
        <xsl:param name="node" select="." />
        <meta>
            <xsl:attribute name="http-equiv">Content-Type</xsl:attribute>
            <xsl:attribute name="content">text/html; charset=UTF-8</xsl:attribute>
        </meta>
    </xsl:template>

    <xsl:param name="html.cellpadding">10</xsl:param>
    <xsl:param name="table.borders.with.css">1</xsl:param>
    <xsl:param name="ignore.image.scaling">1</xsl:param>

    <!-- 默认不显示目录title -->
    <xsl:template name="division.toc">
        <xsl:param name="toc-context" select="." />
        <xsl:param name="toc.title.p" select="false()" />

        <xsl:call-template name="make.toc">
            <xsl:with-param name="toc-context" select="$toc-context" />
            <xsl:with-param name="toc.title.p" select="$toc.title.p" />
            <xsl:with-param name="nodes"
                select="d:part|d:reference                                          |d:preface|d:chapter|d:appendix                                          |d:article                                          |d:bibliography|d:glossary|d:index                                          |d:refentry                                          |d:bridgehead[$bridgehead.in.toc != 0]" />

        </xsl:call-template>
    </xsl:template>

    <!-- 避免anchor标签self-close。 -->
    <xsl:template name="anchor">
        <xsl:param name="node" select="." />
        <xsl:param name="conditional" select="1" />
        <xsl:variable name="id">
            <xsl:call-template name="object.id">
                <xsl:with-param name="object" select="$node" />
            </xsl:call-template>
        </xsl:variable>
        <xslo:if xmlns:xslo="http://www.w3.org/1999/XSL/Transform"
            test="not($node[parent::d:blockquote])">
            <xsl:if test="$conditional = 0 or $node/@id or $node/@xml:id">
                <a id="{$id}">
                    <xsl:comment>
                        <xsl:value-of select="'anchor '" />
                        <xsl:value-of select="$id" />
                    </xsl:comment>
                </a>
            </xsl:if>
        </xslo:if>
    </xsl:template>

    <!-- 在callout数字前后括上span，除去img alt，这样firefox复制文本时就不会包含数字。 -->
    <xsl:template name="callout-bug">
        <xsl:param name="conum" select="1" />

        <span class="calloutno">
            <xsl:choose>
                <xsl:when
                    test="$callout.graphics != 0                     and $conum &lt;= $callout.graphics.number.limit">
                    <img src="{$callout.graphics.path}{$conum}{$callout.graphics.extension}"
                        border="0" />
                </xsl:when>
                <xsl:when
                    test="$callout.unicode != 0                     and $conum &lt;= $callout.unicode.number.limit">
                    <xsl:choose>
                        <xsl:when test="$callout.unicode.start.character = 10102">
                            <xsl:choose>
                                <xsl:when test="$conum = 1">&#10102;</xsl:when>
                                <xsl:when test="$conum = 2">&#10103;</xsl:when>
                                <xsl:when test="$conum = 3">&#10104;</xsl:when>
                                <xsl:when test="$conum = 4">&#10105;</xsl:when>
                                <xsl:when test="$conum = 5">&#10106;</xsl:when>
                                <xsl:when test="$conum = 6">&#10107;</xsl:when>
                                <xsl:when test="$conum = 7">&#10108;</xsl:when>
                                <xsl:when test="$conum = 8">&#10109;</xsl:when>
                                <xsl:when test="$conum = 9">&#10110;</xsl:when>
                                <xsl:when test="$conum = 10">&#10111;</xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:message>
                                <xsl:text>Don't know how to generate Unicode callouts </xsl:text>
                                <xsl:text>when $callout.unicode.start.character is </xsl:text>
                                <xsl:value-of select="$callout.unicode.start.character" />
                            </xsl:message>
                            <xsl:text>(</xsl:text>
                            <xsl:value-of select="$conum" />
                            <xsl:text>)</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>(</xsl:text>
                    <xsl:value-of select="$conum" />
                    <xsl:text>)</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    <xsl:template match="xslthl:string" mode="xslthl">
        <strong class="hl-string">
            <em style="color:navy">
                <xsl:apply-templates mode="xslthl" />
            </em>
        </strong>
    </xsl:template>
    <xsl:template match="xslthl:comment" mode="xslthl">
        <em class="hl-comment" style="color: green">
            <xsl:apply-templates mode="xslthl" />
        </em>
    </xsl:template>
    <xsl:template match="xslthl:keyword" mode="xslthl">
        <strong class="hl-keyword" style="color: maroon">
            <xsl:apply-templates mode="xslthl" />
        </strong>
    </xsl:template>

    <!-- 覆盖原有的实现，在toc中显示：Part I，Chapter 2。-->
    <xsl:template name="toc.line">
        <xsl:param name="toc-context" select="." />

        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="local-name(.)" />
            </xsl:attribute>

            <a>
                <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                        <xsl:with-param name="context" select="$toc-context" />
                        <xsl:with-param name="toc-context" select="$toc-context" />
                    </xsl:call-template>
                </xsl:attribute>

                <xsl:apply-templates select="." mode="object.title.markup" />
            </a>
        </span>
    </xsl:template>

</xsl:stylesheet>
