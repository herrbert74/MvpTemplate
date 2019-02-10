package ${fullPackageName}

import ${basePackageName}.mvp.BaseState
<#if isList>
import ${fullPackageName}.list.Abstract${className}Visitable
</#if>

enum class ContentChange {
	NONE,
	<#if isCall>
		<#if isList>
	${listClassNamePlural?upper_case}_RECEIVED
		<#else>
	${className?upper_case}_RECEIVED
		</#if>
	</#if>
}

data class ${className}State(
	<#if isList>
		var ${listClassName?uncap_first}Items: List<Abstract${className}Visitable>?
	<#else>
		var ${className?uncap_first}: ${className}?,
	</#if>
	<#if isList>
	var totalCount: Int? = null,
	</#if>
	<#if isParameter>
	var ${parameterName}: ${parameterType}? = "",
	</#if>
	var contentChange: ContentChange = ContentChange.NONE
) : BaseState(), Parcelable