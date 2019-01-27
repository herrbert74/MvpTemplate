<?xml version="1.0"?>
<globals>
	<#include "../common/globals.xml.ftl" />
	<#include "root://activities/common/kotlin_globals.xml.ftl" />
	<global id="topOut" value="." /> 
	<global id="projectOut" value="." /> 
	<global id="resOut" value="${resDir}" />
	<global id="applicationOut" value="${srcDir}/${slashedPackageName(applicationPackage)}" />
	<global id="srcOut" value="${srcDir}/${slashedPackageName(packageName)}" />
	<global id="packageOut" value="${srcOut}/${className?lower_case}" />
	<global id="baseOut" value="${srcDir}/${slashedPackageName(basePackageName)}" />
	<global id="mainSourceSetPackage" value="${packageName?replace('.debug|.staging|.systest', '', 'r')}" />
</globals>
