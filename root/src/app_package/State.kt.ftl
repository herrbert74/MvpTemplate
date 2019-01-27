package ${fullPackageName}

import ${basePackageName}.mvp.BaseState
import ${fullPackageName}.list.${className}Visitable

enum class ContentChange {
	NONE,
	${listClassNamePlural?upper_case}_RECEIVED
}

data class ${className}State(
		var ${listClassName?uncap_first}Items: List<${className}Visitable>? = null
) : BaseState() {
	/*var page: Int? = null
	var perPage: Int? = null
	var total: Int? = null*/
	var ${parameterName}: ${parameterType}? = ""
	var contentChange: ContentChange = ContentChange.NONE
}