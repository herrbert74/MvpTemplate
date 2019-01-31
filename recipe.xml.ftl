<?xml version="1.0"?>
<#import "root://activities/common/kotlin_macros.ftl" as kt>
<recipe>
	<@kt.addAllKotlinDependencies />
	<instantiate from="root/src/app_package/Activity.kt.ftl"
		to="${packageOut}/${className}Activity.kt" />
	<instantiate from="root/res/layout/activity.xml.ftl"
		to="${escapeXmlAttribute(resOut)}/layout/activity_${className?uncap_first}.xml" />
	<merge from="root/AndroidManifest.xml.ftl"
		to="${escapeXmlAttribute(manifestOut)}/AndroidManifest.xml" />
	<!-- Kotlin or Java files cannot be merged currently -->
	<!--merge from="root/src/app_package/ApplicationComponent.kt.ftl"
		to="${escapeXmlAttribute(projectOut)}/src/main/java/${slashedPackageName(applicationPackage)}/injection/ApplicationComponent.kt" /-->

	<open file="${escapeXmlAttribute(packageOut)}/${className}Activity.kt"/>
	
		
	<#if isCall>
		<instantiate from="root/src/app_package/Presenter.kt.ftl"
			to="${escapeXmlAttribute(packageOut)}/${className}Presenter.kt" />
		<instantiate from="root/src/app_package/State.kt.ftl"
			to="${escapeXmlAttribute(packageOut)}/${className}State.kt" />
		<instantiate from="root/src/app_package/ViewModel.kt.ftl"
			to="${escapeXmlAttribute(packageOut)}/${className}ViewModel.kt" />
			
		<open file="${packageOut}/${className}Presenter.kt"/>
		<open file="${packageOut}/${className}State.kt"/>
		<open file="${packageOut}/${className}ViewModel.kt"/>

	</#if>

	<#if isList>
		<instantiate from="root/src/app_package/Adapter.kt.ftl"
			to="${escapeXmlAttribute(packageOut)}/list/${className}Adapter.kt" />
		<instantiate from="root/src/app_package/TypeFactory.kt.ftl"
			to="${escapeXmlAttribute(packageOut)}/list/${className}TypeFactory.kt" />
		<instantiate from="root/src/app_package/Viewholders.kt.ftl"
			to="${escapeXmlAttribute(packageOut)}/list/${className}Viewholders.kt" />
		<instantiate from="root/src/app_package/ListItems.kt.ftl"
			to="${escapeXmlAttribute(packageOut)}/list/${className}ListItems.kt" />
		<instantiate from="root/src/app_package/Visitables.kt.ftl"
			to="${escapeXmlAttribute(packageOut)}/list/${className}Visitables.kt" />
		<instantiate from="root/res/layout/row.xml.ftl"
			to="${escapeXmlAttribute(resOut)}/layout/row_${className?uncap_first}.xml" />
			
		<open file="${packageOut}/list/${className}Adapter.kt"/>
		<!--open file="${srcOut}/list/${className}TypeFactory.kt"/>
		<open file="${srcOut}/list/${className}Viewholders.kt"/>
		<open file="${srcOut}/list/${className}ListItems.kt"/>
		<open file="${srcOut}/list/${className}Visitables.kt"/-->
	</#if>

</recipe>
