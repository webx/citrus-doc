<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xslthl="http://xslthl.sf.net"
    xmlns:sverb="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Verbatim"
    xmlns:xverb="com.nwalsh.xalan.Verbatim" xmlns:lxslt="http://xml.apache.org/xslt"
    xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="xlink d xslthl sverb xverb lxslt exsl " version="1.0">

    <xsl:import href="urn:docbkx:stylesheet" />
    <xsl:import href="urn:docbkx:stylesheet/highlight.xsl" />

    <xsl:include href="../common.xsl" />

    <!-- 页面设置 -->
    <xsl:param name="fop1.extensions">1</xsl:param>
    <xsl:param name="paper.type">USLetter</xsl:param>
    <xsl:param name="alignment">left</xsl:param>
    <xsl:param name="body.start.indent">4pc</xsl:param>
    <xsl:param name="admon.graphics.extension">.svg</xsl:param>

    <!-- 允许example被拆页，但是programlisting不会拆开 -->
    <xsl:attribute-set name="example.properties">
        <xsl:attribute name="keep-together.within-column">auto</xsl:attribute>
    </xsl:attribute-set>

    <!-- 图片的最大宽度，由页面宽度-2倍边距算得。 -->
    <xsl:param name="default.image.width">6.5in</xsl:param>

    <!-- 字体设置 -->
    <xsl:param name="title.font.family">SimHei, ZapfDingbats</xsl:param>
    <xsl:param name="sans.font.family">SimSun, ZapfDingbats</xsl:param>
    <xsl:param name="body.font.family">SimHei, ZapfDingbats</xsl:param>
    <xsl:param name="dingbat.font.family">SimHei, ZapfDingbats</xsl:param>
    <xsl:param name="symbol.font.family">SimHei, ZapfDingbats</xsl:param>
    <xsl:param name="monospace.font.family">Consolas, SimHei, ZapfDingbats</xsl:param>

    <!-- 定制section标题 -->
    <xsl:attribute-set name="section.title.level1.properties">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$body.font.master * 1.4641" />
            <xsl:text>pt</xsl:text>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section.title.level2.properties">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$body.font.master * 1.331" />
            <xsl:text>pt</xsl:text>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section.title.level3.properties">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$body.font.master * 1.21" />
            <xsl:text>pt</xsl:text>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section.title.level4.properties">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$body.font.master * 1.1" />
            <xsl:text>pt</xsl:text>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section.title.level5.properties">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$body.font.master" />
            <xsl:text>pt</xsl:text>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section.title.level6.properties">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$body.font.master" />
            <xsl:text>pt</xsl:text>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- 定制figure/example等标题 -->
    <xsl:attribute-set name="formal.title.properties">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$body.font.master * 0.909" />
            <xsl:text>pt</xsl:text>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- 定制figure -->
    <xsl:attribute-set name="figure.properties">
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="informalfigure.properties">
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>

    <!-- 定制programlisting/code -->
    <xsl:param name="shade.verbatim" select="1" />

    <xsl:attribute-set name="shade.verbatim.style">
        <xsl:attribute name="background-color">#F4F4F4</xsl:attribute>
        <xsl:attribute name="border-width">0.5pt</xsl:attribute>
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-color">#575757</xsl:attribute>
        <xsl:attribute name="padding">3pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="monospace.verbatim.properties">
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="wrap-option">wrap</xsl:attribute>
        <xsl:attribute name="start-indent">0pc</xsl:attribute>
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="monospace.properties">
        <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    </xsl:attribute-set>

    <!-- 定制table，对thead加背景色 -->
    <xsl:template name="table.row.properties">
        <xsl:variable name="row-height">
            <xsl:if test="processing-instruction('dbfo')">
                <xsl:call-template name="pi.dbfo_row-height" />
            </xsl:if>
        </xsl:variable>

        <xsl:if test="$row-height != ''">
            <xsl:attribute name="block-progression-dimension">
                <xsl:value-of select="$row-height" />
            </xsl:attribute>
        </xsl:if>

        <xsl:variable name="bgcolor">
            <xsl:call-template name="pi.dbfo_bgcolor" />
        </xsl:variable>

        <xsl:if test="$bgcolor != ''">
            <xsl:attribute name="background-color">
                <xsl:value-of select="$bgcolor" />
            </xsl:attribute>
        </xsl:if>

        <!-- Keep header row with next row -->
        <xsl:if test="ancestor::d:thead">
            <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
            <xsl:attribute name="color">white</xsl:attribute>
            <xsl:attribute name="background-color">#004080</xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!-- 定制table，将table字体变小，单元格内部空间调整 -->
    <xsl:template name="table.cell.block.properties">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$body.font.master * 0.8" />
            <xsl:text>pt</xsl:text>
        </xsl:attribute>

        <!-- highlight this entry? -->
        <xsl:choose>
            <xsl:when test="ancestor::d:thead or ancestor::d:tfoot">
                <xsl:attribute name="font-weight">bold</xsl:attribute>
            </xsl:when>
            <!-- Make row headers bold too -->
            <xsl:when
                test="ancestor::d:tbody and 
                (ancestor::d:table[@rowheader = 'firstcol'] or
                ancestor::d:informaltable[@rowheader = 'firstcol']) and
                ancestor-or-self::d:entry[1][count(preceding-sibling::d:entry) = 0]">
                <xsl:attribute name="font-weight">bold</xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:attribute-set name="table.cell.padding">
        <xsl:attribute name="padding-start">0.5em</xsl:attribute>
        <xsl:attribute name="padding-end">0.5em</xsl:attribute>
    </xsl:attribute-set>

    <!-- 加强语气 -->
    <xsl:template match="d:emphasis">
        <xsl:choose>
            <xsl:when test="not(@role)">
                <fo:inline color="red">
                    <xsl:apply-imports />
                </fo:inline>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-imports />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 语法高亮 -->
    <xsl:template match="xslthl:keyword" mode="xslthl">
        <fo:inline font-weight="bold" font-style="normal" color="maroon">
            <xsl:apply-templates />
        </fo:inline>
    </xsl:template>
    <xsl:template match="xslthl:string" mode="xslthl">
        <fo:inline font-weight="bold" font-style="italic" color="navy">
            <xsl:apply-templates />
        </fo:inline>
    </xsl:template>
    <xsl:template match="xslthl:comment" mode="xslthl">
        <fo:inline font-weight="normal" font-style="italic" color="green">
            <xsl:apply-templates />
        </fo:inline>
    </xsl:template>
    <xsl:template match="xslthl:directive" mode="xslthl">
        <fo:inline font-weight="normal" font-style="normal" color="maroon">
            <xsl:apply-templates />
        </fo:inline>
    </xsl:template>
    <xsl:template match="xslthl:tag" mode="xslthl">
        <fo:inline font-weight="bold" font-style="normal" color="#000096">
            <xsl:apply-templates />
        </fo:inline>
    </xsl:template>
    <xsl:template match="xslthl:attribute" mode="xslthl">
        <fo:inline font-weight="normal" font-style="normal" color="#F5844C">
            <xsl:apply-templates />
        </fo:inline>
    </xsl:template>
    <xsl:template match="xslthl:value" mode="xslthl">
        <fo:inline font-weight="normal" font-style="normal" color="#993300">
            <xsl:apply-templates />
        </fo:inline>
    </xsl:template>
    <xsl:template match="xslthl:html" mode="xslthl">
        <fo:inline font-weight="bold" font-style="italic" color="red">
            <xsl:apply-templates />
        </fo:inline>
    </xsl:template>
    <xsl:template match="xslthl:xslt" mode="xslthl">
        <fo:inline font-weight="bold" font-style="normal" color="#0066FF">
            <xsl:apply-templates />
        </fo:inline>
    </xsl:template>
    <xsl:template match="xslthl:section" mode="xslthl">
        <fo:inline font-weight="bold" font-style="normal">
            <xsl:apply-templates />
        </fo:inline>
    </xsl:template>
    <xsl:template match="xslthl:number" mode="xslthl">
        <fo:inline font-weight="normal" font-style="normal" color="navy">
            <xsl:apply-templates />
        </fo:inline>
    </xsl:template>
    <xsl:template match="xslthl:annotation" mode="xslthl">
        <fo:inline font-weight="normal" font-style="italic" color="gray">
            <xsl:apply-templates />
        </fo:inline>
    </xsl:template>

    <!-- 在table中的programlisting不加框 -->
    <xsl:template match="d:programlisting|d:screen|d:synopsis">
        <xsl:param name="suppress-numbers" select="'0'" />
        <xsl:variable name="id">
            <xsl:call-template name="object.id" />
        </xsl:variable>

        <xsl:variable name="content">
            <xsl:choose>
                <xsl:when
                    test="$suppress-numbers = '0'
                    and @linenumbering = 'numbered'
                    and $use.extensions != '0'
                    and $linenumbering.extension != '0'">
                    <xsl:call-template name="number.rtf.lines">
                        <xsl:with-param name="rtf">
                            <xsl:choose>
                                <xsl:when test="$highlight.source != 0">
                                    <xsl:call-template name="apply-highlighting" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$highlight.source != 0">
                            <xsl:call-template name="apply-highlighting" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="block.content">
            <xsl:choose>
                <xsl:when
                    test="$shade.verbatim != 0 and not(ancestor::d:table or ancestor::d:informaltable)">
                    <fo:block id="{$id}"
                        xsl:use-attribute-sets="monospace.verbatim.properties shade.verbatim.style">
                        <xsl:choose>
                            <xsl:when
                                test="$hyphenate.verbatim != 0 and 
                                $exsl.node.set.available != 0">
                                <xsl:apply-templates select="exsl:node-set($content)"
                                    mode="hyphenate.verbatim" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="$content" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>
                </xsl:when>
                <xsl:otherwise>
                    <fo:block id="{$id}" xsl:use-attribute-sets="monospace.verbatim.properties">
                        <xsl:choose>
                            <xsl:when
                                test="$hyphenate.verbatim != 0 and 
                                $exsl.node.set.available != 0">
                                <xsl:apply-templates select="exsl:node-set($content)"
                                    mode="hyphenate.verbatim" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="$content" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <!-- Need a block-container for these features -->
            <xsl:when
                test="@width != '' or
                (self::d:programlisting and
                starts-with($writing.mode, 'rl'))">
                <fo:block-container start-indent="0pt" end-indent="0pt">
                    <xsl:if test="@width != ''">
                        <xsl:attribute name="width">
                            <xsl:value-of
                                select="concat(@width, '*', $monospace.verbatim.font.width)" />
                        </xsl:attribute>
                    </xsl:if>
                    <!-- All known program code is left-to-right -->
                    <xsl:if
                        test="self::d:programlisting and
                        starts-with($writing.mode, 'rl')">
                        <xsl:attribute name="writing-mode">lr-tb</xsl:attribute>
                    </xsl:if>
                    <xsl:copy-of select="$block.content" />
                </fo:block-container>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$block.content" />
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- 覆盖原有的实现，在toc中显示：Part I，Chapter 2。-->
    <xsl:template name="toc.line">
        <xsl:param name="toc-context" select="NOTANODE" />

        <xsl:variable name="id">
            <xsl:call-template name="object.id" />
        </xsl:variable>

        <fo:block xsl:use-attribute-sets="toc.line.properties">
            <xsl:if test="self::d:preface or self::d:part">
                <xsl:attribute name="margin-top">0.7em</xsl:attribute>
                <xsl:attribute name="margin-bottom">0.3em</xsl:attribute>
                <xsl:attribute name="padding">0.2em</xsl:attribute>
            </xsl:if>

            <fo:inline keep-with-next.within-line="always">
                <fo:basic-link internal-destination="{$id}">
                    <xsl:apply-templates select="." mode="object.title.markup" />
                </fo:basic-link>
            </fo:inline>
            <fo:inline keep-together.within-line="always">
                <xsl:text> </xsl:text>
                <fo:leader leader-pattern="dots" leader-pattern-width="3pt"
                    leader-alignment="reference-area" keep-with-next.within-line="always" />
                <xsl:text> </xsl:text>
                <fo:basic-link internal-destination="{$id}">
                    <fo:page-number-citation ref-id="{$id}" />
                </fo:basic-link>
            </fo:inline>
        </fo:block>
    </xsl:template>

    <xsl:attribute-set name="toc.line.properties">
        <xsl:attribute name="margin">0.2em</xsl:attribute>
    </xsl:attribute-set>

    <!-- variablelist设置 -->
    <xsl:param name="variablelist.as.blocks">1</xsl:param>

    <xsl:attribute-set name="variablelist.term.properties">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="margin-top">0.7em</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.5em</xsl:attribute>
        <xsl:attribute name="color">navy</xsl:attribute>
    </xsl:attribute-set>

    <!-- imageobject设置：将scale-to-fit改成scale-down-to-fit，只缩小，不放大。 -->
    <xsl:template name="process.image">
        <!-- When this template is called, the current node should be  -->
        <!-- a graphic, inlinegraphic, imagedata, or videodata. All    -->
        <!-- those elements have the same set of attributes, so we can -->
        <!-- handle them all in one place.                             -->

        <xsl:variable name="scalefit">
            <xsl:choose>
                <xsl:when test="$ignore.image.scaling != 0">0</xsl:when>
                <xsl:when test="@contentwidth">0</xsl:when>
                <xsl:when test="@contentdepth and 
                    @contentdepth != '100%'"
                    >0</xsl:when>
                <xsl:when test="@scale">0</xsl:when>
                <xsl:when test="@scalefit">
                    <xsl:value-of select="@scalefit" />
                </xsl:when>
                <xsl:when test="@width or @depth">1</xsl:when>
                <xsl:when test="$default.image.width != ''">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="scale">
            <xsl:choose>
                <xsl:when test="$ignore.image.scaling != 0">0</xsl:when>
                <xsl:when test="@contentwidth or @contentdepth">1.0</xsl:when>
                <xsl:when test="@scale">
                    <xsl:value-of select="@scale div 100.0" />
                </xsl:when>
                <xsl:otherwise>1.0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="filename">
            <xsl:choose>
                <xsl:when
                    test="local-name(.) = 'graphic'
                    or local-name(.) = 'inlinegraphic'">
                    <!-- handle legacy graphic and inlinegraphic by new template -->
                    <xsl:call-template name="mediaobject.filename">
                        <xsl:with-param name="object" select="." />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <!-- imagedata, videodata, audiodata -->
                    <xsl:call-template name="mediaobject.filename">
                        <xsl:with-param name="object" select=".." />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="content-type">
            <xsl:if test="@format">
                <xsl:call-template name="graphic.format.content-type">
                    <xsl:with-param name="format" select="@format" />
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="bgcolor">
            <xsl:call-template name="pi.dbfo_background-color">
                <xsl:with-param name="node" select=".." />
            </xsl:call-template>
        </xsl:variable>

        <fo:external-graphic>
            <xsl:attribute name="src">
                <xsl:call-template name="fo-external-image">
                    <xsl:with-param name="filename">
                        <xsl:if
                            test="$img.src.path != '' and
                            not(starts-with($filename, '/')) and
                            not(contains($filename, '://'))">
                            <xsl:value-of select="$img.src.path" />
                        </xsl:if>
                        <xsl:value-of select="$filename" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:attribute>

            <xsl:attribute name="width">
                <xsl:choose>
                    <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
                    <xsl:when test="contains(@width,'%')">
                        <xsl:value-of select="@width" />
                    </xsl:when>
                    <xsl:when test="@width and not(@width = '')">
                        <xsl:call-template name="length-spec">
                            <xsl:with-param name="length" select="@width" />
                            <xsl:with-param name="default.units" select="'px'" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="not(@depth) and $default.image.width != ''">
                        <xsl:call-template name="length-spec">
                            <xsl:with-param name="length" select="$default.image.width" />
                            <xsl:with-param name="default.units" select="'px'" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>auto</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <xsl:attribute name="height">
                <xsl:choose>
                    <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
                    <xsl:when test="contains(@depth,'%')">
                        <xsl:value-of select="@depth" />
                    </xsl:when>
                    <xsl:when test="@depth">
                        <xsl:call-template name="length-spec">
                            <xsl:with-param name="length" select="@depth" />
                            <xsl:with-param name="default.units" select="'px'" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>auto</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <xsl:attribute name="content-width">
                <xsl:choose>
                    <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
                    <xsl:when test="contains(@contentwidth,'%')">
                        <xsl:value-of select="@contentwidth" />
                    </xsl:when>
                    <xsl:when test="@contentwidth">
                        <xsl:call-template name="length-spec">
                            <xsl:with-param name="length" select="@contentwidth" />
                            <xsl:with-param name="default.units" select="'px'" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="number($scale) != 1.0">
                        <xsl:value-of select="$scale * 100" />
                        <xsl:text>%</xsl:text>
                    </xsl:when>
                    <xsl:when test="$scalefit = 1">scale-down-to-fit</xsl:when>
                    <xsl:otherwise>auto</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <xsl:attribute name="content-height">
                <xsl:choose>
                    <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
                    <xsl:when test="contains(@contentdepth,'%')">
                        <xsl:value-of select="@contentdepth" />
                    </xsl:when>
                    <xsl:when test="@contentdepth">
                        <xsl:call-template name="length-spec">
                            <xsl:with-param name="length" select="@contentdepth" />
                            <xsl:with-param name="default.units" select="'px'" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="number($scale) != 1.0">
                        <xsl:value-of select="$scale * 100" />
                        <xsl:text>%</xsl:text>
                    </xsl:when>
                    <xsl:when test="$scalefit = 1">scale-down-to-fit</xsl:when>
                    <xsl:otherwise>auto</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <xsl:if test="$content-type != ''">
                <xsl:attribute name="content-type">
                    <xsl:value-of select="concat('content-type:',$content-type)" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="$bgcolor != ''">
                <xsl:attribute name="background-color">
                    <xsl:value-of select="$bgcolor" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="@align">
                <xsl:attribute name="text-align">
                    <xsl:value-of select="@align" />
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="@valign">
                <xsl:attribute name="display-align">
                    <xsl:choose>
                        <xsl:when test="@valign = 'top'">before</xsl:when>
                        <xsl:when test="@valign = 'middle'">center</xsl:when>
                        <xsl:when test="@valign = 'bottom'">after</xsl:when>
                        <xsl:otherwise>auto</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
        </fo:external-graphic>
    </xsl:template>

    <!-- 交叉引用 -->
    <xsl:attribute-set name="xref.properties">
        <xsl:attribute name="color">blue</xsl:attribute>
    </xsl:attribute-set>

    <!-- 设置bookmark的show/hide，打开chapter及以上目录，折叠更细的目录。 -->
    <xsl:param name="bookmarks.collapse" select="1" />

    <xsl:template match="d:set|d:book|d:part" mode="fop1.outline">
        <xsl:call-template name="customized-bookmark">
            <xsl:with-param name="bookmarks.state">show</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="customized-bookmark">
        <xsl:param name="bookmarks.state">hide</xsl:param>

        <xsl:variable name="id">
            <xsl:call-template name="object.id" />
        </xsl:variable>
        <xsl:variable name="bookmark-label">
            <xsl:apply-templates select="." mode="object.title.markup" />
        </xsl:variable>

        <!-- Put the root element bookmark at the same level as its children -->
        <!-- If the object is a set or book, generate a bookmark for the toc -->

        <xsl:choose>
            <xsl:when test="self::d:index and $generate.index = 0" />
            <xsl:when test="parent::*">
                <fo:bookmark internal-destination="{$id}">
                    <xsl:attribute name="starting-state">
                        <xsl:value-of select="$bookmarks.state" />
                    </xsl:attribute>
                    <fo:bookmark-title>
                        <xsl:value-of
                            select="normalize-space(translate($bookmark-label, $a-dia, $a-asc))" />
                    </fo:bookmark-title>
                    <xsl:apply-templates select="*" mode="fop1.outline" />
                </fo:bookmark>
            </xsl:when>
            <xsl:otherwise>
                <fo:bookmark internal-destination="{$id}">
                    <xsl:attribute name="starting-state">
                        <xsl:value-of select="$bookmarks.state" />
                    </xsl:attribute>
                    <fo:bookmark-title>
                        <xsl:value-of
                            select="normalize-space(translate($bookmark-label, $a-dia, $a-asc))" />
                    </fo:bookmark-title>
                </fo:bookmark>

                <xsl:variable name="toc.params">
                    <xsl:call-template name="find.path.params">
                        <xsl:with-param name="table" select="normalize-space($generate.toc)" />
                    </xsl:call-template>
                </xsl:variable>

                <xsl:if
                    test="contains($toc.params, 'toc')
                    and (d:book|d:part|d:reference|d:preface|d:chapter|d:appendix|d:article
                    |d:glossary|d:bibliography|d:index|d:setindex
                    |d:refentry
                    |d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:section)">
                    <fo:bookmark internal-destination="toc...{$id}">
                        <fo:bookmark-title>
                            <xsl:call-template name="gentext">
                                <xsl:with-param name="key" select="'TableofContents'" />
                            </xsl:call-template>
                        </fo:bookmark-title>
                    </fo:bookmark>
                </xsl:if>
                <xsl:apply-templates select="*" mode="fop1.outline" />
            </xsl:otherwise>
        </xsl:choose>
        <!--
            <fo:bookmark internal-destination="{$id}"/>
        -->
    </xsl:template>

    <!-- callout前后加点空白 -->
    <xsl:template match="d:callout">
        <xsl:variable name="id">
            <xsl:call-template name="object.id" />
        </xsl:variable>

        <xsl:variable name="keep.together">
            <xsl:call-template name="pi.dbfo_keep-together" />
        </xsl:variable>

        <fo:list-item id="{$id}" margin-top="0.5em" margin-bottom="0.7em">
            <xsl:if test="$keep.together != ''">
                <xsl:attribute name="keep-together.within-column">
                    <xsl:value-of select="$keep.together" />
                </xsl:attribute>
            </xsl:if>
            <fo:list-item-label end-indent="label-end()">
                <fo:block>
                    <xsl:call-template name="callout.arearefs">
                        <xsl:with-param name="arearefs" select="@arearefs" />
                    </xsl:call-template>
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    <xsl:apply-templates />
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>

    <!-- 让calloutlist和前一个block保持在一页 -->
    <xsl:template match="d:calloutlist">
        <fo:block keep-with-previous.within-column="always" keep-together.within-column="auto">
            <xsl:apply-imports />
        </fo:block>
    </xsl:template>

    <!-- 插入空白使callout number自动换行 -->
    <xsl:template match="d:co" mode="callout-bug">
        <xsl:apply-imports />
        <xsl:value-of select="'&#8203;'" />
    </xsl:template>

</xsl:stylesheet>
