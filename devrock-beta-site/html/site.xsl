<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<!--
	<xsl:output method="html" encoding="UTF-8"/>
-->
	<xsl:key name="cat" match="category" use="@name"/>
	<!-- includes an external file that declares variables to be used -->
	
	<xsl:param name="text-encoding" select="'iso-8859-1'"/>
	<xsl:param name="text-uri"  select="'../html/description.txt'"/>
	
	<xsl:include href="../html/variables.xslt" />
	<xsl:template match="/">
		<xsl:for-each select="site">
			<html>
				<head>
					<title> 
						<xsl:value-of select="$title"/> 
					</title>
					<style>@import url("html/site.css");</style>
				</head>
				<body>
					<h1 class="title"><xsl:value-of select="$title"/> </h1>
					
					<a class="doclinkText" href="{$doclink}">
						 <xsl:value-of select="$doctitle"/> 
					</a>


					<pre class="descriptionText">
						<xsl:value-of select="unparsed-text($text-uri, $text-encoding)"/>
					</pre>
					
				

										
					<table width="100%" border="0" cellspacing="1" cellpadding="2">
						<!-- loop over category definition -->
						<xsl:for-each select="category-def">
							<!-- sort categories -->
							<xsl:sort select="@label" order="ascending" case-order="upper-first"/>
							<xsl:sort select="@name" order="ascending" case-order="upper-first"/>
							<!-- check if there are any categories with the current name -->
							<xsl:if test="count(key('cat',@name)) != 0">
								<!-- produce a table with cat-name and cat-label -->
								<tr class="header">
								<!--
									<td class="sub-header" width="30%">
										<xsl:value-of select="@name"/>
									</td>
								-->
									<td class="sub-header" width="100%">
										<xsl:value-of select="@label"/>
									</td>
								</tr>
								<!-- loop over all categories with this name -->
								<xsl:for-each select="key('cat',@name)">
									<!-- sort by name of the owning tag (feature) -->
									<xsl:sort select="ancestor::feature//@version" order="ascending"/>
									<xsl:sort select="ancestor::feature//@id" order="ascending" case-order="upper-first"/>
									<tr>
										<!-- zebra rows -->
										<xsl:choose>
											<xsl:when test="(position() mod 2 = 1)">
												<xsl:attribute name="class">dark-row</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">light-row</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
										<!-- left column : name -->
										<td class="log-text" id="indent">
											<xsl:choose>
												<xsl:when test="ancestor::feature//@label">
													<a href="{ancestor::feature//@url}">
														<xsl:value-of select="ancestor::feature//@label"/>
													</a>
													<br/>
													<div id="indent">
														(<xsl:value-of select="ancestor::feature//@id"/> - <xsl:value-of select="ancestor::feature//@version"/>)
													</div>
												</xsl:when>
												<xsl:otherwise>
													<a href="{ancestor::feature//@url}">
														<xsl:value-of select="ancestor::feature//@id"/> - <xsl:value-of select="ancestor::feature//@version"/>
													</a>
												</xsl:otherwise>
											</xsl:choose>
											<br/>
										</td>
										<!-- empty cell -->
										<td/>
									</tr>
								</xsl:for-each>
								<tr>
									<td class="spacer">
										<br/>
									</td>
									<td class="spacer">
										<br/>
									</td>
								</tr>
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="count(feature)  &gt; count(feature/category)">
							<tr class="header">
								<td class="sub-header" colspan="2">
								Uncategorized
								</td>
							</tr>
						</xsl:if>												
						<xsl:for-each select="feature[not(category)]">
							<xsl:sort select="@id" order="ascending" case-order="upper-first"/>
							<xsl:sort select="@version" order="ascending"/>
							<tr>
								<xsl:choose>
									<xsl:when test="count(preceding-sibling::feature[not(category)]) mod 2 = 1">
										<xsl:attribute name="class">dark-row</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="class">light-row</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
								<td class="log-text" id="indent">
									<xsl:choose>
										<xsl:when test="@label">
											<a href="{@url}">
												<xsl:value-of select="@label"/>
											</a>
											<br/>
											<div id="indent">
		(<xsl:value-of select="@id"/> - <xsl:value-of select="@version"/>)
		</div>
										</xsl:when>
										<xsl:otherwise>
											<a href="{@url}">
												<xsl:value-of select="@id"/> - <xsl:value-of select="@version"/>
											</a>
										</xsl:otherwise>
									</xsl:choose>
									<br/>
									<br/>										
								</td>
								<!-- empty cell -->
								<td/>
							</tr>
						</xsl:for-each>						
					</table>
				</body>
			</html>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
