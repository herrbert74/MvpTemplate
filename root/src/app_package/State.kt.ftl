package ${fullPackageName}

import android.os.Parcelable
import ${basePackageName}.mvp.BaseState
<#if isList>
import ${fullPackageName}.list.Abstract${className}Visitable
</#if>
import kotlinx.android.parcel.Parcelize

enum class ContentChange {
	NONE,
	<#if isList>
	${camelCaseToUnderscore(listClassNamePlural)?upper_case}_RECEIVED
	<#elseif isCall>
	${camelCaseToUnderscore(className)?upper_case}_RECEIVED
	<#elseif isParameter>
	${camelCaseToUnderscore(parameterName)?upper_case}_RECEIVED
	</#if>
}

@Parcelize
data class ${className}State(
	<#if isList>
		var ${listClassName?uncap_first}Items: List<Abstract${className}Visitable>?,
	<#elseif isCall>
		var ${className?uncap_first}: ${className}?,
	</#if>
	<#if isPaging>
	var totalCount: Int? = null,
	</#if>
	<#if isParameter>
	var ${parameterName}: ${parameterType}? = "",
	</#if>
	var contentChange: ContentChange = ContentChange.NONE
) : BaseState(), Parcelable